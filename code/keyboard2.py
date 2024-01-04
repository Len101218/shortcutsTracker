#!/usr/bin/python3
import tkinter as tk
import json
from pynput import keyboard







class CustomButton(tk.Button):
    def __init__(self, master=None, cnf={}, **kwargs):
        self.width = kwargs.pop("width", 1)
        self.height = kwargs.pop("height", 1)
        self.width2 = kwargs.pop("width2", None)
        self.height2 = kwargs.pop("height2", None)
        self.x2_factor = kwargs.pop("x2_factor", 0)

        super().__init__(master, cnf, **kwargs)

    def grid(self, **kwargs):
        rowspan = kwargs.pop("rowspan", 1)
        columnspan = kwargs.pop("columnspan", 1)

        super().grid(rowspan=rowspan, columnspan=columnspan, **kwargs)

        if self.width2 is not None and self.height2 is not None:
            kwargs2 = kwargs.copy()
            kwargs2["row"] += 1
            kwargs2["column"] += self.x2_factor
            super().grid(rowspan=rowspan, columnspan=columnspan, **kwargs2)











class KeyboardViewer:
    def __init__(self, root, layout_file):
        self.root = root
        self.root.title("Keyboard Viewer")

        # Load keys from JSON file
        with open(layout_file) as f:
            layout_data = json.load(f)

        # Extract keys from the JSON data
        self.keys = layout_data

        # Create a dictionary to store button widgets
        self.key_buttons = {}

        # Set up keyboard listener
        self.keyboard_listener = keyboard.Listener(on_press=self.on_key_press, on_release=self.on_key_release)
        self.keyboard_listener.start()

        # Track pressed keys
        self.pressed_keys = set()


        # Create and place buttons on the grid
        width =1
        height =1

        for row, row_data in enumerate(self.keys):
            col = 0  # Initialize column index
            for key_data in row_data:
                if isinstance(key_data, str):
                    if str(key_data) == "":
                        key_data = "space"
                    #width = int(key_data.get("w", 1)) if isinstance(key_data, dict) else width
                    #height = int(key_data.get("h", 1)) if isinstance(key_data, dict) else height

                    button = tk.Button(root, text=key_data, width=12 * width, height=8 * height, command=lambda k=key_data: self.on_button_click(k))
                    button.grid(row=row, column=col, padx=2, pady=2, rowspan=height, columnspan=width)
                    tmp = str(key_data).lower().split('\n')
                    for i in range(len(tmp)):
                        if tmp[i] in self.key_buttons:
                            self.key_buttons[tmp[i]] = [self.key_buttons[tmp[i]],button]
                        else:
                            self.key_buttons[tmp[i]] = button
                        print("added key code: ",tmp[i])
                    col += width  # Move to the next column
                    width = 1
                    height = 1

                elif isinstance(key_data, dict):
                    print(key_data)
                    x_factor = int(key_data.get("x", 0)) if 'x' in key_data else 0
                    y_factor = int(key_data.get("y", 0)) if 'y' in key_data else 0
                    width = int(key_data.get("w", 1)) if 'w' in key_data else 1
                    height = int(key_data.get("h", 1)) if 'h' in key_data else 1

                    col += x_factor  # Move to the next column with the specified x factor
                    row += y_factor  # Move to the next row with the specified y factor
                   
                    if 'w2' in key_data and 'h2' in key_data:
                        width2 = int(key_data['w2'])
                        height2 = int(key_data['h2'])
                        x2_factor = int(key_data.get('x2', 0))

                        #button = CustomButton(root, text="", width=3 * width, height=2 * height, width2=width2, height2=height2, x2_factor=x2_factor, command=lambda k=key_data: self.on_button_click(k))
                        #button.grid(row=row, column=col, padx=2, pady=2, rowspan=height, columnspan=width)

                        #col += x2_factor  # Move to the next column with the specified x2 factor
                        #row += 1  # Move to the next row for the second part of the key

                        #col += width2  # Move to the next column for the next regular key
                    #print(key_data)
                    continue
                    self.key_buttons[key_data.lower()] = button

                    col += width  # Move to the next column

            row += 1  # Move to the next row after processing a row of keys


    def on_key_press(self, key):
        try:
            key_char = str(key.char).lower()
        except AttributeError:
            key_char = str(key).split('Key.')[-1].lower()
        print("pressed: ",key_char)
        self.pressed_keys.add(key_char)
        self.update_buttons()

    def on_key_release(self, key):
        try:
            key_char = key.char.lower()
        except AttributeError:
            key_char = str(key).split('Key.')[-1]
        print("released: ",key_char)
        if key_char in self.pressed_keys:
            self.pressed_keys.remove(key_char)
        self.update_buttons()

    def on_button_click(self, key_data):
        if isinstance(key_data, str):
            key_char = key_data.lower().split('\n')[-1]
        else:
            key_char = str(next(iter(key_data), None)).lower()
        print("clicked: ",key_char)
        self.pressed_keys.add(key_char)
        self.update_buttons()

    def update_buttons(self):
        # Update button colors based on pressed keys
        for key_data_tuple, button in self.key_buttons.items():
            if not isinstance(button,list):
                button = [button]
            for b in button:
                #key_data = dict(key_data_tuple)  # Convert the tuple back to a dictionary
                key_data=key_data_tuple
                key_char = key_data if isinstance(key_data, str) else next(iter(key_data), None)
                if key_char in self.pressed_keys:
                    b.configure(bg='red')
                else:
                    b.configure(bg='white')


    def run(self):
        self.root.mainloop()

if __name__ == "__main__":
    root = tk.Tk()
    app = KeyboardViewer(root, layout_file='layout.json')
    app.run()

