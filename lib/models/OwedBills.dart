import 'package:cloud_firestore/cloud_firestore.dart';

class OwedBills {
  String billName;
  String name;
  double totalPrice;
  double totalOwed;

  OwedBills({this.billName, this.name, this.totalOwed, this.totalPrice});

  OwedBills.fromSnapshot(DocumentSnapshot snapshot) {
    if (snapshot['totalOwed'] != 0) {
      this.billName = snapshot['billName'];
      this.name = snapshot['Name'];
      this.totalPrice = snapshot['totalPrice'];
      this.totalOwed = snapshot['totalOwed'];
    }
  }
}
