class BillDetails {

  String billName;
  String billUID;
  String owedBillUID;
  double totalPrice;
  DateTime date;

  BillDetails(String name, String billUID, String owedBillUID, double totalPrice, DateTime date) {
    this.billName = name;
    this.billUID = billUID;
    this.owedBillUID = owedBillUID;
    this.totalPrice = totalPrice;
    this.date = date;
  }
}