import 'package:flutter/material.dart';
import 'package:share_box/classes/sharebox_item.dart';
import 'package:share_box/misc/data.dart';
import 'package:share_box/pages/tile_screen.dart';
import 'package:share_box/services/json_data.dart';
import 'package:share_box/widgets/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:page_transition/page_transition.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShareBoxTile extends StatefulWidget {
  final ShareBoxItem item;
  final Function onFavoritePressed;
  ShareBoxTile({this.item, this.onFavoritePressed});

  @override
  _ShareBoxTileState createState() =>
      _ShareBoxTileState(item: item, onFavoritePressed: onFavoritePressed);
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

  Future<void> changeWishlistState(ShareBoxItem item) async {
    print('change wishlist state');
    setState(() {
      isInJson(item).then((value) {
        if (value) {
          print('in json');
          removeJsonData(item);
        } else {
          print('not in json');

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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Stack(children: <Widget>[
      Row(
        children: [
          Container(
            width: size.width,
            child: GestureDetector(
              onTap: () {},
              child: Column(
                children: <Widget>[
                  Row(
                    children: [
                      SizedBox(
                        width: size.width * .025,
                      ),
                      Text(
                        '${item.title}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Courier',
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: size.width * .95,
                      height: size.width * .95,
                      child: ShareBoxItem.imageFromBase64(item.imageBase64),
                    ),
                  ),
                  Row(
                    children: [
                      buildFavoriteButton(),
                      IconButton(
                        color: pinkPop,
                        icon: Icon(Icons.file_upload),
                        onPressed: () {},
                      ),
                      IconButton(
                        color: pinkPop,
                        icon: Icon(Icons.share),
                        onPressed: () {},
                      ),
                      Spacer(),
                    ],
                  ),
                  Container(
                    width: size.width*.95,
                    child: Text(
                      '${item.description}',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ColoredChunk(text: '${item.house}'),
                      SizedBox(
                        width: 15,
                      ),
                      ColoredChunk(text: '${item.category}')
                    ],
                  ),
                  SizedBox(height: 40,)
                ],
              ),
            ),
          ),
        ],
      ),
    ]);
  }
}
