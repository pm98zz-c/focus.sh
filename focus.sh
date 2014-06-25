#!/bin/sh

# Check for dependencies.
if [ ! `which xprop &> /dev/null` ]; then
  echo "Could not execute 'xprop'. Ensure it is installed."
  exit 1
fi

if [ ! `which wmctrl &> /dev/null` ]; then
  echo "Could not execute 'wmctrl'. Ensure it is installed."
  exit 1
fi

# Return usage.
usage(){
  echo "\v"
  echo "Usage:"
  echo
  echo "focus.sh -c <command> [-w <windows class name>]"
  echo "Where :"
  echo "<command>\t\t Command to execute if window is not found. Eg: 'gnome-terminal', '/usr/bin/firefox'"
  echo "-<windows class name>\t Window 'class name' to use for checking if the window already exists. Default to the same as the -c argument.\nUse -l to get a list of possible values."
  echo
  echo "focus.sh -l"
  echo "\t Displays the list of 'class names' of the currently opened windows."
  echo "\v"
}

# List running windows.
windowsList(){
  echo "\v"
  echo "Currently opened windows, in the form:"
  echo "class-name (Name)"
  echo "The (Name) part is only informational, ommit it when using whith -w option."
  echo "\v"
  for x in `xprop -root _NET_CLIENT_LIST_STACKING | cut '-d#' -f2`
  do
  echo	 "`xprop -id ${x%,}  WM_CLASS | cut -d'"' -f2` (`xprop -id ${x%,}  WM_CLASS | cut -d'"' -f4`)"
  done
}

# Focus/Unfocus window.
windowToggle(){
  # Store this so we can unfocus more reliably.
  PREVIOUS=0
  for x in `xprop -root _NET_CLIENT_LIST_STACKING | cut '-d#' -f2`
  do
    CLASS=`xprop -id ${x%,}  WM_CLASS | cut -d'"' -f2`
    if [ "$CLASS" = "$WCLASS" ];then
      ACTIVE=`xprop -root 32x '\t$0' _NET_ACTIVE_WINDOW | cut -f 2`
        ACTIVECLASS=`xprop -id "$ACTIVE"  WM_CLASS | cut -d'"' -f2`
        if [ "$ACTIVECLASS" = "$WCLASS" ];then
          wmctrl -x -a "$PREVIOUS"
        else
          wmctrl -x -a "$WCLASS"
        fi
      exit 0
    fi
    PREVIOUS=$CLASS
  done
}

# Parse arguments.
while getopts c:w:l OPT
do
  case $OPT in
    c)
      CMD="$OPTARG"
    ;;
    w)
      WCLASS="$OPTARG"
    ;;
    l)
      windowsList
      exit 0
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


# Check if command is running.
windowToggle


# No window found, launch command.
env "$CMD"

exit 0
