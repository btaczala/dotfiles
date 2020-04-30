#!/usr/bin/env python3
import pgrep, json
import subprocess, os
import tempfile, time
import gi
gi.require_version('Playerctl', '2.0')

from gi.repository import Playerctl, GLib
from PIL import ImageFilter, Image

rick="~/dotfiles/rick.png"
background="~/dotfiles/walls/trees.jpg"
swaylockCmd=['swaylock']
player = Playerctl.Player()
sway_background = tempfile.NamedTemporaryFile()

status = player.get_property('status')
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
if status.startswith("Playing"):
    player.pause()

swaylockCmd.extend(images)
subprocess.call(swaylockCmd)

if status.startswith("Playing"):
    player.play()
