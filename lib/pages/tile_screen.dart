import 'package:flutter/material.dart';
import 'package:share_box/classes/sharebox_item.dart';
import 'package:share_box/misc/data.dart';
import 'package:share_box/services/json_data.dart';

import 'package:share_box/widgets/browse_tile.dart';
import 'package:share_box/widgets/custom_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class TileScreen extends StatefulWidget {
  final ShareBoxItem item;
  final Function onFavoritePressed;

  TileScreen({this.item, this.onFavoritePressed});
  @override
  _TileScreenState createState() =>
      _TileScreenState(item: item, onFavoritePressed: onFavoritePressed);
}

class _TileScreenState extends State<TileScreen> {
  final ShareBoxItem item;
  final Function onFavoritePressed;
  _TileScreenState({this.item, this.onFavoritePressed});
  String test = 'yay';

  @override
  void initState() {
    super.initState();
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

  FutureBuilder<bool> buildFavoriteButton() {
    return FutureBuilder<bool>(
      future: isInJson(item),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data) {
            return IconButton(
              icon: Icon(Icons.favorite),
              color: pinkPop,
              onPressed: () {
                changeWishlistState(item);
              },
            );
          } else {
            return IconButton(
              icon: Icon(Icons.favorite_border),
              color: pinkPop,
              onPressed: () {
                changeWishlistState(item);
              },
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

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('${item.title}'),
        backgroundColor: abColor,
        elevation: 0,
        actions: <Widget>[
          buildFavoriteButton(),
          SizedBox(
            width: size.width * .08,
          )
        ],
      ),
      body: Container(
          color: abColor,
          child: Column(
            children: <Widget>[
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    child: ShareBoxItem.imageFromBase64(item.imageBase64),
                    color: pinkPop,
                    width: size.width * .87,
                    height: size.width * .87,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: size.width * .8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Container(
                          width: size.width * .8,
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
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            ColoredChunk(text: '${item.house}'),
                            SizedBox(
                              width: 15,
                            ),
                            ColoredChunk(text: '${item.category}')
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                       
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(border: Border.all(color:pinkPop,width:5)),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Return Home',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}

class ColoredChunk extends StatelessWidget {
  ColoredChunk({this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: MediaQuery.of(context).size.width * .33,
        height: 34,
        color: pinkPop,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            child: Text(
              text,
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ),
      ),
    );
  }
}
