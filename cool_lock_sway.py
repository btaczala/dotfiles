#!/usr/bin/env python3
import pgrep, json
import subprocess, os, random
import tempfile, time
import gi
gi.require_version('Playerctl', '2.0')

from gi.repository import Playerctl, GLib
from PIL import ImageFilter, Image

rick="~/dotfiles/rick.png"
background="~/dotfiles/walls/trees.jpg"
swaylockCmd=['swaylock']
mpv=['mpv']
player = Playerctl.Player()
manager = Playerctl.PlayerManager()

sway_background = tempfile.NamedTemporaryFile()

# check which player is playing
playing_player=""

for name in manager.props.player_names:
    localPlayer = Playerctl.Player.new_from_name(name)
    localStatus = localPlayer.get_property('status')
    print('Status {:s} is {:s}'.format(name.name, localStatus))
    if localStatus.startswith("Playing"):
        playing_player = name

sw = pgrep.pgrep("swaylock")

if sw:
    exit

def timing(f):
    def wrap(*args):
        time1 = time.time()
        ret = f(*args)
        time2 = time.time()
        print('{:s} function took {:.3f} ms'.format(f.__name__, (time2-time1)*1000.0))

        return ret
    return wrap

def get_outputs():
    outp = subprocess.check_output(["swaymsg", "-t", "get_outputs"])
    for screen in json.loads(outp):
        if screen["active"] == False:
            continue
        o = screen["name"]
        w,h = screen["rect"]["width"], screen["rect"]["height"]
        x,y = screen["rect"]["x"], screen["rect"]["y"]
        yield o, (w,h), (x,y)

@timing
def make_screenshot(output_file, position, size, scale):
    x,y = position
    w,h = size
    subprocess.call([
        "grim",
        "-g", "%d,%d %dx%d" % (x,y,w,h),
        output_file
    ])
    im = Image.open(output_file).convert('RGBA')
    os.remove(output_file)
    return im

@timing
def blend_rick(background, rick, result):
    cmd='/usr/bin/convert -composite {} {} -gravity South -geometry -20x1200 {}'.format(background, rick, result)
    subprocess.call(cmd, shell=True)

@timing
def blend_rick2(im, rick):
    rick = os.path.expanduser(rick)
    rick_image = Image.open(rick).convert('RGBA')
    im.alpha_composite(rick_image, (int((im.width / 2) - (rick_image.width / 2)),im.height - rick_image.height))
    return im

@timing
def blur(image, blur):
    return image.filter(ImageFilter.GaussianBlur(blur))

def pause_player(name):
    print('Pausing {:s} '.format(name.name))
    player = Playerctl.Player.new_from_name(name)
    player.pause()

def play_player(name):
    print('Playing {:s} '.format(name.name))
    player = Playerctl.Player.new_from_name(name)
    player.play()


@timing
def prepare_backgroud():
    blur_radius = 5
    args=[]
    for i,(o, (w,h), (x,y)) in enumerate(get_outputs()):
        screenshot_path = "/tmp/swaylock-python%d.png" % i

        im = make_screenshot(screenshot_path, (x,y), (w,h), 200)
        im = blur(im, blur_radius)

         # blend_rick(screenshot_path, rick, screenshot_path)
        im = blend_rick2(im, rick)
        im.save(screenshot_path)
        args.extend(["--image", "%s:%s" % (o, screenshot_path)])
    return args

images = prepare_backgroud()
if playing_player:
    pause_player(playing_player)

# swaylockCmd.extend(images)
file=random.choice(os.listdir("%s" % os.path.expanduser("~/ss")))
print(file)
p = subprocess.Popen(['mpv', '--hwdec=vaapi', '--title=screensaver', "%s" % os.path.expanduser("~/ss/%s" % file)])
# subprocess.call(mpv)
swaylockCmd.extend(["-c", "00000005"])
print(swaylockCmd)
subprocess.call(swaylockCmd)


print("kill")
p.kill()
if playing_player:
    play_player(playing_player)
