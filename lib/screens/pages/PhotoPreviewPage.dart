import 'dart:io';

import 'package:app/constants/loading.dart';
import 'package:app/services/ImageToText.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app/constants/colour.dart';

class PhotoPreviewPage extends StatefulWidget {
  final ImageSource initialSource;

  PhotoPreviewPage({this.initialSource});

  @override
  _PhotoPreviewPageState createState() =>
      _PhotoPreviewPageState(initialSource: this.initialSource);
}

class _PhotoPreviewPageState extends State<PhotoPreviewPage> {
  final ImageSource initialSource;

  File _image;
  bool _inProcess = false;

  _PhotoPreviewPageState({this.initialSource});

  Future getImage(ImageSource source) async {
    setState(() {
      _inProcess = true;
    });
    final image = await ImagePicker.pickImage(source: source);
    if (image != null) {
      final croppedImage = await ImageCropper.cropImage(
        sourcePath: image.path,
        compressQuality: 100,
        compressFormat: ImageCompressFormat.jpg,
        androidUiSettings: AndroidUiSettings(
          toolbarColor: Colors.deepOrange,
          toolbarTitle: "Crop to show only items",
          statusBarColor: Colors.deepOrange.shade900,
          backgroundColor: Colors.white,
          lockAspectRatio: false,
        ),
      );
      setState(() {
        _image = croppedImage;
        _inProcess = false;
      });
    } else {
      setState(() {
        _inProcess = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getImage(this.initialSource);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: GradientAppBar(
        title: Text(
          "Preview",
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
        gradient: appBarGradient,
        centerTitle: true,
      ),
      body: (_inProcess)
          ? Loading()
          : Center(
              child: Column(
                children: <Widget>[
                  Center(
                    child: Container(
                      color: Colors.black,
                      // padding: EdgeInsets.all(20),
                      height: 500,
                      child: _image == null
                          ? Text("no image selected",
                              style: TextStyle(
                                color: Colors.white,
                              ))
                          : Image.file(_image),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _buildGalleryButton(),
                      SizedBox(width: 20),
                      _buildCameraButton(),
                      SizedBox(width: 20),
                      _buildConfirmButton(),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildGalleryButton() {
    return RawMaterialButton(
      splashColor: Colors.white,
      fillColor: Colors.black,
      shape: CircleBorder(
        side: BorderSide(color: Colors.white),
      ),
      elevation: 2.0,
      padding: EdgeInsets.all(20),
      onPressed: () => getImage(ImageSource.gallery),
      child: Icon(
        Icons.collections,
        size: 35,
        color: Colors.white,
      ),
    );
  }

  Widget _buildCameraButton() {
    return RawMaterialButton(
      splashColor: Colors.white,
      fillColor: Colors.black,
      shape: CircleBorder(
        side: BorderSide(color: Colors.white),
      ),
      elevation: 2.0,
      padding: EdgeInsets.all(20),
      onPressed: () => getImage(ImageSource.camera),
      child: Icon(
        Icons.camera_alt,
        size: 35,
        color: Colors.white,
      ),
    );
  }

  Widget _buildConfirmButton() {
    return RawMaterialButton(
        splashColor: Colors.greenAccent,
        fillColor: Colors.green,
        shape: CircleBorder(),
        elevation: 2.0,
        padding: EdgeInsets.all(20),
        onPressed: () {
          ImageToText().readText(_image);
          // run image to text class
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => DisplayPage()));
        },
        child: Icon(
          Icons.arrow_forward,
          size: 35,
          color: Colors.white,
        ));
  }
}
