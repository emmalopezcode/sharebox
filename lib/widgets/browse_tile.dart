import 'package:flutter/material.dart';
import 'package:share_box/classes/sharebox_item.dart';
import 'package:share_box/misc/data.dart';
import 'package:share_box/services/json_data.dart';
import 'package:share_box/widgets/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShareBoxTile extends StatefulWidget {
  final ShareBoxItem item;
  ShareBoxTile({this.item});

  @override
  _ShareBoxTileState createState() => _ShareBoxTileState(item: item);
}

class _ShareBoxTileState extends State<ShareBoxTile> {
  ShareBoxItem item;
  _ShareBoxTileState({this.item});

  Icon icon = Icon(Icons.favorite_border);
  bool isFavorited = false;
  Firestore db = Firestore.instance;

  void changeWishlistState() {
    setState(() {
      if (item.inWishlist) {
        removeJsonData(item);
      } else {
        saveJsonData(item);
      }
      item.inWishlist = !item.inWishlist;
    });
  }

  createItemDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            contentPadding: EdgeInsets.all(0),
            children: <Widget>[
              Column(
                children: <Widget>[
                  ShareBoxItem.imageFromBase64(item.imageBase64),
                  SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${item.description}',
                      textAlign: TextAlign.left,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SlimButton(
                          text: 'pick up', color: pinkPop, action: () {}),
                      SlimButton(
                        text: 'add to wishlist',
                        color: pinkPop,
                        action: () async {
                          await saveJsonData(item);
                        },
                      ),
                      SlimButton(text: 'X', color: Colors.red),
                    ],
                  ),
                  SizedBox(height: 10.0),
                ],
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: GestureDetector(
            onTap: () {
              createItemDialog(context);
            },
            child: Column(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: size.width * .25,
                    height: size.width * .25,
                    child: ShareBoxItem.imageFromBase64(item.imageBase64),
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  '${item.title}',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
      Row(
        children: <Widget>[
          SizedBox(
            width: size.width * .16,
          ),
          IconButton(
            icon: item.inWishlist
                ? Icon(Icons.favorite)
                : Icon(Icons.favorite_border),
            color: pinkPop,
            onPressed: changeWishlistState,
          ),
        ],
      ),
    ]);
  }
}
