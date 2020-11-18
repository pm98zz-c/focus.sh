# focus.sh

Tiny script to use in a X11 environment (both Xorg and Wayland, for most applications).

It does focus/unfocus an application's window if it exists, launch the program if not.

Typical use is in conjunction with global keyboard shortcuts binding to easily switch between frequently used applications, without launching a new instance if it is already running.
Eg. Super+C to switch to "Code", Super+F to switch to "Firefox".

## Usage

```
focus.sh -c <command> [-w <windows class name>]
Where :
<command>		 Command to execute if window is not found. Eg: 'gnome-terminal', '/usr/bin/firefox'
-<windows class name>	 Window 'class name' to use for checking if the window already exists. Default to the same as the -c argument.
Use -l to get a list of possible values.

focus.sh -l
	 Displays the list of 'class names' of the currently opened windows.
```


## Examples

```
./focus.sh -c mattermost
./focus.sh -c firefox -w Navigator
/focus.sh -c /usr/bin/code -w code
```

More examples shown in the context of an Openbox rc file.
```
<keybind key="W-t">
  <action name="Execute">
    <command>/opt/scripts/snippets/focus.sh -c lxterminal</command>
  </action>
</keybind>
<keybind key="W-s">
  <action name="Execute">
    <command>/opt/scripts/snippets/focus.sh -c firefox -w Navigator</command>
  </action>
</keybind>
```

## Dependencies

Relies on xprop and wmctrl.
