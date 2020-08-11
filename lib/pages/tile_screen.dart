import 'package:flutter/material.dart';
import 'package:share_box/classes/sharebox_item.dart';
import 'package:share_box/misc/data.dart';
import 'package:share_box/services/json_data.dart';

import 'package:share_box/widgets/browse_tile.dart';
import 'package:share_box/widgets/custom_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class TileScreen extends StatefulWidget {
  ShareBoxItem item;
  final Function onFavoritePressed;

  TileScreen({this.item, this.onFavoritePressed});
  @override
  _TileScreenState createState() => _TileScreenState(item: item);
}

class _TileScreenState extends State<TileScreen> {
  final ShareBoxItem item;
  final Function onFavoritePressed;
  _TileScreenState({this.item, this.onFavoritePressed});

  FutureBuilder<bool> buildFavoriteButton() {
    return FutureBuilder<bool>(
      future: isInJson(item),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data) {
            return IconButton(
              icon: Icon(Icons.favorite),
              color: Colors.white,
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

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('${item.title}'),
        backgroundColor: abColor,
        elevation: 0,
      ),
      body: Container(
          color: abColor,
          child: Column(
            children: <Widget>[
              Container(
                width: size.width * .85,
                child: Row(
                  children: <Widget>[
                    Spacer(),
                    buildFavoriteButton(),
                  ],
                ),
              ),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    child: ShareBoxItem.imageFromBase64(item.imageBase64),
                    color: pinkPop,
                    width: size.width * .8,
                    height: size.width * .8,
                  ),
                ),
              ),
              SizedBox(height: 30,),
              Container(
                width: size.width*.8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        ColoredChunk(text:'${item.category}'),
                                      SizedBox(height: 20,),

                        ColoredChunk(text:'${item.house}')

                      ],
                    ),
                    Column(
                      children: <Widget>[
                        ColoredChunk(text:'${item.description}'),
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

  double heightAlgo(){
    double result = text.length*1.0;
    double extra = text.length*1/8;
    result -= extra;
    result += 20;
    return result;

  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: MediaQuery.of(context).size.width * .36,
        height: heightAlgo(),
        color: pinkPop,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 0),
            child: Text(text),
          ),
        ),
      ),
    );
  }
}
