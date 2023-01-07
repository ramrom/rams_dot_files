#!/bin/sh

hciconfig -a | sed -n 3p | grep RUNNING > /dev/null || echo BT-DOWN
