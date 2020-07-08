import 'dart:io';
import 'package:app/models/itemDetails.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class ImageToText {
  Future<List<ItemDetails>> generateItemDetails(File image) async {
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    FirebaseVisionImage toProcess = FirebaseVisionImage.fromFile(image);
    VisionText receiptBlock = await recognizeText.processImage(toProcess);

    List<ItemDetails> items = [
      new ItemDetails(name: 'test item', totalPrice: 22.22, selectedMembers: [])
    ];

    for (TextBlock block in receiptBlock.blocks) {
      print(block.text);
    }

    recognizeText.close();

    return items;
  }
}
