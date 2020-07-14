import 'package:flutter/material.dart';
import 'package:share_box/classes/sharebox_item.dart';
import 'package:share_box/misc/data.dart';
import 'package:share_box/services/json_data.dart';

class FeaturedTile extends StatefulWidget {
  final ShareBoxItem item;
  FeaturedTile({this.item});

  @override
  _FeaturedTileState createState() => _FeaturedTileState(item: item);
}

class _FeaturedTileState extends State<FeaturedTile> {
  ShareBoxItem item;
  _FeaturedTileState({this.item});

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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: <Widget>[
            Container(
              width: size.width,
              height: size.height * .5,
              child: ShareBoxItem.imageFromBase64(item.imageBase64),
            ),
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Spacer(),
                    IconButton(
                      icon: item.inWishlist
                          ? Icon(Icons.favorite)
                          : Icon(Icons.favorite_border),
                      color: pinkPop,
                      onPressed: changeWishlistState,
                    ),
                  ],
                ),
                SizedBox(height: size.height*.35,),
                Text('${item.title}', style: TextStyle(color: Colors.white, fontSize: 35),)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
