import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_box/classes/sharebox_item.dart';
import 'package:share_box/misc/data.dart';
import 'package:share_box/pages/final_upload.dart';
import 'package:share_box/widgets/custom_button.dart';
import 'package:share_box/pages/text_details.dart';

class Upload extends StatefulWidget {
  @override
  _UploadState createState() => _UploadState();
}

//TODO ios testing [imageg_cropper site] & see line 166

class _UploadState extends State<Upload> {
  /// Active image file
  File _imageFile;
  ShareBoxItem item;

  /// Cropper plugin
  Future<void> _cropImage() async {
    print('crop image called');
    File cropped = await ImageCropper.cropImage(
        sourcePath: _imageFile.path,
        maxWidth: 512,
        maxHeight: 512,
        androidUiSettings: AndroidUiSettings(
            toolbarColor: pinkPop,
            toolbarWidgetColor: Colors.white,
            toolbarTitle: 'Crop',
            hideBottomControls: true,
            initAspectRatio: CropAspectRatioPreset.square),
        iosUiSettings: IOSUiSettings());

    setState(() {
      print('set state called');
      _imageFile = cropped ?? _imageFile;
      //item.imageFile = _imageFile;
    });
  }


  Future<void> sendImage(File image) async {
    print('send image called');
    dynamic result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => TextDetails(imageFile: image)));
    setState(() {
      item = result['return object'];
      print(item);
    });
  }

  /// Select an image via gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      _imageFile = selected;
    });
  }

  /// Remove image
  void _clear() {
    setState(() => _imageFile = null);
  }

  void pickImageCamera() async {
    File selected = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _imageFile = selected;
    });
  }
  void pickImageGallery() async {
    File selected = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = selected;
    });
  }

  Widget bodyWidget() {
    //logic based widget depending on whether an image has been selected or not
    if (_imageFile == null) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            Text(
              "Let's get started!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 40.0,
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              width: MediaQuery.of(context).size.width * .85,
              child: Opacity(
                opacity: 0.8,
                child: Text(
                  "Take a photo of your item or select one you have already taken",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * .4,
                    height: MediaQuery.of(context).size.width * .4,
                    color: pinkPop,
                    padding: EdgeInsets.all(4),
                    child: GestureDetector(
                        onTap: pickImageCamera,
                        child: Icon(
                          Icons.camera,
                          color: Colors.white,
                          size: MediaQuery.of(context).size.width * .3,
                        )),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * .4,
                    height: MediaQuery.of(context).size.width * .4,
                    color: pinkPop,
                    padding: EdgeInsets.all(4),
                    child: GestureDetector(
                        onTap: pickImageGallery,
                        child: Icon(
                          Icons.photo_library,
                          color: Colors.white,
                          size: MediaQuery.of(context).size.width * .3,
                        )),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Container(
              child: Image.file(_imageFile),
              width: MediaQuery.of(context).size.width * .8,
              height: MediaQuery.of(context).size.width * .8,
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton.icon(
                icon: Icon(Icons.arrow_back_ios, color: Colors.white,),
                color: pinkPop,
                label: Text('retake', style: TextStyle(color: Colors.white)),
                onPressed: _clear,
              ),
              FlatButton.icon(
                icon: Icon(Icons.arrow_forward_ios, color: Colors.white,),
                color: pinkPop,
                label: Text('next', style: TextStyle(color: Colors.white),),
                onPressed: () async {
                  await _cropImage();
                  await sendImage(_imageFile);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FinalUpload(item)));
                },
              ),
            ],
          )
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [abColor, gradientEnd],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: bodyWidget(),
      ),
    );
  }
}
