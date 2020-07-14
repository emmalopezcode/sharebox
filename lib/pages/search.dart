import 'package:flutter/material.dart';
import 'package:share_box/misc/data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController controller;
  Firestore db = Firestore.instance;
  String test = 'im allergic to you';
  int localSize;

  @override
  void initState() {
    super.initState();
    print('init state called');
    db.collection('sharebox_db').getDocuments().then((docs) {
      print('size is ${docs.documents.length}');
      setState(() {
        localSize = docs.documents.length;
      });
    });
    print('localSize is $localSize');
    print('init state complete');
  }

  int currSize() {
    int result = 0;
    db.collection('sharebox_db').snapshots().listen((data) {
      data.documents.forEach((item) {
        print(item['title']);
        result++;
        print(result);
        //result++;
      });
    });

    return result;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      color: abColor,
      child: Column(
        children: <Widget>[
          Container(
            width: size.width * .8,
            height: 45,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(23),
                border: Border.all(color: pinkPop, width: 3)),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                  child: Icon(
                    Icons.search,
                    color: pinkPop,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(3, 5, 0, 6),
                    child: TextField(
                      controller: controller,
                      decoration: null,
                      style: TextStyle(color: Colors.white, fontSize: 21),
                      cursorColor: pinkPop,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 6),
                  child: IconButton(
                    icon: Icon(Icons.tune),
                    color: pinkPop,
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Container(
                                  color: pinkPop,
                                  height: size.height * .4,
                                  child: Column(
                                    children: <Widget>[
                                      Text('Filter your search'),
                                      Text('Category'),
                                      Text('House')
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                    iconSize: 25,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
