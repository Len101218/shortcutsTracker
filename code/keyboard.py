#!/usr/bin/python3
import tkinter as tk
from pynput import keyboard

class KeyboardViewer:
    def __init__(self, root):
        self.root = root
        self.root.title("Keyboard Viewer")

        # Define the keys in a grid
        self.keys = [
            '`1234567890-=',  # Top row
            '   qwertyuiop[]\\',  # Second row
            "    asdfghjkl;'",  # Third row
            '  zxcvbnm,./'  # Bottom row
        ]

        # self.keys.extend(special_keys)

        # Create a dictionary to store button widgets
        self.key_buttons = {}

        # Set up keyboard listener
        self.keyboard_listener = keyboard.Listener(on_press=self.on_key_press, on_release=self.on_key_release)
        self.keyboard_listener.start()

        # Track pressed keys
        self.pressed_keys = set()

        # Create and place buttons on the grid
        for row, key_row in enumerate(self.keys):
            for col, key in enumerate(key_row):
                button = tk.Button(root, text=key.upper(), width=3, height=2, command=lambda k=key: self.on_button_click(k))
                button.grid(row=row, column=col, padx=2, pady=2)
                self.key_buttons[key] = button

    def on_key_press(self, key):
        try:
            # Add pressed key to the set
            self.pressed_keys.add(key.char)
            self.update_buttons()
        except AttributeError:
            # Handle special keys
            self.pressed_keys.add(str(key))
            self.update_buttons()

    def on_key_release(self, key):
        try:
            # Remove released key from the set
            self.pressed_keys.remove(key.char)
            self.update_buttons()
        except AttributeError:
            # Handle special keys
            self.pressed_keys.remove(str(key))
            self.update_buttons()

    def on_button_click(self, key):
        # Simulate a key press when the button is clicked
        self.pressed_keys.add(key)
        self.update_buttons()

    def update_buttons(self):
        # Update button colors based on pressed keys
        for key, button in self.key_buttons.items():
            if key in self.pressed_keys:
                button.configure(bg='red')
            else:
                button.configure(bg='white')

    def run(self):
        self.root.mainloop()

if __name__ == "__main__":
    root = tk.Tk()
    app = KeyboardViewer(root)
    app.run()

