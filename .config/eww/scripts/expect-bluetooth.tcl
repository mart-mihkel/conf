#!/bin/expect -f

set timeout 10

set dev [lindex $argv 0]

spawn bluetoothctl
send -- "connect $dev\r"

expect "Connection successful"
send -- "trust $dev\r"

expect "trust succeeded"
send -- "exit\r"

expect eof
