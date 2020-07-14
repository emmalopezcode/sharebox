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
                        action: () {},
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
    return Center(
      child: GestureDetector(
        onTap: () {
          createItemDialog(context);
        },
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    width: size.width * .45,
                    height: size.width * .45,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: MemoryImage(base64.decode(item.imageBase64)),
                    )),
                  ),
                ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                  child: Text(
                    '${item.title}',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Text('${item.category}', style: TextStyle(color: Colors.white)),
                Text('${item.description}', style: TextStyle(color: Colors.white)),
                Text('${item.house}', style: TextStyle(color: Colors.white)),
                IconButton(icon: Icon(Icons.delete_sweep),onPressed: delete,color: pinkPop,),
              ],

            )
          ],
        ),
      ),
    );
  }
}
