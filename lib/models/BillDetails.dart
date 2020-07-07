class BillDetails {

  String billName;
  String billUID;
  String owedBillUID;
  double totalPrice;
  DateTime date;
  int gst;
  int svc;

  BillDetails(String name, String billUID, String owedBillUID, double totalPrice, DateTime date, int gst, int svc) {
    this.billName = name;
    this.billUID = billUID;
    this.owedBillUID = owedBillUID;
    this.totalPrice = totalPrice;
    this.date = date;
    this.gst = gst;
    this.svc = svc;
  }
}