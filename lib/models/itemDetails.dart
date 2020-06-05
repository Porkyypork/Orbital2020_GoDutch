import 'package:app/models/MemberDetails.dart';

class ItemDetails{
  String name;
  double price;
  List<MemberDetails> sharingList;

  ItemDetails({
    this.name,
    this.price,
    this.sharingList,
  });
}