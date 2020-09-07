import 'package:flutter/material.dart';

class Temp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Text('Congrats, go pick up your item and make sure the sharebox is left neat :)',),
            FlatButton(
              child: Text('continue browsing'),
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
