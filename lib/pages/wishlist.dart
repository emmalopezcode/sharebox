import 'package:flutter/material.dart';
import 'package:share_box/classes/sharebox_item.dart';
import 'package:share_box/services/json_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:share_box/widgets/wishlist_tile.dart';
import 'package:share_box/misc/data.dart';
import 'package:share_box/widgets/browse_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Wishlist extends StatefulWidget {
  @override
  _WishlistState createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  List<dynamic> currentEntries = [];
  Firestore db = Firestore.instance;

  initState() {
    print('init state called');
    super.initState();
    print('super init state called');

    retrieveJsonData().then((result) {
      setState(() {
        currentEntries = result;
        //print(currentEntries);
      });
    });
  }

  refresh() {
    print('refresh pressed');
    retrieveJsonData().then((result) {
      setState(() {
        currentEntries = result;
      });
    });
  }

  Future<void> empty() async {
    //clears the current shared preferences data
    SharedPreferences data = await SharedPreferences.getInstance();
    data.clear();
    setState(() {
      currentEntries.clear();
    });
    data.setString('entries', null);
  }

  Future<List<dynamic>> retrieveJsonData() async {
    //called at init in order to start the data
    SharedPreferences data = await SharedPreferences.getInstance();
    print('pre if in retrieve json');
    if (data.getString('entries') != null) {
      //if data is not empty
      //decode the data and return
      final String savedEntriesJson = data.getString('entries');
      final List<dynamic> entriesDeserialized = json.decode(savedEntriesJson);

      return entriesDeserialized;
    }
    print('post if in retrieve json');
    //otherwise return an empty array
    List<dynamic> empty = [ShareBoxItem()];
    return empty;
  }

  @override
  Widget build(BuildContext context) {
    print(currentEntries);
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [abColor, gradientEnd],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: ListView.builder(
            itemCount: currentEntries.length,
            itemBuilder: (context, index) {
              //contain the hash map into a sharebox item
              ShareBoxItem curr = ShareBoxItem(
                  category: currentEntries[index]['category'],
                  description: currentEntries[index]['description'],
                  title: currentEntries[index]['title'],
                  house: currentEntries[index]['house'],
                  imageBase64: currentEntries[index]['imageBase64']);
              //ShareBoxItem curr = currentEntries[index];
              return WishListTile(
                item: curr,
                delete: () {
                  removeJsonData(curr);

                  setState(() {
                    refresh();
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
