class BillDetails {

  String billName;
  String billUID;
  double totalPrice;
  DateTime date;

  BillDetails(String name, String billUID, double totalPrice, DateTime date) {
    this.billName = name;
    this.billUID = billUID;
    this.totalPrice = totalPrice;
    this.date = date;
  }
}