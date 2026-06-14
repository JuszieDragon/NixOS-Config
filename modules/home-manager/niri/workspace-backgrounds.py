import json
import subprocess

wallpaper_dir = "/home/justin/Pictures/Wallpapers/"
nikke_wallpaper = "Counters_Over-Spec.jpg"
default_wallpaper = "Disco.png"
current_wallpaper = ""


def get_active_named_workspace() -> str | None:
    result = subprocess.run(
        ["niri", "msg", "--json", "workspaces"],
        capture_output=True,
        text=True,
        check=True,
    )

    workspaces = json.loads(result.stdout)

    for ws in workspaces:
        print(ws)
        if ws.get("is_active") and ws.get("name"):
            return ws.get("name")

    return None


def monitor_workspace_changes():
    global current_wallpaper
    with subprocess.Popen(
        ["niri", "msg", "event-stream"], stdout=subprocess.PIPE, text=True
    ) as process:
        # Iterate over the stream as lines become available
        for line in process.stdout:
            if line.startswith("Workspace focused"):
                match get_active_named_workspace():
                    case "Nikke":
                        if current_wallpaper != nikke_wallpaper:
                            subprocess.run(
                                [
                                    "noctalia",
                                    "msg",
                                    "wallpaper-set",
                                    wallpaper_dir + nikke_wallpaper,
                                ]
                            )
                            current_wallpaper = nikke_wallpaper
                    case _:
                        if current_wallpaper != default_wallpaper:
                            subprocess.run(
                                [
                                    "noctalia",
                                    "msg",
                                    "wallpaper-set",
                                    wallpaper_dir + default_wallpaper,
                                ]
                            )
                            current_wallpaper = default_wallpaper


monitor_workspace_changes()
