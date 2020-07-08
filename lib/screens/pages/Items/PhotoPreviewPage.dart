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

import '../../../services/database.dart';
import 'itemPage.dart';

class PhotoPreviewPage extends StatefulWidget {
  final ImageSource initialSource;
  final DataBaseService dbService;
  final List<ItemDetails> itemList;
  final BillDetails billDetails;

  PhotoPreviewPage(
      {this.initialSource, this.dbService, this.itemList, this.billDetails});

  @override
  _PhotoPreviewPageState createState() => _PhotoPreviewPageState(
      initialSource: this.initialSource,
      dbService: this.dbService,
      itemList: this.itemList,
      billDetails: this.billDetails);
}

class _PhotoPreviewPageState extends State<PhotoPreviewPage> {
  final ImageSource initialSource;
  final DataBaseService dbService;

  final List<ItemDetails> itemList;
  final BillDetails billDetails;

  File _image;
  bool _inProcess = false;

  _PhotoPreviewPageState(
      {this.initialSource, this.dbService, this.itemList, this.billDetails});

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
          List<ItemDetails> items =
              await ImageToText().generateItemDetails(_image);
          for (ItemDetails item in items) {
            itemList.add(item);
          }
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ItemPage(
                      dbService: dbService,
                      itemList: itemList,
                      billDetails: billDetails)));
        },
        child: Icon(
          Icons.arrow_forward,
          size: 35,
          color: Colors.white,
        ));
  }
}
