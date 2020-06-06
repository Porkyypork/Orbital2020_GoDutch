import 'package:app/models/MemberDetails.dart';

class ItemDetails{
  String name;
  double price;
  double qty;
  List<MemberDetails> sharingList;

  ItemDetails({
    this.name,
    this.price,
    this.qty,
    this.sharingList,
  });
}