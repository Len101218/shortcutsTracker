import 'dart:convert';
import 'dart:io';

String get_text(String keyId, List<String> modifier, String default_text){

  if(modifier.isEmpty){
    return default_text;
  }
  // Sort the list alphabetically
  modifier.sort();

  // Concatenate the sorted strings into one string
  String filepath = modifier.join();

  // Specify the path to the file
  String filePath = '/home/len1218/documents/project/keyboard/json/$filepath.json';

  var file = File(filePath);

  if (!file.existsSync()) {
    return default_text;
  }

  // Read the content of the file
  String jsonString = File(filePath).readAsStringSync();
  
  // Parse the JSON-like structure
  List<dynamic> decodedList = jsonDecode(jsonString);

  List<Map<String, dynamic>> keyDataList = List<Map<String, dynamic>>.from(decodedList);

  // Find the entry with the specified key_id
  Map<String, dynamic>? targetEntry = keyDataList.firstWhere(
    (entry) => entry["key_id"] == keyId,
    orElse: () => {"key_id": keyId, "text": default_text},
  );
  
  // Retrieve the text or default_text
  String resultText = targetEntry["text"];
  return resultText;
}