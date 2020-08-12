import 'package:flutter/material.dart';
import 'package:share_box/classes/sharebox_item.dart';
import 'package:share_box/misc/data.dart';
import 'package:share_box/services/json_data.dart';

class FeaturedTile extends StatefulWidget {
  final ShareBoxItem item;
  final Function onFavoritePressed;
  FeaturedTile({this.item, this.onFavoritePressed});

  @override
  _FeaturedTileState createState() =>
      _FeaturedTileState(item: item, onFavoritePressed: onFavoritePressed);
}

class _FeaturedTileState extends State<FeaturedTile> {
  ShareBoxItem item;
  final Function onFavoritePressed;
  _FeaturedTileState({this.item, this.onFavoritePressed});

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
                    
                    buildFavoriteButton(),
                  ],
                ),
                SizedBox(
                  height: size.height * .35,
                ),
                Text(
                  '${item.title}',
                  style: TextStyle(color: Colors.white, fontSize: 35),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
