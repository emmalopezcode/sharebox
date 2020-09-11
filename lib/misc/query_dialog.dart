import 'package:flutter/material.dart';
import 'package:share_box/misc/data.dart';

class QueryDialog extends StatefulWidget {
  QueryDialog(
      {this.houseDDV,
      this.height,
      this.houses,
      this.queryOk,
      this.querySelect});

  String houseDDV;
  final List<String> houses;
  final double height;
  final Function queryOk;
  final Function querySelect;

  @override
  _QueryDialogState createState() => _QueryDialogState();
}

class _QueryDialogState extends State<QueryDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: abColor,
      content: Container(
        height: widget.height * .2,
        child: Column(
          children: [
            Text(
              'Which house?',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            SizedBox(height: 10,),
            DropdownButton<String>(
              value: widget.houseDDV,
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
                  widget.houseDDV = newValue;
                  widget.querySelect(newValue);
                  print(widget.houseDDV);
                });
              },
              items:
                  widget.houses.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
                        SizedBox(height: 10,),

            FlatButton(
              color: pinkPop,
              child: Text(
                "Okay",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                widget.queryOk();
              },
            )
          ],
        ),
      ),
    );
  }
}
