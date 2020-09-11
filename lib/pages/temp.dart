import 'package:flutter/material.dart';
import 'package:share_box/misc/data.dart';

class Temp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color: abColor,
        child: Column(
          children: [
            SizedBox(
              height: size.height * .4,
            ),
            Container(
                width: size.width * .8,
                child: Text(
                  'Congrats, go pick up your item and make sure the sharebox is left neat :)',
                  style: TextStyle(fontSize: 27, color: Colors.white),
                  textAlign: TextAlign.justify,
                )),
                SizedBox(height: 20,),
            FlatButton(
              color: pinkPop,
              child: Text('continue browsing', style: TextStyle(color: Colors.white),),
              onPressed: () {
                Navigator.popAndPushNamed(context, '/home');
              },
            ),
          ],
        ),
      ),
    );
  }
}
