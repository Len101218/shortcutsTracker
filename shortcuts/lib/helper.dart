import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shortcuts/main.dart';
import 'package:path/path.dart';


class Pair<T1, T2> {
  final T1 first;
  final T2 second;

  Pair(this.first, this.second);
}

//pressed(red) > config (0x...) > changed (yellow) > default (blue)
Pair<String, Color> getText(String keyId, List<String> modifier, String defaultText, String ctx){
  String filepath="default";
  if(modifier.isNotEmpty){
    // Sort the list alphabetically
    modifier.sort();

    // Concatenate the sorted strings into one string
    filepath = modifier.join();
  }
  // Specify the path to the file
  String filePath = '$pathToJsonFolder/$ctx/$filepath.json';

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
  String filePath = '$pathToJsonFolder/known_keys.json';

  // Write the JSON data to the file
  File(filePath).writeAsString(jsonString);

  print('JSON data has been written to $filePath');
  
}

// Method to read the JSON file and get debugName for a usbHidUsage
String getDebugName(int usbHidUsage){
  // Specify the file path
  String filePath = '$pathToJsonFolder/known_keys.json';

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


String expandPath(String pathWithTilde) {
  // Check if the path starts with a tilde (~)
  if (pathWithTilde.startsWith('~/')) {
    // Get the home directory based on the platform
    String homeDir = getHomeDirectory();

    // Replace the tilde with the home directory
    return join(homeDir, pathWithTilde.substring(2));
  }

  // If the path does not start with a tilde, return it as is
  return pathWithTilde;
}

String getHomeDirectory() {
  // Determine the home directory based on the platform
  if (Platform.isWindows) {
    return Platform.environment['USERPROFILE']!;
  } else {
    return Platform.environment['HOME']!;
  }
}

List<String> getSubdirectories() {
  List<String> subdirectories = [];

  Directory directory = Directory(pathToJsonFolder);

  if (directory.existsSync()) {
    List<FileSystemEntity> entities = directory.listSync();

    for (FileSystemEntity entity in entities) {
      if (entity is Directory) {
        String fullPath = entity.path;
        String directoryName = fullPath.substring(fullPath.lastIndexOf(Platform.pathSeparator)+1);
        subdirectories.add(directoryName);
      }
    }
    subdirectories.remove('templates');
  } else {
      print('Directory does not exist: $pathToJsonFolder');
  }
  //print(subdirectories);
  return subdirectories;
}
