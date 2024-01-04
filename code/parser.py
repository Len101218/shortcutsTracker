#!/bin/python3

import json


class Keyboard:
    rows: List[Row] = []
    def __init__(self):
        self.rows = []  # Initialize an empty list for rows

    def add_row(self, row):
        self.rows.append(row)

    def display(self):
        for i, row in enumerate(self.rows):
            print(f"Row {i + 1}: {row.keys}")
class Row:
    Row_num:int = None
    keys: List[Key] = []
    def __init__(self, keys=[]):
        self.keys=keys

class Key:
    key_id: str = None
    text: str = None
    modifier: bool = None
    pos:Pos = None
    
    def __init__(self, key_id, text, modifier, pos):
        self.key_id = key_id
        self.text = text
        self.modifier = modifier
        self.pos = pos
    def __init__(self, json_obj):
        self.key_id = key_data["key_id"]
        self.text = key_data["text"]
        self.modifier = key_data["modifier"]
        self.pos = Pos(key_data["pos"])

    def __str__(self):
        return f"Key(id={self.key_id}, text={self.text}, modifier={self.modifier}, pos={self.pos})"



class Pos:
    x:float = None
    y:float = None
    h:float = None
    w:float = None
    def __init__(self, json_obj):
        self.x = key_data["x"]
        self.y = key_data["y"]

    
    



def main():
    # Specify the path to your JSON file
    json_file_path = '../json/basic.json'

    # Load keyboard layout from JSON file
    with open(json_file_path, 'r') as json_file:
        keyboard_layout = json.load(json_file)
        print("Data from file:", keyboard_layout)

if __name__ == "__main__":
    main()


