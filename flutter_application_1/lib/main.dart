import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<String, dynamic>? keyboardLayout;
  List<String> pressedKeys = [];
  List<String> modifier = [];


  @override
  void initState() {
    super.initState();
    _loadKeyboardLayout();
    ServicesBinding.instance.keyboard.addHandler((event) => _onKey(event));
  }

  bool _onKey(KeyEvent event) {
    if (event is KeyDownEvent) {
      final keyLabel = event.physicalKey.debugName;
      if (!pressedKeys.contains(keyLabel)) {
        setState(() {
          pressedKeys.add(keyLabel!);
        });
      }
      // Return true to indicate that the key press should be processed further.
      return false;
    } else if (event is KeyUpEvent) {
      final keyLabel = event.physicalKey.debugName;
      setState(() {
        pressedKeys.remove(keyLabel);
      });
      // Return false to indicate that the key release should not be processed further.
      return false;
    }
    // Return true for other events.
    return false;
  }
  @override
  void dispose() {
    ServicesBinding.instance.keyboard.removeHandler((event) => _onKey(event));
    super.dispose();
  }

  Future<void> _loadKeyboardLayout() async {
    try {
      // Read the JSON string from the file
      String jsonText = await File('/home/len1218/documents/project/keyboard/json/basic.json').readAsString();

      // Parse the JSON string
      Map<String, dynamic> layout = jsonDecode(jsonText);

      setState(() {
        keyboardLayout = layout;
      });
    } catch (e) {
      print('Error loading keyboard layout: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // get modifier
    modifier=[];
    if(keyboardLayout != null){
      for (var row in keyboardLayout!['rows']){
        for (var btn in row['columns']){
          if(btn is List){
            for (var nestedbtn in btn){
              if(nestedbtn["modifer"]!=null && pressedKeys.contains(nestedbtn["key_id"])){
                  modifier.add(nestedbtn["modifier"]);
              }
            }
          }
          else{
            if((btn["modifier"]!=null) && pressedKeys.contains(btn["key_id"])){
              modifier.add(btn["modifier"]);
            }
          }
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Keyboard Layout'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (keyboardLayout != null)
              Text(
                'Layout: ${keyboardLayout!['layout']}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )
            else
              const Text(
                'Loading keyboard layout...',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 10),
            if (keyboardLayout != null)
              Column(
                children: List.generate(
                  (keyboardLayout!['rows'] as List).length,
                  (index) => KeyboardRow(
                    row: keyboardLayout!['rows'][index],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class KeyboardRow extends StatelessWidget {
  final Map<String, dynamic> row;
  final scale = 0.055;
  final orig_scale = 0.05;
  KeyboardRow({required this.row});

  @override
  Widget build(BuildContext context) {
    final pageState = context.findAncestorStateOfType<_MyHomePageState>();
    final pressedKeys = pageState!.pressedKeys;
    final modifier = pageState.modifier;

    final ratio = scale /orig_scale;

    if (row['columns'] != null) {
      List<Widget> buttons = [];
      for (var column in row['columns']) {
        buttons.add(SizedBox(width: 10*ratio)); // Adjust the multiplier as needed

        if (column is List) {
          // Handle the case where 'columns' is an array
          List<Widget> columnButtons = [];

          for (var nestedColumn in column) {
            // Process nested columns (if any)
            final keyLabel = nestedColumn['text'];
            final keyId = nestedColumn['key_id'];
            var pos = nestedColumn['pos'];
            double width = pos != null && pos['w'] != null ? pos['w'] : 1.0;
            double height = pos != null && pos['h'] != null ? pos['h'] : 1.0;
            //final num = (row['columns'] as List).length;
            width *= scale;
            height *= scale;
            columnButtons.add(SizedBox(height: (pos['y'].toDouble() ?? 0)*ratio)); // Adjust the multiplier as needed
            columnButtons.add(
              ElevatedButton(
                onPressed: () {
                  if (pressedKeys.contains(keyId)) {
                    pressedKeys.remove(keyId);
                  } else {
                    pressedKeys.add(keyId);
                  }
                },         
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                    return pressedKeys.contains(keyId) ? Colors.red : Colors.blue;
                  }),
                  fixedSize: MaterialStateProperty.all<Size>(
                    Size(MediaQuery.of(context).size.width * width, MediaQuery.of(context).size.width * height),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                child: Text(
                  get_text(keyId, modifier, keyLabel),
                  overflow: TextOverflow.visible,
                  maxLines: 1,
                  softWrap: false,
                  style: const TextStyle(
                    fontSize: 18.0, // Set your desired font size
                    color: Colors.black, // Set your desired text color
                    fontWeight: FontWeight.bold, // Make the text bold
                  ),
                ),       
              ),
            );
            columnButtons.add(SizedBox(height: 10*ratio)); // Adjust the multiplier as needed
          }

          // Create a container to hold all the buttons in the nested array
          Widget nestedColumnContainer = Container(
            // Customize the container as needed
            child: Column(
              children: columnButtons,
            ),
          );

          // Add the container to your layout
          buttons.add(nestedColumnContainer);
        } 
        else {
          final keyLabel = column['text'];
          final keyId = column['key_id'];
          var pos = column['pos'];
          double width = pos != null && pos['w'] != null ? pos['w'] : 1.0;
          double height = pos != null && pos['h'] != null ? pos['h'] : 1.0;
          //final num = (row['columns'] as List).length;
          width *= scale;
          height *= scale;
          buttons.add(SizedBox(width: (pos['x'].toDouble() ?? 0))); // Adjust the multiplier as needed

          buttons.add(
            ElevatedButton(
              onPressed: () {
                if(pressedKeys.contains(keyId)){
                  pressedKeys.remove(keyId);
                }
                else{
                  pressedKeys.add(keyId);
                }
              },
              
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                  return pressedKeys.contains(keyId) ? Colors.red : Colors.blue;
                }),
                fixedSize: MaterialStateProperty.all<Size>(
                  Size(MediaQuery.of(context).size.width * width, MediaQuery.of(context).size.width * height),
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Set to 0 for square corners
                  ),
                ),
              ),
              child: Text(
                get_text(keyId, modifier, keyLabel),
                overflow: TextOverflow.visible,
                maxLines: 1,
                softWrap: false,
                style: const TextStyle(
                  fontSize: 18.0, // Set your desired font size
                  color: Colors.black, // Set your desired text color
                  fontWeight: FontWeight.bold, // Make the text bold
                ),
              ),
            ),
          );
        }
      }
      return Padding(
        padding: EdgeInsets.all(5*ratio),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Align to the left
          crossAxisAlignment: CrossAxisAlignment.start,
          children: buttons,
        ),
        /*child: Wrap(
          direction: Axis.horizontal, // Set the direction to horizontal
          alignment: WrapAlignment.start,
          spacing: 10,
          runSpacing: 10,
          children: buttons,
        ),*/
      );
    }

    return Container();
  }
}
