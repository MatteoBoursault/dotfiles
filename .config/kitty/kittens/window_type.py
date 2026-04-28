from kitty.boss import boss
from kittens.tui.handler import result_handler


def main(args: list[str]) -> str:
    pass

@result_handler(no_ui=true)
def handle_result(args: list[str], stdin_data: str, target_window_id: int, boss: boss) -> none:
    window = args[1]

    w = boss.window_id_map.get(int(window))
    if w is none:
        return "unknown_window"

    if w.screen.is_main_linebuf():
        return "linebuf"
    else:
        return "application"