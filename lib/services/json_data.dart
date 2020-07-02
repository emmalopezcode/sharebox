import 'dart:convert';
import 'package:share_box/classes/sharebox_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<ShareBoxItem>> getJsonDataAsList() async {
  //simple function to extract the json data
  SharedPreferences data = await SharedPreferences.getInstance();
  final String savedEntriesJson = data.getString('entries');
  if (savedEntriesJson != null) {
    final List<dynamic> entriesDeserialized = json.decode(savedEntriesJson);
    List<ShareBoxItem> deserializedEntries =
        entriesDeserialized.map((json) => ShareBoxItem.fromJson(json)).toList();
    return deserializedEntries;
  }
  print('empty json file');
  return null;
}

Future<void> removeJsonData(ShareBoxItem entry) async {
  //extract current data
  SharedPreferences data = await SharedPreferences.getInstance();
  final String savedEntriesJson = data.getString('entries');
  if (savedEntriesJson != null) {
    final List<dynamic> entriesDeserialized = json.decode(savedEntriesJson);
    List<ShareBoxItem> deserializedEntries =
        entriesDeserialized.map((json) => ShareBoxItem.fromJson(json)).toList();
    //find the equivalent entry
    int index = 0;
    for (int i = 0; i < deserializedEntries.length; i++) {
      if (deserializedEntries[i].equals(entry)) {
        index = i;
      }
    }
    //remove it
    deserializedEntries.removeAt(index);

    //save the new data
    final String entriesJson = json
        .encode(deserializedEntries.map((entry) => entry.toJson()).toList());
    data.setString('entries', entriesJson);
  }
}

Future<void> saveJsonData(ShareBoxItem entry) async {
  SharedPreferences data = await SharedPreferences.getInstance();
  final String savedEntriesJson = data.getString('entries');
  if (savedEntriesJson != null) {
    //if the save file is not empty
    //decode and reset the data
    final List<dynamic> entriesDeserialized = json.decode(savedEntriesJson);
    List<ShareBoxItem> deserializedEntries =
        entriesDeserialized.map((json) => ShareBoxItem.fromJson(json)).toList();
    deserializedEntries.add(entry);
    final String entriesJson = json
        .encode(deserializedEntries.map((entry) => entry.toJson()).toList());
    print(entriesJson);
    data.setString('entries', entriesJson);
  } else {
    //if the save file is empty
    //add and reset the data
    List<ShareBoxItem> result = [entry];
    final String emptyJsonOutput =
        json.encode(result.map((entry) => entry.toJson()).toList());
    data.setString('entries', emptyJsonOutput);
  }
}
