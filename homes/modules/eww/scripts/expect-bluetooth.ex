#!/bin/expect -f

set timeout 60

set dev_tmp "14:3F:A6:DA:AA:00"
set dev [lindex $argv 0]

spawn bluetoothctl
send -- "scan on\r"

expect "$dev"
send -- "connect $dev\r"

expect "Connection successful"
send -- "trust $dev\r"

expect "trust succeeded"
send -- "exit\r"

expect eof
