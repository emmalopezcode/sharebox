import 'package:flutter/material.dart';
import 'package:share_box/classes/sharebox_item.dart';
import 'package:share_box/misc/data.dart';
import 'package:share_box/widgets/browse_tile.dart';
import 'package:share_box/widgets/custom_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FinalUpload extends StatefulWidget {
  final ShareBoxItem item;
  FinalUpload(this.item);

  @override
  _FinalUploadState createState() => _FinalUploadState(item);
}

class _FinalUploadState extends State<FinalUpload> {
  ShareBoxItem item;
  _FinalUploadState(this.item);
  FirebaseFirestore db = FirebaseFirestore.instance;
  String isComplete = 'Ready to Upload?';
  Widget loading = SizedBox(height: 10);
  Function buttonAction;
  Icon buttonIcon = Icon(
    Icons.cloud_upload,
    color: Colors.white,
  );
  bool hasUploaded = false;
  Widget backButton;
  String buttonText = 'upload';

  void initState() {
    super.initState();
    buttonAction = upload;
  }

  void upload() async {
    setState(() {
      isComplete = 'Upload in progress';
      loading = SpinKitWave(
        color: Colors.white,
        size: 10,
      );
    });
    await db.collection('sharebox_db').add({
      'title': item.title,
      'category': item.category,
      'description': item.description,
      'house': item.house,
      'imageBase64': ShareBoxItem.base64String(item.imageFile)
    });
    setState(() {
      isComplete = 'Upload Complete! Return to Home?';
      loading = SizedBox(height: 10);
      buttonAction = returnHome;
      buttonIcon = Icon(
        Icons.home,
        color: Colors.white,
      );
      buttonText = 'Home';
      hasUploaded = true;
    });
  }

  void returnHome() {
    Navigator.of(context).popAndPushNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: abColor,
        automaticallyImplyLeading: false,
        title: Text('$isComplete'),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          Container(
            width: size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [abColor, gradientEnd],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(
                    width: size.width * .1,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      child: Image.file(item.imageFile),
                      color: pinkPop,
                      width: size.width * .8,
                      height: size.width * .8,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * .03,
              ),
              Text(
                '${item.title}',
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
              SizedBox(
                height: size.height * .03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ClipRRect(
                      borderRadius: BorderRadius.circular(13),
                      child: Container(
                          padding: EdgeInsets.all(8),
                          color: pinkPop,
                          child: Text('${item.house}',
                              style: TextStyle(color: Colors.white)))),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      color: pinkPop,
                      child: Text('${item.category}',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * .03,
              ),
              Container(
                width: size.width * .65,
                child: Text('${item.description}',
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
              SizedBox(
                height: size.height * .03,
              ),
              Row(
                mainAxisAlignment: (hasUploaded == true)?MainAxisAlignment.center:MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  backButton = (hasUploaded == true)
                      ? Container()
                      : FlatButton.icon(
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 15,
                          ),
                          color: pinkPop,
                          label: Text(
                            'back',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                  FlatButton.icon(
                    icon: buttonIcon,
                    color: pinkPop,
                    label: Text(
                      '$buttonText',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: buttonAction,
                  ),
                ],
              ),
              loading,
              SizedBox(
                height: size.height * .03,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
