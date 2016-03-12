#!/bin/sh
# 
# This script adds the Arabic Dvorak layout to the ara XKB configuration
#  file. Dry-run patches are attempted on both files before actually
#  patching, and if successful the patches are applied.
#
#######################################################################

if [[ $EUID -ne 0 ]]; then
	echo "This script requires root privileges" 1>&2
	exit -1
fi

SYMBOL_FILE="/usr/share/X11/xkb/symbols/ara"
SYMBOL_PATCH="ara.patch"
EVDEV_FILE="/usr/share/X11/xkb/rules/evdev.xml"
EVDEV_PATCH="evdev.xml.patch"

# check that files exist
if [ ! -f "$SYMBOL_FILE" ]; then
	echo "$SYMBOL_FILE not found"
	exit 1
elif [ ! -f "$SYMBOL_PATCH" ]; then
	echo "$SYMBOL_PATCH not found"
	exit 1
elif [ ! -f "$EVDEV_FILE" ]; then
	echo "$EVDEV_FILE not found"
	exit 1
elif [ ! -f "$EVDEV_PATCH" ]; then
	echo "$EVDEV_PATCH not found"
	exit 1
fi

# if not already patched and dry-run succeeds, apply patch
if patch -R -N --silent --dry-run "$SYMBOL_FILE" "$SYMBOL_PATCH" 1>&2>/dev/null; then
	echo "$SYMBOL_FILE already patched, skipping..." 1>&2
else
	if patch -N --silent --dry-run "$SYMBOL_FILE" "$SYMBOL_PATCH" 2>/dev/null; then
		patch -b -N --silent "$SYMBOL_FILE" "$SYMBOL_PATCH" 2>/dev/null
		echo "$SYMBOL_FILE patched"
	fi
fi

if patch -R -N --silent --dry-run "$EVDEV_FILE" "$EVDEV_PATCH" 1>&2>/dev/null; then
	echo "$EVDEV_FILE already patched, skipping..." 1>&2
else
	if patch -N --silent --dry-run "$EVDEV_FILE" "$EVDEV_PATCH" 2>/dev/null; then
		patch -b -N --silent "$EVDEV_FILE" "$EVDEV_PATCH" 2>/dev/null
		echo "$EVDEV_FILE patched"
	fi
fi

echo "Done"
