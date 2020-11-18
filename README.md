# focus.sh

Tiny script to use in a X11 environment. It focus/unfocus an application's window if it exists, launch the program if not.
Typical use is in conjunction with keyboard shortcuts binding to easily switch between frequently used applications.

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
