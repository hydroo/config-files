#! /usr/bin/env sh

o1="$(xrandr | grep [^s]connected -A1)"

internal="$(echo "$o1" | grep "^ *3840" -B1 | head -n1 | sed "s/^ *[0-9]*:[ +*]*//g" | sed "s/ .*$//g")"
dell="$(    echo "$o1" | grep "^ *2560" -B1 | head -n1 | sed "s/^ *[0-9]*:[ +*]*//g" | sed "s/ .*$//g")"
hp="$(      echo "$o1" | grep "^ *1920" -B1 | head -n1 | sed "s/^ *[0-9]*:[ +*]*//g" | sed "s/ .*$//g")"

touchscreen=$(xinput list | grep Wacom.*Finger | sed "s/.*id=//g" | sed "s/ *\[.*\]*//g")

#echo "$o1"
#echo "$internal"
#echo "$dell"
#echo "$hp"
#echo $touchscreen

if [ -n "$internal" ]; then
	# position the internal display on the bottom
	# the coordinate system starts in the top-left corner
	xrandr --output $internal --primary --mode 1920x1080 --pos 2560x1080

	if [ -n "$touchscreen" ]; then
		xinput --map-to-output $touchscreen $internal
	else
		>&2 echo "Error: Internal touch screen not found"
	fi
else
	>&2 echo "Error: Internal display not found"
fi

if [ -n "$dell" ]; then
	# position to the left middle of both other monitors
	xrandr --output $dell --pos 0x360
fi

if [ -n "$hp" ]; then
	xrandr --output $hp --above $internal
fi

#xrandr --dpi 96
