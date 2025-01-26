import subprocess
import json


def parse_line(out_line):
    active, ssid, signal = out_line.strip().split(":")
    return {"active": active, "ssid": ssid, "signal": signal}


cmd = ["nmcli", "-t", "-f", "ACTIVE,SSID,SIGNAL", "device", "wifi"]
out = subprocess.check_output(cmd, text=True)
parsed = [parse_line(ln) for ln in out.split("\n") if ln]
cut = sorted(parsed, key=lambda p: -int(p["signal"]))
print(json.dumps(cut))
