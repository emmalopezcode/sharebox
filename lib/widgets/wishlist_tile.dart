import 'package:flutter/material.dart';
import 'package:share_box/classes/sharebox_item.dart';
import 'package:share_box/misc/data.dart';
import 'package:share_box/widgets/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:share_box/widgets/browse_tile.dart';

class WishListTile extends StatelessWidget {
  final ShareBoxItem item;
  final Function delete;
  WishListTile({this.item, this.delete});

  
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
                        text: 'remove from wishlist',
                        color: pinkPop,
                        action: ()  {
                          
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

    return Center(
      child: GestureDetector(
        onTap: () {
          createItemDialog(context);
        },
        child: Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 110,
                  width: 110,
                  child: ShareBoxItem.imageFromBase64(item.imageBase64),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width *.49,
                child: Column(
                  children: <Widget>[
                    Text(
                      '${item.title}',
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    SizedBox(height: 5.0),
                    Text(
                      '${item.house}',
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
              Column(
                //mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    child: IconButton(
                      padding: EdgeInsets.symmetric(vertical:0, horizontal:0),
                      onPressed: delete,
                      icon: Icon(Icons.delete_forever, color: Colors.red), 
                      ),
                  )
                ],
              ),
            ],

          ),
        ),
      ),
    );
  }
}


