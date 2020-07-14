import 'dart:convert';
import 'package:share_box/classes/sharebox_item.dart';
import 'package:shared_preferences/shared_preferences.dart';


String emptyJsonTag = '{}';

Future<void> createEmptyJson() async {
  print('clicked');
  SharedPreferences data = await SharedPreferences.getInstance();
  data.setString('entries', emptyJsonTag);
}

Future<void> emptyJson() async {
  SharedPreferences data = await SharedPreferences.getInstance();
  data.setString('entries', null);
}

Future<bool> jsonIsEmpty() async {
  SharedPreferences data = await SharedPreferences.getInstance();
  final String savedEntriesJson = data.getString('entries');
  if (savedEntriesJson == null) {
    return true;
  }
  return false;
}

Future<bool> isInJson(ShareBoxItem entry) async {
  SharedPreferences data = await SharedPreferences.getInstance();
  final String savedEntriesJson = data.getString('entries');
  if(savedEntriesJson == emptyJsonTag){
    return false;
  }
  else if (savedEntriesJson != null) {
    final List<dynamic> entriesDeserialized = json.decode(savedEntriesJson);
    List<ShareBoxItem> deserializedEntries =
        entriesDeserialized.map((json) => ShareBoxItem.fromJson(json)).toList();

    for (int i = 0; i < deserializedEntries.length; i++) {
      if (deserializedEntries[i].equals(entry)) {
        return true;
      }
    }
    return false;
  }
  return false;
}

Future<List<ShareBoxItem>> getJsonDataAsList() async {
  //simple function to extract the json data
  SharedPreferences data = await SharedPreferences.getInstance();
  final String savedEntriesJson = data.getString('entries');
  if(savedEntriesJson == emptyJsonTag){
    List<ShareBoxItem> result = [];
    return result;
  }
  else if (savedEntriesJson != null) {
    print(savedEntriesJson);
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
  bool isDuplicate = false;
  SharedPreferences data = await SharedPreferences.getInstance();
  final String savedEntriesJson = data.getString('entries');
  if (savedEntriesJson != emptyJsonTag) {
    //if the save file is not empty
    //decode and reset the data
    final List<dynamic> entriesDeserialized = json.decode(savedEntriesJson);
    List<ShareBoxItem> deserializedEntries =
        entriesDeserialized.map((json) => ShareBoxItem.fromJson(json)).toList();
    //see if there is a duplicate entry in the json file
    for (int i = 0; i < deserializedEntries.length; i++) {
      if (deserializedEntries[i].equals(entry)) {
        isDuplicate = true;
      }
    }

    if (!isDuplicate) {
      deserializedEntries.add(entry);
    }
    final String entriesJson = json
        .encode(deserializedEntries.map((entry) => entry.toJson()).toList());
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
