import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';


class ShareBoxItem {
  String imgUrl;
  String house;
  String title;
  String category;
  String description;
  bool inWishlist;
  File imageFile;
  String imageBase64;

  ShareBoxItem(
      {this.imgUrl,
      this.house,
      this.title,
      this.category,
      this.description,
      this.imageFile,
      this.imageBase64,
      this.inWishlist = false});

  ShareBoxItem.fromJson(Map<String, dynamic> json) {
    imageBase64 = json['imageBase64'];
    house = json['house'];
    title = json['title'];
    category = json['category'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() => {
        'imageBase64':imageBase64,
        'house': house,
        'title': title,
        'category': category,
        'description': description
      };

  static String base64String(File file){
    if(file != null)
      return base64Encode(file.readAsBytesSync());
    else
      return 'it was a null file';
  }


  static Image imageFromBase64(String base64String){
    return Image.memory(
      base64Decode(base64String),
      fit:BoxFit.fill
    );
  }

  // static DecorationImage decorationImageFromBase64(String base64String){
  //   return DecorationImage.memory(
  //     base64Decode(base64String),
  //     fit:BoxFit.fill
  //   );
  // }

  equals(ShareBoxItem other) {
    if (this.description == other.description &&
        this.title == other.title &&
        this.category == other.category) {
      return true;
    }
    return false;
  }
}
