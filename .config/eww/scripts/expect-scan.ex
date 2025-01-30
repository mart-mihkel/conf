#!/bin/expect -f

set timeout 10

spawn bluetoothctl
send -- "scan on\r"

expect eof
