import 'package:flutter/material.dart';
import 'package:share_box/classes/sharebox_item.dart';
import 'package:share_box/misc/data.dart';
import 'package:share_box/pages/search.dart';
import 'package:share_box/pages/wishlist.dart';
import 'package:share_box/pages/upload.dart';
import 'package:share_box/pages/browse.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_box/services/json_data.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  static List<ShareBoxItem> items = [
    ShareBoxItem(
        category: 'Clothing',
        house: 'Anderson',
        imgUrl: 'sweatshirt_dark.jpg',
        title: 'sweatshirt',
        description:
            'this is a sweater i found in the dump as a kid but I didnt know what to do with it'),
    ShareBoxItem(
        category: 'Kitchenware',
        house: 'Anderson',
        imgUrl: 'sweatshirt.jpg',
        title: 'tea kettle',
        description: 'tea kettle from memaw'),
    ShareBoxItem(
        category: 'Clothing',
        house: 'Brooks/Buck',
        imgUrl: 'jeans.jpg',
        title: 'jeans',
        description: 'old blue jeans'),
  ];

  List<BottomNavigationBarItem> navBar = [
    BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
    BottomNavigationBarItem(icon: Icon(Icons.search), title: Text('Search')),
    BottomNavigationBarItem(
        icon: Icon(Icons.cloud_upload), title: Text('Upload')),
    BottomNavigationBarItem(
        icon: Icon(Icons.favorite), title: Text('Favorites'))
  ];

  List<Widget> tabs = [Browse(items: items), Search(), Upload(), Wishlist()];

  Firestore db = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: abColor,
        title: Text('Sharebox'),
        centerTitle: true,
        elevation: 0,
      ),
      body: tabs[_currentIndex],
      floatingActionButton: FloatingActionButton(onPressed: createEmptyJson,),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: navBar,
        backgroundColor: gradientEnd,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: pinkPop,
        //unselectedItemColor: abColor,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
