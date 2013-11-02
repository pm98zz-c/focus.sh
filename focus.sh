#!/bin/sh

# Return usage.
usage(){
    echo "Usage:"
    echo "$0 -c <command> [-w <windows class name>]"
}

# Check for dependencies.
if [ ! `which xprop &> /dev/null` ]; then
  echo "Could not execute 'xprop'. Ensure it is installed."
  exit 1
fi

if [ ! `which wmctrl &> /dev/null` ]; then
  echo "Could not execute 'wmctrl'. Ensure it is installed."
  exit 1
fi

# Parse arguments.
while getopts c:w:p: OPT
do
    case $OPT in
        c)
          CMD="$OPTARG"
        ;;
        w)
          WCLASS="$OPTARG"
        ;;
    esac
done


# We need at least a command.
if [ ! $CMD ] || [ "$CMD" = "" ]; then
  usage
  exit 1
fi

if [ ! $WCLASS ] || [ "$WCLASS" = "" ]; then
	WCLASS=$CMD
fi

# Ensure we have all our arguments.
if [ "$CMD" = "" ] || [ "$WCLASS" = ""  ]; then
  usage
  exit 1
fi


# Check if command is running, launch it if it is not, give focus if it is.
	
for x in `xprop -root _NET_CLIENT_LIST_STACKING | cut '-d#' -f2`
do
	CLASS=`xprop -id ${x%,}  WM_CLASS | cut -d'"' -f2`
	if [ "$CLASS" = "$WCLASS" ];then
		ACTIVE=`xprop -root 32x '\t$0' _NET_ACTIVE_WINDOW | cut -f 2`
        	ACTIVECLASS=`xprop -id "$ACTIVE"  WM_CLASS | cut -d'"' -f2`
        	if [ "$ACTIVECLASS" = "$WCLASS" ];then
                	wmctrl  -x -r "$WCLASS" -b add,hidden
        	else
                	wmctrl -x -a "$WCLASS"
        	fi
        exit 0
	fi
done

# No window found, launch command.
env "$CMD"
exit 0
