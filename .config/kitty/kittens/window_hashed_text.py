from kitty.boss import Boss
from kittens.tui.handler import result_handler
import hashlib


def main(args: list[str]) -> str:
    pass

@result_handler(no_ui=True)
def handle_result(args: list[str], stdin_data: str, target_window_id: int, boss: Boss) -> None:
    window = args[1]

    w = boss.window_id_map.get(int(window))
    if w is None:
        return "unknown_window"

    return hashlib.md5(w.as_text().encode("utf-8")).hexdigest()