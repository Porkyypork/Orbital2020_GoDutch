import 'dart:io';
import 'package:app/constants/loading.dart';
import 'package:app/models/BillDetails.dart';
import 'package:app/models/itemDetails.dart';
import 'package:app/services/ImageToText.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app/constants/colour.dart';

class PhotoPreviewPage extends StatefulWidget {
  final ImageSource initialSource;
  final List<ItemDetails> itemList;
  final BillDetails billDetails;
  final Function refreshItemPage;

  PhotoPreviewPage({this.initialSource, this.itemList, this.billDetails, this.refreshItemPage});

  @override
  _PhotoPreviewPageState createState() =>
      _PhotoPreviewPageState(initialSource: this.initialSource, itemList: this.itemList, billDetails: this.billDetails, refreshItemPage: this.refreshItemPage);
}

class _PhotoPreviewPageState extends State<PhotoPreviewPage> {
  final ImageSource initialSource;
  final List<ItemDetails> itemList;
  final BillDetails billDetails;
  final Function refreshItemPage;

  File _image;
  bool _inProcess = false;

  _PhotoPreviewPageState(
      {this.initialSource, this.itemList, this.billDetails, this.refreshItemPage});

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
        onPressed: () async {
          List<ItemDetails> items = await ImageToText().generateItemDetails(_image);
          for (ItemDetails item in items) {
            itemList.add(item);
          }
          widget.refreshItemPage();
          Navigator.pop(context);
        },
        child: Icon(
          Icons.arrow_forward,
          size: 35,
          color: Colors.white,
        ));
  }
}
