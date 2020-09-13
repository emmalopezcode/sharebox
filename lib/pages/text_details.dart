import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:page_transition/page_transition.dart';

import 'package:share_box/classes/sharebox_item.dart';
import 'package:share_box/misc/data.dart';

class TextDetails extends StatefulWidget {
  final File imageFile;
  TextDetails({this.imageFile});

  @override
  _TextDetailsState createState() => _TextDetailsState(imageFile: imageFile);
}

class _TextDetailsState extends State<TextDetails> {
  final File imageFile;
  _TextDetailsState({this.imageFile});
  static String warning = '';

  int titleCharacter = 20;
  int descriptionCharacter = 140;
  String houseDDV = 'House';
  String categoryDDV = 'Category';

  static TextEditingController descriptionController = TextEditingController();
  static TextEditingController titleController = TextEditingController();

  void initState() {
    super.initState();
    warning = 'not yet';
  }

  List<String> houses = [
    'House',
    'Rackham Court',
    'Brooks/Buck',
    'Joe McNabb',
    'Anderson',
    'Sylvester',
    'Howard',
    'Lowrey'
  ];

  List<String> categories = [
    'Category',
    'Informal Clothing',
    'Formals',
    'Winter Clothing',
    'Kitchenware',
    'Furniture',
  ];

  void checkDetails() {
    if (houseDDV == 'House') {
      print(warning);
      setState(() {
        warning = 'Please enter a house';
      });
    } else if (categoryDDV == 'Category') {
      setState(() {
        warning = 'Please enter a category';
      });
    } else if (titleController.text == '') {
      setState(() {
        warning = 'Please enter a title';
      });
    } else {
      ShareBoxItem item = ShareBoxItem(
          category: categoryDDV,
          description: descriptionController.text,
          title: titleController.text,
          imageFile: imageFile,
          house: houseDDV);
      categoryDDV = 'Category';
      houseDDV = 'House';
      titleController.text = '';
      descriptionController.text = '';
      Navigator.pop(context, {'return object': item});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
        backgroundColor: abColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      bottomNavigationBar: BottomAppBar(
        color: abColor,
        child: Container(height: 60),
        elevation: 0,
        notchMargin: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [abColor, gradientEnd],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        )),
        child: Column(
          children: <Widget>[
            Expanded(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.file(imageFile))),
            SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width * .8,
              child: Row(
                children: <Widget>[
                  Text('Name',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.white,
                      )),
                  Spacer(),
                  Opacity(
                    opacity: .5,
                    child: Text('$titleCharacter',
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.white,
                        )),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                width: MediaQuery.of(context).size.width * .8,
                height: 30,
                color: pinkPop,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: TextField(
                    controller: titleController,
                    inputFormatters: [LengthLimitingTextInputFormatter(20)],
                    decoration: null,
                    style: TextStyle(color: Colors.white),
                    onChanged: (text) {
                      setState(() {
                        titleCharacter = 20 - text.length;
                      });
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    DropdownButton<String>(
                      value: houseDDV,
                      icon: Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      dropdownColor: pinkPop,
                      style: TextStyle(color: Colors.white),
                      underline: Container(
                        height: 2,
                        color: pinkPop,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          houseDDV = newValue;
                        });
                      },
                      items:
                          houses.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    DropdownButton<String>(
                      value: categoryDDV,
                      icon: Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      dropdownColor: pinkPop,
                      style: TextStyle(color: Colors.white),
                      underline: Container(
                        height: 2,
                        color: pinkPop,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          categoryDDV = newValue;
                        });
                      },
                      items: categories
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width * .8,
              child: Row(
                children: <Widget>[
                  Text('Description',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.white,
                      )),
                  Spacer(),
                  Opacity(
                    opacity: .5,
                    child: Text('$descriptionCharacter',
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.white,
                        )),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                width: MediaQuery.of(context).size.width * .8,
                height: 80,
                color: pinkPop,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  child: TextField(
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    onChanged: (text) {
                      setState(() {
                        descriptionCharacter = 140 - text.length;
                      });
                    },
                    inputFormatters: [LengthLimitingTextInputFormatter(140)],
                    maxLines: 4,
                    keyboardType: TextInputType.multiline,
                    controller: descriptionController,
                    decoration: InputDecoration(
                        focusColor: pinkPop, focusedBorder: InputBorder.none),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              width: MediaQuery.of(context).size.width*.8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FlatButton(
                    color: pinkPop,
                    child: Text('back', style: TextStyle(color: Colors.white),),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton.icon(
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    ),
                    color: pinkPop,
                    label: Text(
                      'next',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: checkDetails,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
