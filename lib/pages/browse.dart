import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_box/classes/sharebox_item.dart';
import 'package:share_box/misc/data.dart';
import 'package:share_box/services/json_data.dart';
import 'package:share_box/widgets/browse_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:share_box/widgets/featured_tile.dart';
import 'package:share_box/pages/search.dart';
import 'package:share_box/misc/query_dialog.dart';

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
  String chosenQuery = 'All';
  String houseDDV = 'All';
  bool tileScreenOpen;
  List<String> houses = [
    'Rackham Court',
    'Brooks/Buck',
    'Joe McNabb',
    'Anderson',
    'Sylvester',
    'Howard',
    'Lowrey',
    'All'
  ];
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
    print('delete dialog called?');
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
                  Navigator.popAndPushNamed(context, '/temp');

                  // Navigator.of(context).pop();
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
    print('dialog shown');
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
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: abColor,
                  child: SpinKitWave(
                    color: pinkPop,
                    size: 50,
                  ),
                );
              }
            }));
  }

  Container buildOneRowQuery(Size size, String query) {
    return Container(
      height: size.height,
      child: ListView(scrollDirection: Axis.horizontal, children: <Widget>[
        StreamBuilder<QuerySnapshot>(
            stream: db
                .collection('sharebox_db')
                .where('house', isEqualTo: chosenQuery)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.docs.length > 0) {
                  return SingleChildScrollView(
                    child: Column(
                        children: snapshot.data.docs
                            .map((doc) => buildShareBoxTile(doc))
                            .toList()),
                  );
                } else {
                  return Column(
                    children: [
                      SizedBox(
                        height: size.height * .4,
                      ),
                      Container(
                        width: size.width,
                        child: Text(
                          'Looks like $chosenQuery does not have any uploads yet.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 30),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      FlatButton(
                        color: pinkPop,
                        child: Text(
                          'Return to Browse',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          setState(() {
                            chosenQuery = 'All';
                          });
                        },
                      )
                    ],
                  );
                }
              } else {
                return Center(
                    child: Text(
                  'Loading...',
                  style: TextStyle(color: Colors.white),
                ));
              }
            })
      ]),
    );
  }

  void queryOk() {
    setState(() {
      chosenQuery = houseDDV;
    });
    Navigator.pop(context);
  }

  void querySelect(String newValue) {
    setState(() {
      houseDDV = newValue;
    });
  }

  void changeQuery(height) {
    print(height);
    showDialog(
        context: context,
        builder: (context) {
          return QueryDialog(
              height: height,
              houseDDV: houseDDV,
              houses: houses,
              querySelect: querySelect,
              queryOk: queryOk);
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (chosenQuery == 'All') {
      main = buildOneRow(size.height);
    } else {
      main = buildOneRowQuery(size, chosenQuery);
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
            left: size.width - 100,
            child: FloatingActionButton(
              backgroundColor: pinkPop,
              onPressed: () {
                changeQuery(size.height);
              },
              child: Icon(Icons.tune),
            ))
      ],
    );
  }
}
