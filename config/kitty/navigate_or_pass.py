# Move focus to the neighboring window, unless there is nothing to move to:
# a zoomed tab (stack layout), a single-pane tab or a floating quick-access
# window (lazygit). Then send the key to the focused app instead.
# Usage: kitten navigate_or_pass.py <direction> <key>
from kittens.tui.handler import result_handler


def main(args):
    pass


@result_handler(no_ui=True)
def handle_result(args, answer, target_window_id, boss):
    direction, key = args[1], args[2]
    window = boss.window_id_map.get(target_window_id)
    tab = boss.tab_for_id(window.tab_id) if window else None
    if tab is None:
        return
    if tab.current_layout.name == "stack" or tab.windows.num_groups <= 1:
        window.send_key(key)
    else:
        tab.neighboring_window(direction)
