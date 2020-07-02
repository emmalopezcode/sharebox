import 'package:flutter/material.dart';
import 'package:share_box/classes/sharebox_item.dart';
import 'package:share_box/misc/data.dart';
import 'package:share_box/services/json_data.dart';
import 'package:share_box/widgets/browse_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Browse extends StatelessWidget {
  final List<ShareBoxItem> items;
  Browse({this.items});
  Firestore db = Firestore.instance;

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

    return ShareBoxTile(item: curr);
  }

//research the update data function and pass it into the the sharebox tile with the 'onLike'
  void changeFavorite(DocumentSnapshot doc) async {
    Map data = doc.data;
    data['inWishlist'] = !data['inWishlist'];
    await db
        .collection('sharebox_db')
        .document(doc.documentID)
        .updateData(data);
  }

  Container buildOneRow(height) {
    return Container(
      height: height,
      child: ListView(scrollDirection: Axis.horizontal, children: <Widget>[
        StreamBuilder<QuerySnapshot>(
            stream: db.collection('sharebox_db').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print(snapshot.data.documents.length);
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
                print(snapshot.data.documents.length);
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
                padding: EdgeInsets.symmetric(horizontal:10),
                width: size.width,
                child: Text(
                  text,
                  style: TextStyle(color: pinkPop, fontSize: 20),
                  textAlign: TextAlign.left,
                ),
              );
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
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                buildLabelText(size, 'New'),
                buildOneRow(size.height * .2),
                buildOneRowQuery(size.height * .2, 'true?'),
                buildOneRow(size.height * .2),
                buildOneRow(size.height * .2),
                buildOneRow(size.height * .2),
                buildOneRow(size.height * .2),
              ],
            ),
          ),
        ),
      ],
    );
  }

  
}
