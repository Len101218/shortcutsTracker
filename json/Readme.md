# Config files
All shortcuts and keyboard formats are defined in json.  
The default location of the folder containing all files is ~/.config/shortcuts.  
Another location can be specified as first argument to the program.


## structure of ~/.config/shortcuts
Every subdirectories in this directory is considered to be a so called context.  
The only exception is `templates`, that can contain any content, but in this repo just templates:).


There have to be the following two files:
- `keyboard.json`
- `known_keys.json`

Any other file is ignored.

## keyboard.json
This file contains the keyboard layout, as well as the default keyLabels/ interpretations.  

### Syntax
The file contains one json object with the attributs:
- layout (String): name of the layout
- context (String): the default context
- rows(Array): contains all keyboard rows

One **row** inside the above row array has the attributes:
- row_num(int): 0,...,
- columns(Array): Array of columns (should be named keys)

One key in the **columns array** has the attributes:
- key_id(String): The keyId to the PhysicalkeyCode (can be found in known_keys.json)
- text(String): The printed text on the key in the application
- modifier(String / null ): If and which modifier this key should trigger
- pos: Where to place this key

The **pos** determines the size and relative position of the key:
- x(double): width of free space before key
- y(double): height of free space before key
- h(double): height of key
- w(double): width of key

## known_keys.json
This file can be generated with the method `writeTranslations` inside the `helper.dart` source file.  
On the one hand it is used to translate keycodes (number) to debugNames to make creating json files easier.  
On the other hand it documents all supported PhysicalKeyCodes.

- To make it more readible use some formater, like the one contained in VScode.

# Context
A context can be an application, that uses shortcuts but also some special mode/ screen within that appication.  
For example you can use the context `i3` as your default `i3` shortcutlist and `i3_resize` as the list, that contains the keybindings within that resize mode. 
  
As stated above, a context is represented threw a subdirectory.  
This doesnt work recursively.

## Files
### default.json
The `default.json` file inside a context_directory is a special file, that represent the keybindings in that mode.

### Modifier
The Other Files are named after (combinations of ) modifer keys, specified in your keyboard.json file.
Combinations are just joined together(CamelCase) in alphanumerical order.
For example the Keybindings for Shift are stored in `Shift.json` and the one for `Shift+Ctrl` in `CtrlShift.json`.

## Syntax
They all contain a json list of objects with the following attributes of type String:
- key_id: The key_id specified in keyboard.json
- text: The keyLabel shown in the application
- color (optional): The color of the key.

An example can be seen in templates/full.json.

