import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_box/classes/sharebox_item.dart';
import 'package:share_box/misc/data.dart';
import 'package:share_box/pages/tile_screen.dart';
import 'package:share_box/services/json_data.dart';
import 'package:share_box/widgets/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:page_transition/page_transition.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_animation_set/widget/behavior_animations.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'dart:ui';

class ShareBoxTile extends StatefulWidget {
  final ShareBoxItem item;
  final Function onFavoritePressed;
  final Function onPickUp;

  ShareBoxTile({this.item, this.onFavoritePressed, this.onPickUp});

  @override
  _ShareBoxTileState createState() => _ShareBoxTileState(
      item: item, onFavoritePressed: onFavoritePressed, onPickUp: onPickUp);
}

class _ShareBoxTileState extends State<ShareBoxTile> {
  ShareBoxItem item;
  Function onFavoritePressed;
  Function onPickUp;
  String animation = '';
  double likeOpacity = 0.0;
  _ShareBoxTileState({this.item, this.onFavoritePressed, this.onPickUp});

  Icon icon = Icon(Icons.favorite_border);
  bool isFavorited = false;
  FirebaseFirestore db = FirebaseFirestore.instance;

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

  void like() {
    setState(() {
      animation = 'enter heart';
      likeOpacity = 1.0;
    });
    saveJsonData(item);
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
                  GestureDetector(
                    onDoubleTap: () {
                      print('double tap');
                      like();
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: size.width * .95,
                        height: size.width * .95,
                        child: ShareBoxItem.imageFromBase64(item.imageBase64),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      buildFavoriteButton(),
                      IconButton(
                        color: pinkPop,
                        icon: Icon(Icons.archive),
                        onPressed: onPickUp,
                      ),
                      IconButton(
                        color: pinkPop,
                        icon: Icon(Icons.send),
                        onPressed: () async {
                          Base64Decoder decoder = Base64Decoder();
                          final Uint8List buff =
                              decoder.convert(item.imageBase64);
                          Share.file('{$item.title}', '{$item.title}.png', buff,
                              'image/png',
                              text: 'hello world');
                        },
                      ),
                      Spacer(),
                    ],
                  ),
                  Container(
                    width: size.width * .95,
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
                  SizedBox(
                    height: 40,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      Positioned(
          top: size.height * .2,
          left: size.width * .5 - 50,
          child: Opacity(
            opacity: likeOpacity,
            child: Container(
              width: 100,
              height: 100,
              child: FlareActor(
                'assets/like_heart.flr',
                shouldClip: false,
                animation: animation,
                fit: BoxFit.contain,
                callback: (animation) {
                  setState(() {
                    animation = '';
                  });
                },
              ),
            ),
          ))
    ]);
  }
}
