import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  List<String> pressedKeys = [];

  @override
  void initState() {
    super.initState();
    ServicesBinding.instance.keyboard.addHandler((event) => _onKey(event));
  }

  bool _onKey(KeyEvent event) {
    if (event is KeyDownEvent) {
      final keyLabel = event.logicalKey.keyLabel;
      if (!pressedKeys.contains(keyLabel)) {
        setState(() {
          pressedKeys.add(keyLabel);
        });
      }
      // Return true to indicate that the key press should be processed further.
      return true;
    } else if (event is KeyUpEvent) {
      final keyLabel = event.logicalKey.keyLabel;
      setState(() {
        pressedKeys.remove(keyLabel);
      });
      // Return false to indicate that the key release should not be processed further.
      return false;
    }
    // Return true for other events.
    return true;
  }

  @override
  void dispose() {
    ServicesBinding.instance.keyboard.removeHandler((event) => _onKey(event));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Key Press Tracking'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Pressed Keys:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(
                26,
                (index) {
                  final keyLabel = String.fromCharCode('A'.codeUnitAt(0) + index);
                  return ElevatedButton(
                    onPressed: () {
                      if(pressedKeys.contains(keyLabel))
                        pressedKeys.remove(keyLabel);
                      else
                        pressedKeys.add(keyLabel);
                    },
                    child: Text(keyLabel),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                        return pressedKeys.contains(keyLabel) ? Colors.red : Colors.blue;
                      }),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
