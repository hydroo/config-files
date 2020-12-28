#! /usr/bin/env sh

o1="$(xrandr | grep [^s]connected -A1)"

internal="$(echo "$o1" | grep "^ *3840" -B1 | head -n1 | sed "s/^ *[0-9]*:[ +*]*//g" | sed "s/ .*$//g")"
dell19="$(    echo "$o1" | grep "^ *2560" -B1 | tail -n2 | sed "s/^ *[0-9]*:[ +*]*//g" | sed "s/ .*$//g")"
dell21="$(    echo "$o1" | grep "^ *2560" -B1 | head -n1 | sed "s/^ *[0-9]*:[ +*]*//g" | sed "s/ .*$//g")"

touchscreen=$(xinput list | grep Wacom.*Finger | sed "s/.*id=//g" | sed "s/ *\[.*\]*//g")

# echo "$o1"
# echo "xx"
# echo "$internal"
# echo "xx"
# echo "$dell19"
# echo "xx"
# echo "$dell21"
# echo "xx"
# echo "$touchscreen"
# echo "xx"

if [ -n "$internal" ]; then
	# position the internal display on the bottom
	# the coordinate system starts in the top-left corner
	xrandr --output $internal --primary --mode 1920x1080 --pos 2560x1440

	if [ -n "$touchscreen" ]; then
		xinput --map-to-output $touchscreen $internal
	else
		>&2 echo "Error: Internal touch screen not found"
	fi
else
	>&2 echo "Error: Internal display not found"
fi

if [ -n "$dell19" ]; then
	# position to the left middle of both other monitors
	xrandr --output $dell19 --pos 0x240
fi

if [ -n "$dell21" ]; then
	xrandr --output $dell21 --above $internal
fi

#xrandr --dpi 96
