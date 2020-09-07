import 'package:flutter/material.dart';
import 'package:share_box/pages/home.dart';
import 'package:share_box/pages/loading.dart';
import 'package:share_box/pages/wishlist.dart';
import 'package:share_box/pages/search.dart';
import 'package:share_box/pages/upload.dart';
import 'package:share_box/pages/text_details.dart';
import 'package:share_box/pages/temp.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(app);
}

MaterialApp app = MaterialApp(
  initialRoute: '/home',
  routes: {
    '/': (context) => Loading(),
    '/home': (context) => Home(),
    '/search': (context) => Search(),
    '/upload': (context) => Upload(),
    '/wishlist': (context) => Wishlist(),
    '/text_details': (context) => TextDetails(),
    '/temp': (context) => Temp(),
  },
);
