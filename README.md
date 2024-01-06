# shortcutsTracker

## Installation
See [shortcuts](./shortcuts/README.md).

## Usage
The program takes one optional argument. This is the path to the [Configuration](#Configuration) directory.  
The program shows the keyboardlayout selected/ configured and when modifier keys pressed it will update the layout corresponding to the shortcuts, that are now available with this modifier.
It is also possible to create and select several contexts to show different shortcuts for different applications.

Default i3 context:
![image](https://github.com/Len101218/shortcutsTracker/assets/105433861/9b4c8700-3fd3-4d95-a5ef-aa40b977ddc8)

i3 shortcuts when meta and shift are pressed:
![image](https://github.com/Len101218/shortcutsTracker/assets/105433861/20dd86c0-ab38-4291-a9db-e9584c09cafd)

Usually you want to disable all shortcuts for other applications / your OS while using this application.
This depends on the environment.

### Using i3
I recommend adding the following to the i3 config.  
```
mode "shortcuts"{  
    #just empty to clean everything else 
    bindsym Escape mode "default", exec "pkill shortcuts"  
    bindsym $mod+Escape mode "default"  
}  
bindsym $mod+Shift+S mode "shortcuts", exec "shortcuts"  
```
This way you can start the application shortcuts with `mod+shift+s` and all other keybindings are disabled until you press escape.


## Configuration
<a name="Configuration"></a>
See [json](./json/README.md).

## Dependencies
Todo

## Todos
