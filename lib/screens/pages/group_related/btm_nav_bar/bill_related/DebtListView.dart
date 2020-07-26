import 'package:app/constants/loading.dart';
import 'package:app/models/BillDetails.dart';
import 'package:app/models/MemberDetails.dart';
import 'package:app/models/UserDetails.dart';
import 'package:app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/models/OwedBills.dart';
import 'package:share/share.dart';

class DebtListView extends StatefulWidget {
  final DataBaseService dbService;
  final BillDetails bill;

  DebtListView({this.dbService, this.bill});

  @override
  _DebtListViewState createState() =>
      _DebtListViewState(dbService: dbService, bill: bill);
}

class _DebtListViewState extends State<DebtListView>
    with AutomaticKeepAliveClientMixin<DebtListView> {
  final DataBaseService dbService;
  final BillDetails bill;
  String output;
  double total = 0;
  bool first = true;

  @override
  bool get wantKeepAlive => true;

  _DebtListViewState({this.dbService, this.bill});

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final members = Provider.of<List<MemberDetails>>(context);
    final user = Provider.of<UserDetails>(context);

    return FutureBuilder<List<OwedBills>>(
        future: dbService.getDebt(members),
        builder: (BuildContext context, AsyncSnapshot<List<OwedBills>> snap) {
          if (snap.hasData) {
            String name = snap.data.elementAt(0).billName;
            if (first) {
              for (OwedBills bills in snap.data) {
                total += bills.totalOwed;
              }
              first = false;
            }
            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text('Cash Breakdown',
                      style: TextStyle(
                          letterSpacing: 1,
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'OpenSans')),
                ),
                _heading(name, total),
                Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 10.0,
                      ),
                      itemCount: snap.data.length,
                      itemBuilder: (context, index) {
                        if (user.name != snap.data[index].name) {
                          return _buildBillsListTile(
                              snap.data[index], snap.data.length);
                        } else {
                          return _buildYourListTile(
                              snap.data[index], snap.data.length);
                        }
                      }),
                ),
                SizedBox(height: 15),
                _shareButton(),
                SizedBox(height: 15),
              ],
            );
          } else {
            return Loading();
          }
        });
  }

  Widget _shareButton() {
    return FloatingActionButton.extended(
      label: Text("Share",
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
          )),
      onPressed: () {
        final RenderBox box = context.findRenderObject();
        Share.share(output,
            sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(29),
      ),
      backgroundColor: Colors.orange[300],
    );
  }

  Widget _buildYourListTile(OwedBills owedBill, int length) {
    double total = owedBill.totalOwed * ((100 + bill.extraCharges) / 100) -
        (bill.disc / length);
    output += owedBill.name + " \$" + total.toStringAsFixed(2) + "\n";
    return Padding(
      padding: EdgeInsets.only(top: 10.0, bottom: 10, left: 20, right: 20),
      child: Container(
          child: Row(
        children: <Widget>[
          Text('You pay',
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Montserrat',
              )),
          Spacer(),
          Text(
            '\$${total.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 20, fontFamily: 'Montserrat'),
          ),
        ],
      )),
    );
  }

  Widget _buildBillsListTile(OwedBills owedBill, int length) {
    double total = owedBill.totalOwed * ((100 + bill.extraCharges) / 100) -
        (bill.disc / length);
    output += owedBill.name + " \$" + total.toStringAsFixed(2) + "\n";

    return Padding(
      padding: EdgeInsets.only(top: 10.0, bottom: 10, left: 20, right: 20),
      child: Container(
          child: Row(
        children: <Widget>[
          Text(owedBill.name,
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Montserrat',
              )),
          Spacer(),
          Text(
            '\$${total.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 20, fontFamily: 'Montserrat'),
          ),
        ],
      )),
    );
  }

  Widget _heading(String name, double total) {
    output = "$name\n";
    total = total * ((100 + bill.extraCharges) / 100) - bill.disc;
    output += "Total : \$" + "${total.toStringAsFixed(2)}" + "\n";
    return Container(
        padding: EdgeInsets.only(left: 15, right: 10),
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(width: 1, color: Colors.black),
                bottom: BorderSide(width: 1, color: Colors.black))),
        child: Padding(
          padding: EdgeInsets.only(top: 10.0, bottom: 10, left: 20, right: 20),
          child: Container(
              child: Row(
            children: <Widget>[
              Text('Total :',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans')),
              Spacer(),
              Text('\$${total.toStringAsFixed(2)}',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans')),
            ],
          )),
        ));
  }
}
