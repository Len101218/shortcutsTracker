import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Pair<T1, T2> {
  final T1 first;
  final T2 second;

  Pair(this.first, this.second);
}

//pressed(red) > config (0x...) > changed (yellow) > default (blue)
Pair<String, Color> getText(String keyId, List<String> modifier, String defaultText){

  if(modifier.isEmpty){
    return Pair(defaultText,Colors.blue);
  }
  // Sort the list alphabetically
  modifier.sort();

  // Concatenate the sorted strings into one string
  String filepath = modifier.join();

  // Specify the path to the file
  String filePath = '/home/len1218/documents/project/keyboard/json/$filepath.json';

  var file = File(filePath);

  if (!file.existsSync()) {
    return Pair(defaultText,Colors.blue);
  }

  // Read the content of the file
  String jsonString = File(filePath).readAsStringSync();
  
  // Parse the JSON-like structure
  List<dynamic> decodedList = jsonDecode(jsonString);

  List<Map<String, dynamic>> keyDataList = List<Map<String, dynamic>>.from(decodedList);

  // Find the entry with the specified key_id
  Map<String, dynamic>? targetEntry = keyDataList.firstWhere(
    (entry) => entry["key_id"] == keyId,
    orElse: () => {"key_id": keyId, "text": defaultText, "color": Colors.blue.value.toRadixString(16)},
  );
  
  // Retrieve the text or default_text
  String resultText = targetEntry["text"];
  

  Color resultColor =  targetEntry["color"]!=null ? Color(int.parse(targetEntry["color"],radix: 16)) : Colors.yellow;
  return Pair(resultText,resultColor);
}


writeTranslations(){
  List<Map<String, dynamic>> knownKeys = PhysicalKeyboardKey.knownPhysicalKeys
      .map((key) => {
            'debugName': key.debugName,
            'usbHidUsage': key.usbHidUsage,
          })
      .toList();

  // Your JSON data
  Map<String, dynamic> jsonData = {
    'knownKeys': knownKeys,
  };

  // Convert JSON data to a string
  String jsonString = jsonEncode(jsonData);

  // Specify the file path
  String filePath = 'known_keys.json';

  // Write the JSON data to the file
  File(filePath).writeAsString(jsonString);

  print('JSON data has been written to $filePath');
  
}

// Method to read the JSON file and get debugName for a usbHidUsage
String getDebugName(int usbHidUsage){
  // Specify the file path
  String filePath = '/home/len1218/documents/project/keyboard/shortcutsTracker/known_keys.json';

  try {
    // Read the contents of the JSON file
    String fileContent =  File(filePath).readAsStringSync();


    // Get the list of known keys data
    List<Map<String, dynamic>> knownKeysData = (jsonDecode(fileContent) as List).cast<Map<String, dynamic>>();

    // Find the entry with the specified usbHidUsage
    Map<String, dynamic>? matchingKey = knownKeysData
        .firstWhere((keyData) => keyData['usbHidUsage'] == usbHidUsage,
            orElse: () => {'debugName': 'Not Found'});

    // Print the result
    //print('For usbHidUsage $usbHidUsage, debugName is: ${matchingKey['debugName']}');
    return matchingKey['debugName'];
  } catch (e) {
    print('Error reading or parsing the JSON file: $e');
  }
  return "null";
}