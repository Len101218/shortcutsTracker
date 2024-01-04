import tkinter as tk
import json

class KeyboardGUI:
    def __init__(self, master, keyboard_layout):
        self.master = master
        self.master.title("Keyboard GUI")

        # Load keyboard layout from the provided JSON
        self.keyboard_layout = keyboard_layout

        # Create and display the keyboard
        self.create_keyboard()

    def create_keyboard(self):
        for row_index, row in enumerate(self.keyboard_layout["rows"]):
            for col_index, key in enumerate(row):
                pos = key["pos"]
                button = tk.Button(self.master, text=key["text"], width=pos["w"], height=pos["h"])
                button.grid(row=row_index, column=col_index, padx=2, pady=2)

def main():
    # Load keyboard layout from JSON file
    with open("basic.json", "r") as json_file:
        keyboard_layout = json.load(json_file)

    # Create the main window
    root = tk.Tk()

    # Create an instance of the KeyboardGUI class
    keyboard_gui = KeyboardGUI(root, keyboard_layout)

    # Start the Tkinter event loop
    root.mainloop()

if __name__ == "__main__":
    main()

