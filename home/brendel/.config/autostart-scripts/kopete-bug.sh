#! /usr/bin/env bash

DEV=enp0s31f6
SERVER=141.30.75.19
tc qdisc del dev $DEV root
tc qdisc add dev $DEV root handle 1: prio
tc qdisc add dev $DEV parent 1:3 handle 30: netem delay 500ms 50ms distribution normal
tc filter add dev eth1 protocol ip parent 1:0 prio 3 u32 match ip dst $SERVER/32 flowid 1:3
