import 'package:flutter/material.dart';
import 'package:share_box/classes/sharebox_item.dart';
import 'package:share_box/misc/data.dart';
import 'package:share_box/services/json_data.dart';
import 'package:share_box/widgets/browse_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:flutter_spinkit/flutter_spinkit.dart';


import 'package:share_box/widgets/featured_tile.dart';

class Browse extends StatefulWidget {
  final List<ShareBoxItem> items;

  Browse({this.items});

  @override
  _BrowseState createState() => _BrowseState();
}

class _BrowseState extends State<Browse> {
  Firestore db = Firestore.instance;

  int dbSize;
  Future<ShareBoxItem> featuredFuture;
  Future<QuerySnapshot> documentsAtBoot;
  bool tileScreenOpen;

  @override
  void initState() {
    super.initState();
    tileScreenOpen = false;
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

  ShareBoxTile buildShareBoxTile(DocumentSnapshot doc) {
    ShareBoxItem curr = ShareBoxItem(
      title: doc.data['title'],
      description: doc.data['description'],
      house: doc.data['house'],
      category: doc.data['category'],
      imageBase64: doc.data['imageBase64'],
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
    );
  }

  Container buildOneRow(height) {
    return Container(
      height: height,
      child: ListView(scrollDirection: Axis.horizontal, children: <Widget>[
        StreamBuilder<QuerySnapshot>(
            stream: db.collection('sharebox_db').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                                  child: Column(
                      children: snapshot.data.documents
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

  Container buildOneRowQuery(double height, String query) {
    return Container(
      height: height,
      child: ListView(scrollDirection: Axis.horizontal, children: <Widget>[
        StreamBuilder<QuerySnapshot>(
            stream: db
                .collection('sharebox_db')
                .where('title', isEqualTo: query)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Row(
                    children: snapshot.data.documents
                        .map((doc) => buildShareBoxTile(doc))
                        .toList());
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

  
  Future<bool> delay() {
    return Future.delayed(Duration(milliseconds: 1000)).then((onValue) => true);
  }

  FutureBuilder buildAnimation() {
    return FutureBuilder(
      future: delay(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container();
        } else {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: abColor,
            child: SpinKitWave(color: pinkPop, size: 50,),
          );
        }
      },
    );
  }

  Future<QuerySnapshot> getDocumentsAtBoot() async {
    var docs = await db.collection('sharebox_db').getDocuments();
    return docs;
  }

  

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
          child: buildOneRow(size.height)
        ),
      ],
    );
  }
}
