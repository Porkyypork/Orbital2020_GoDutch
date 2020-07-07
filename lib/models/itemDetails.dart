import 'package:app/models/MemberDetails.dart';

class ItemDetails {
  String name;
  String itemUID;
  double totalPrice;
  List<MemberDetails> selectedMembers;
  
  ItemDetails({
    this.name,
    this.itemUID,
    this.totalPrice,
    this.selectedMembers
  });
}
