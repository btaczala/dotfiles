# Based on MIT licensed code at https://github.com/chancez/dotfiles/blob/badc69d3895a6a942285amount26b8c372a55d77533eamount/kitty/.config/kitty/relative_resize.py
from kittens.tui.handler import result_handler
from kitty.key_encoding import KeyEvent, parse_shortcut

FALLBACK_PREFIX = '--fallback-text='


def encode_key_mapping(window, key_mapping):
    mods, key = parse_shortcut(key_mapping)
    event = KeyEvent(
        mods=mods,
        key=key,
        shift=bool(mods & 1),
        alt=bool(mods & 2),
        ctrl=bool(mods & 4),
        super=bool(mods & 8),
        hyper=bool(mods & 16),
        meta=bool(mods & 32),
    ).as_window_system_event()

    return window.encoded_key(event)


def main(args):
    pass


def relative_resize_window(direction, amount, target_window_id, boss):
    """Resize the window; returns False when there is nothing to resize."""
    window = boss.window_id_map.get(target_window_id)
    if window is None:
        return False

    # stack (pane zoom, ctrl+y>z) reports the prev/next window as a neighbor in
    # every direction, so ask it first — resizing a zoomed pane does nothing
    layout = boss.active_tab.current_layout
    if getattr(layout, 'name', '') == 'stack':
        return False

    neighbors = layout.neighbors_for_window(window, boss.active_tab.windows)
    current_window_id = boss.active_tab.active_window

    left_neighbors = neighbors.get('left')
    right_neighbors = neighbors.get('right')
    top_neighbors = neighbors.get('top')
    bottom_neighbors = neighbors.get('bottom')

    # has a neighbor on both sides
    if direction == 'left' and (left_neighbors and right_neighbors):
        boss.active_tab.resize_window('narrower', amount)
    # only has left neighbor
    elif direction == 'left' and left_neighbors:
        boss.active_tab.resize_window('wider', amount)
    # only has right neighbor
    elif direction == 'left' and right_neighbors:
        boss.active_tab.resize_window('narrower', amount)

    # has a neighbor on both sides
    elif direction == 'right' and (left_neighbors and right_neighbors):
        boss.active_tab.resize_window('wider', amount)
    # only has left neighbor
    elif direction == 'right' and left_neighbors:
        boss.active_tab.resize_window('narrower', amount)
    # only has right neighbor
    elif direction == 'right' and right_neighbors:
        boss.active_tab.resize_window('wider', amount)

    # has a neighbor above and below
    elif direction == 'up' and (top_neighbors and bottom_neighbors):
        boss.active_tab.resize_window('shorter', amount)
    # only has top neighbor
    elif direction == 'up' and top_neighbors:
        boss.active_tab.resize_window('taller', amount)
    # only has bottom neighbor
    elif direction == 'up' and bottom_neighbors:
        boss.active_tab.resize_window('shorter', amount)

    # has a neighbor above and below
    elif direction == 'down' and (top_neighbors and bottom_neighbors):
        boss.active_tab.resize_window('taller', amount)
    # only has top neighbor
    elif direction == 'down' and top_neighbors:
        boss.active_tab.resize_window('shorter', amount)
    # only has bottom neighbor
    elif direction == 'down' and bottom_neighbors:
        boss.active_tab.resize_window('taller', amount)

    # no neighbor on this axis
    else:
        return False

    return True


@result_handler(no_ui=True)
def handle_result(args, result, target_window_id, boss):
    # --fallback-text=<str> is optional; strip it before positional indexing
    fallback_text = ''
    positional = []
    for arg in args:
        if arg.startswith(FALLBACK_PREFIX):
            fallback_text = arg[len(FALLBACK_PREFIX):]
        else:
            positional.append(arg)

    direction = positional[1]
    amount = int(positional[2])
    window = boss.window_id_map.get(target_window_id)

    # the tmux passthrough needs a 4th arg naming the key to forward; none of
    # the bindings in kitty.conf pass one, so fall through to resizing instead
    cmd = window.child.foreground_cmdline[0]
    if cmd == 'tmux' and len(positional) > 3:
        encoded = encode_key_mapping(window, positional[3])
        window.write_to_child(encoded)
    elif not relative_resize_window(direction, amount, target_window_id, boss):
        # Nothing to resize on this axis, so type the character the key would
        # have produced natively (kitty always swallows Option/Alt shortcuts).
        if fallback_text:
            window.write_to_child(fallback_text.encode('utf-8'))
