import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class ImageToText {

  Future readText(File image) async {
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    FirebaseVisionImage toRead = FirebaseVisionImage.fromFile(image);
    VisionText readThis = await recognizeText.processImage(toRead);

    for (TextBlock block in readThis.blocks) {
      print(block.text);
    }
    
  }
}