import subprocess
import json
import re


def parse_line(line: str) -> dict:
    _, mac, name = line.split(" ", 2)
    return {"mac": mac, "name": name}


def match_connected(out: str) -> bool:
    match = re.search(r"Connected: \w+", out)
    if match:
        s, e = match.span()
        return out[s:e].split()[1] == "yes"

    return False


def match_battery(out: str) -> str:
    match = re.search(r"Battery Percentage:.*", out)
    if match:
        s, e = match.span()
        bat = int(out[s:e].split()[-1][1:-1])

        if bat > 95:
            return "󰥈"

        if bat > 90:
            return "󰥆"

        if bat > 80:
            return "󰥅"

        if bat > 70:
            return "󰥄"

        if bat > 60:
            return "󰥃"

        if bat > 50:
            return "󰥂"

        if bat > 40:
            return "󰥁"

        if bat > 30:
            return "󰥀"

        if bat > 20:
            return "󰤿"

        if bat > 10:
            return "󰤾"

    return ""


out = subprocess.check_output(["bluetoothctl", "devices"], text=True)
devices = [parse_line(line) for line in out.split("\n") if line]
devices = list(filter(lambda d: d["mac"] != d["name"].replace("-", ":"), devices))

for dev in devices:
    out = subprocess.check_output(["bluetoothctl", "info", dev["mac"]], text=True)
    dev["connected"] = match_connected(out)
    dev["battery"] = match_battery(out)

print(json.dumps(devices))
