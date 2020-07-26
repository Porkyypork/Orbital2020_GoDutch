import 'dart:io';
import 'package:app/models/BillDetails.dart';
import 'package:app/models/itemDetails.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class ImageToText {
  Future<List<ItemDetails>> generateItemDetails(
      File image, BillDetails bill) async {
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    FirebaseVisionImage toProcess = FirebaseVisionImage.fromFile(image);
    VisionText receiptBlock = await recognizeText.processImage(toProcess);

    List<ItemDetails> items = [];

    List<String> itemNames = [];
    List<double> itemPrice = [];

    for (TextBlock block in receiptBlock.blocks) {
      for (TextLine line in block.lines) {
        String element = line.text;
        print('$element is one line');
        if (!isNumeric(element)) {
          itemNames.add(element);
        } else {
          var checkDecimal = element.split('');
          bool isInteger = true;
          checkDecimal.forEach((char) {
            if (char == '.') {
              isInteger = false;
            }
          });
          if (!isInteger) {
            itemPrice.add(double.parse(element));
          }
        }
      }
    }

    for (int i = 0; i < itemNames.length; i++) {
      String name = itemNames[i];
      double price = itemPrice[i];
      ItemDetails item = new ItemDetails(
        name: name ?? 'error detecting name',
        totalPrice: price ?? '99.99',
        selectedMembers: [],
      );

      items.add(item);
    }

    recognizeText.close();

    return items;
  }

  //returns false if element does not exist or is not a double. True otherwise.
  bool isNumeric(String element) {
    if (element == null) {
      return false;
    }

    return double.tryParse(element) != null;
  }
}
