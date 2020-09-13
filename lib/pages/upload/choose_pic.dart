import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_box/classes/sharebox_item.dart';
import 'package:share_box/misc/data.dart';
import 'package:share_box/pages/final_upload.dart';
import 'package:share_box/widgets/custom_button.dart';
import 'package:share_box/pages/text_details.dart';
import 'package:page_transition/page_transition.dart';

class ChoosePicture extends StatefulWidget {
  @override
  _ChoosePictureState createState() => _ChoosePictureState();
}

class _ChoosePictureState extends State<ChoosePicture> {
  File imageFile;
  Widget image;
  Widget secondButton;
  bool isCropped = false;
  ShareBoxItem item;

  /// Remove image
  ///
  Future<void> sendImage(File image) async {
    print('send image called');

    dynamic result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => TextDetails(imageFile: image)));
    setState(() {
      item = result['return object'];
      print(item);
    });
  }

  void pickImageCamera() async {
    File selected = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      imageFile = selected;
    });
  }

  void pickImageGallery() async {
    File selected = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = selected;
    });
  }

  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
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
      imageFile = cropped ?? imageFile;
      isCropped = true;
      //item.imageFile = _imageFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: abColor,
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
                  width: size.width * .4,
                  height: size.width * .4,
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
                  width: size.width * .4,
                  height: size.width * .4,
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
          SizedBox(
            height: 30,
          ),
          image = (imageFile == null)
              ? Container()
              : Column(
                  children: [
                    Container(
                      width: size.height * .32,
                      height: size.height * .32,
                      child: Image.file(imageFile),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: size.width * .9,
                      child: Row(
                        mainAxisAlignment: (isCropped == false)
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.spaceBetween,
                        children: [
                          FlatButton(
                            color: pinkPop,
                            child: Text('crop',
                                style: TextStyle(color: Colors.white)),
                            onPressed: () async {
                              await _cropImage();
                            },
                          ),
                          secondButton = (isCropped == false)
                              ? Container()
                              : FlatButton(
                                  color: pinkPop,
                                  child: Text(
                                    'next',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () async {
                                    await sendImage(imageFile);
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                          child: FinalUpload(item),
                                          type: PageTransitionType.rightToLeft,
                                          curve: Curves.linear),
                                    );
                                  },
                                )
                        ],
                      ),
                    )
                  ],
                )
        ],
      ),
    );
  }
}
