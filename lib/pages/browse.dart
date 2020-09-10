import 'package:flutter/material.dart';
import 'package:share_box/classes/sharebox_item.dart';
import 'package:share_box/misc/data.dart';
import 'package:share_box/services/json_data.dart';
import 'package:share_box/widgets/browse_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:share_box/widgets/featured_tile.dart';
import 'package:share_box/pages/search.dart';

class Browse extends StatefulWidget {
  final List<ShareBoxItem> items;

  Browse({this.items});

  @override
  _BrowseState createState() => _BrowseState();
}

class _BrowseState extends State<Browse> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  int dbSize;
  Future<ShareBoxItem> featuredFuture;
  Future<QuerySnapshot> documentsAtBoot;
  Widget main;
  String chosenQuery;

  bool tileScreenOpen;

  @override
  void initState() {
    super.initState();

    // Size size = MediaQuery.of(context).size;
    // main = buildLabelText(size, 'test');
  }

  Future<void> changeWishlistState(ShareBoxItem item) async {
    setState(() {
      isInJson(item).then((value) {
        if (value) {
          removeJsonData(item);
        } else {
          saveJsonData(item);
        }
      });
    });
  }

  void deleteDialog(DocumentSnapshot doc) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: abColor,
            title: Text(
              'Are you sure you want to pick up this item?',
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              'if you do it will be removed from the Sharebox',
              style: TextStyle(color: Colors.white),
            ),
            actions: <Widget>[
              FlatButton(
                color: pinkPop,
                child: Text(
                  'Pick Up',
                  style: TextStyle(color: abColor),
                ),
                onPressed: () async {
                  await db.collection('sharebox_db').doc(doc.id).delete();
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                color: pinkPop,
                child: Text(
                  'Cancel',
                  style: TextStyle(color: abColor),
                ),
                onPressed: Navigator.of(context).pop,
              ),
            ],
          );
        });
  }

  void deleteDoc(DocumentSnapshot doc) async {
    await db.collection('sharebox_db').doc(doc.id).delete();
  }

  ShareBoxTile buildShareBoxTile(DocumentSnapshot doc) {
    ShareBoxItem curr = ShareBoxItem(
      title: doc.data()['title'],
      description: doc.data()['description'],
      house: doc.data()['house'],
      category: doc.data()['category'],
      imageBase64: doc.data()['imageBase64'],
    );

    //fetch the wishlist data
    getJsonDataAsList().then((list) {
      for (int i = 0; i < list.length; i++) {
        //if the object is in the wishlist data
        if (curr.equals(list[i])) {
          //give it the wishlist property in the renderer
          curr.inWishlist = true;
        }
        curr.inWishlist = false;
      }
    });

    return ShareBoxTile(
      item: curr,
      onFavoritePressed: () async {
        await changeWishlistState(curr);
      },
      onPickUp: () {
        deleteDialog(doc);
        // deleteDoc(doc);
        Navigator.popAndPushNamed(context, '/temp');
      },
    );
  }

  void printData() {
    db.collection('sharebox_db').snapshots().listen((data) {
      data.docs.forEach((doc) {
        print(doc.data()['title']);
      });
    });
  }

  Container buildOneRow(height) {
    return Container(
        height: height,
        child: StreamBuilder<QuerySnapshot>(
            stream: db.collection('sharebox_db').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  child: Column(
                      children: snapshot.data.docs
                          .map((doc) => buildShareBoxTile(doc))
                          .toList()),
                );
              } else {
                return Text('error');
              }
            }));
  }

  Container buildOneRowQuery(double height, String query) {
    return Container(
      height: height,
      child: ListView(scrollDirection: Axis.horizontal, children: <Widget>[
        StreamBuilder<QuerySnapshot>(
            stream: db
                .collection('sharebox_db')
                .where('house', isEqualTo: query)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  child: Column(
                      children: snapshot.data.docs
                          .map((doc) => buildShareBoxTile(doc))
                          .toList()),
                );
              } else {
                return Text('error');
              }
            })
      ]),
    );
  }

  Container buildLabelText(Size size, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      width: size.width,
      child: Text(
        text,
        style: TextStyle(color: pinkPop, fontSize: 20),
        textAlign: TextAlign.left,
      ),
    );
  }

  Future<QuerySnapshot> getDocumentsAtBoot() async {
    var docs = await db.collection('sharebox_db').get();
    return docs;
  }

  void changeQuery() {
    setState(() {
      chosenQuery = 'Howard';
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (chosenQuery == null) {
      main = buildOneRow(size.height);
    } else {
      main = buildOneRowQuery(size.height, chosenQuery);
    }
    return Stack(
      fit: StackFit.loose,
      children: <Widget>[
        Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [abColor, gradientEnd],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: main),
        Positioned(
            bottom: 20,
            left: size.width -100,
            child: FloatingActionButton(
              backgroundColor: pinkPop,
              onPressed: changeQuery,
              child: Icon(Icons.tune),
        ))
      ],
    );
  }
}
