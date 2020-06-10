class BillDetails {

  String billName;
  String billUID;
  double totalPrice;
  final DateTime date = DateTime.now();

  BillDetails(String name, String billUID) {
    this.billName = name;
    this.billUID = billUID;
    this.totalPrice = 0.0;
  }
}