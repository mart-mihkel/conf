import sys
import json
import subprocess


def parse_line(out_line):
    active, ssid, signal = out_line.strip().split(":")
    return {"active": active, "ssid": ssid, "signal": signal}


cmd = ["nmcli", "-t", "-f", "ACTIVE,SSID,SIGNAL", "device", "wifi"]
out = subprocess.check_output(cmd, text=True)
parsed = [parse_line(ln) for ln in out.split("\n") if ln]
ordered = sorted(parsed, key=lambda p: -int(p["signal"]))

if len(sys.argv) > 1 and sys.argv[1] == "-a":
    actives = [ln for ln in ordered if ln["active"] == "yes"]
    active_signal = actives[0]["signal"] if actives else 0
    print(active_signal)
else:
    print(json.dumps(ordered))
