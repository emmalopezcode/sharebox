import 'package:flutter/material.dart';
import 'package:share_box/classes/sharebox_item.dart';
import 'package:share_box/misc/data.dart';
import 'package:share_box/widgets/custom_button.dart';
import 'dart:convert';
import 'package:share_box/services/json_data.dart';
import 'package:share_box/widgets/browse_tile.dart';
import 'package:page_transition/page_transition.dart';
import 'package:share_box/pages/tile_screen.dart';

class WishListTile extends StatelessWidget {
  final ShareBoxItem item;
  final Function delete;
  WishListTile({this.item, this.delete});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            PageTransition(
                child: TileScreen(
                  item: item,
                ),
                type: PageTransitionType.rightToLeft,
                curve: Curves.linear),
          );
        },
        child: Stack(
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      width: size.width * .4,
                      height: size.width * .4,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: MemoryImage(base64.decode(item.imageBase64)),
                      )),
                    ),
                  ),
                  SizedBox(height: 4,),
                  Text(
                    '${item.title}',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.cancel),
              onPressed: delete,
              color: pinkPop,
            ),
          ],
        ),
      ),
    );
  }

  Container buildAlignedTextLabel(String text, BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
        width: size.width * .38,
        //color: Colors.red,
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ));
  }
}
