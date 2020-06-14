import 'package:app/models/BillDetails.dart';
import 'package:app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'BillBreakdown.dart';

class BillsListView extends StatefulWidget {
  final DataBaseService dbService;
  BillsListView({this.dbService});
  @override
  _BillsListViewState createState() =>
      _BillsListViewState(dbService: dbService);
}

class _BillsListViewState extends State<BillsListView> {
  DataBaseService dbService;
  _BillsListViewState({this.dbService});

  @override
  Widget build(BuildContext context) {
    final bills = Provider.of<List<BillDetails>>(context);

    return ListView.builder(
        padding: EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 10.0,
        ),
        itemCount: bills.length,
        itemBuilder: (context, index) {
          return _buildBillsListTile(bills[bills.length -
              index -
              1]); // to ensure the latest bill is at the top
        });
  }

  Widget _buildBillsListTile(BillDetails bill) {
    return Dismissible(
        key: UniqueKey(),
        onDismissed: (direction) {
          print('${bill.billUID}'); // for debugging purposes
          dbService.removeBill(bill.billUID);
          _deletionMessage(context, bill.billName);
        },
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BillBreakdown(
                          billDetails: bill,
                          dbService: dbService,
                        )));
          },
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Container(
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(
                              top: 5.0, bottom: 5.0, left: 10.0),
                          child: Text(
                            DateFormat('EEE').format(bill.date).toString(),
                            style: TextStyle(fontSize: 17),
                          )),
                      Padding(
                          padding: EdgeInsets.only(bottom: 5.0, left: 10.0),
                          child: Text(
                            DateFormat('d/M').format(bill.date).toString(),
                            style: TextStyle(fontSize: 17),
                          )),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 10.0),
                    child: Text(
                      bill.billName,
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                  Spacer(),
                  Padding(
                      padding: EdgeInsets.only(
                          top: 5.0, bottom: 5.0, left: 10.0, right: 10.0),
                      child: Container(
                        child: Text(
                          '\$${bill.totalPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ));
  }

  void _deletionMessage(context, String itemName) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("You have deleted $itemName"),
    ));
  }
}
