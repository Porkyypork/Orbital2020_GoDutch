import 'dart:io';

import 'package:app/constants/loading.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
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
    _inProcess = true;
    final image = await ImagePicker.pickImage(source: source);

    setState(() {
      _image = image;
      _inProcess = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getImage(this.initialSource);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
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
                      padding: EdgeInsets.only(top: 20, bottom: 20),
                      height: 500,
                      child: _image == null
                          ? Text("no image selected")
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
    return OutlineButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: secondary),
      onPressed: () => getImage(ImageSource.gallery),
      child: Text("Gallery"),
    );
  }

  Widget _buildCameraButton() {
    return OutlineButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: secondary),
      onPressed: () => getImage(ImageSource.camera),
      child: Text("Retake photo"),
    );
  }

  Widget _buildConfirmButton() {
    return OutlineButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        highlightElevation: 0,
        borderSide: BorderSide(color: secondary),
        onPressed: () {},
        child: Text("Confirm"));
  }
}
