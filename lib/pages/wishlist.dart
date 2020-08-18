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
  List<dynamic> leftEntries = [];
  List<dynamic> rightEntries = [];
  Firestore db = Firestore.instance;

  initState() {
    print('wishlist init');
    super.initState();

    jsonIsEmpty().then((result) {
      if (result) {
        createEmptyJson();
      } else {
        retrieveJsonData().then((result) {
          setState(() {
            currentEntries = result;
            //print(currentEntries);
          });
          for (int i = 0; i < currentEntries.length; i++) {
            if (i % 2 == 0) {
              leftEntries.add(currentEntries[i]);
            } else {
              rightEntries.add(currentEntries[i]);
            }
          }
        });
      }
    });
  }

  refresh() {
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
    if (data.getString('entries') == '{}') {
      List<ShareBoxItem> result = [];
      return result;
    } else if (data.getString('entries') != null) {
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
          child: buildWishlistGrid(),
        ),
      ],
    );
  }

  Widget buildWishlistGrid() {
    if (currentEntries.length == 0) {
      return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Center(
              child: Text(
                'Looks like you havent saved anything',
                style: TextStyle(color: Colors.white, fontSize: 20),
          )));
    }
    return GridView.builder(
      padding: EdgeInsets.all(0),
      itemCount: currentEntries.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
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
    );
  }
}
