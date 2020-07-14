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
  final Function onFavoritePressed;
  ShareBoxTile({this.item, this.onFavoritePressed});

  @override
  _ShareBoxTileState createState() => _ShareBoxTileState(item: item, onFavoritePressed: onFavoritePressed);
}

class _ShareBoxTileState extends State<ShareBoxTile> {
  ShareBoxItem item;
  Function onFavoritePressed;
  _ShareBoxTileState({this.item, this.onFavoritePressed});

  Icon icon = Icon(Icons.favorite_border);
  bool isFavorited = false;
  Firestore db = Firestore.instance;

  @override
  void initState() {
    isInJson(item).then((value) {
      isFavorited = value;
    });
    super.initState();
  }

  // Future<bool> isInWishlist() async {
  //   var result = await isInJson(item);
  //   return result;
  // }

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

  FutureBuilder<bool> buildFavoriteButton() {
    return FutureBuilder<bool>(
      future: isInJson(item),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data) {
            return IconButton(
              icon: Icon(Icons.favorite),
              color: pinkPop,
              onPressed: onFavoritePressed,
            );
          } else {
            return IconButton(
              icon: Icon(Icons.favorite_border),
              color: pinkPop,
              onPressed: onFavoritePressed,
            );
          }
        } else {
          return Text('no data');
        }
      },
    );
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
          buildFavoriteButton(),
        ],
      ),
    ]);
  }
}
