import 'package:app/constants/colour.dart';
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

    return bills == null || bills.length == 0
        ? _initialState()
        : ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: bills.length,
            itemBuilder: (context, index) {
              return _buildBillsListTile(
                  bills[index]); // to ensure the latest bill is at the top
            });
  }

  Widget _buildBillsListTile(BillDetails bill) {
    return Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) async {
          if (direction == DismissDirection.endToStart) {
            print('${bill.billUID}'); // for debugging purposes
            dbService.removeBill(bill.billUID);
            _deletionMessage(context, bill.billName);
          }
        },
        background: _deletionBackground(bill),
        child: GestureDetector(
          onTap: () {
            dbService = new DataBaseService(
                uid: dbService.uid,
                groupUID: dbService.groupUID,
                billUID: bill.billUID,
                owedBillUID: bill.owedBillUID);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BillBreakdown(
                          bill: bill,
                          dbService: dbService,
                        )));
          },
          child: Card(
            color: tileColour,
            child: Container(
              padding: EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(
                              top: 5.0, bottom: 5.0, left: 10.0),
                          child: Text(
                            DateFormat('EEE').format(bill.date).toString(),
                            style:
                                TextStyle(fontSize: 17, fontFamily: 'OpenSans'),
                          )),
                      Padding(
                          padding: EdgeInsets.only(bottom: 5.0, left: 10.0),
                          child: Text(
                            DateFormat('d/M').format(bill.date).toString(),
                            style:
                                TextStyle(fontSize: 17, fontFamily: 'OpenSans'),
                          )),
                    ],
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: Padding(
                      padding:
                          EdgeInsets.only(top: 5.0, bottom: 5.0, left: 15.0),
                      child: Text(
                        bill.billName,
                        overflow: TextOverflow.visible,
                        style:
                            TextStyle(fontSize: 25, fontFamily: 'Montserrat'),
                      ),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          top: 5.0, bottom: 5.0, left: 10.0),
                      child: Container(
                        child: Text(
                          '\$${bill.totalPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'OpenSans',
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _deletionBackground(BillDetails bill) {
    return Container(
      alignment: AlignmentDirectional.centerEnd,
      padding: EdgeInsets.only(right: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            'Deleting ${bill.billName}',
            style: TextStyle(color: Colors.red),
          ),
          SizedBox(width: 16),
          Icon(Icons.delete, color: Colors.red),
        ],
      ),
    );
  }

  Widget _initialState() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 120),
              Text(
                "Tap on the Add Icon to get Started!",
                style: TextStyle(fontSize: 22.0, color: Colors.white70),
              ),
              SizedBox(height: 140),
            ],
          ),
        ],
      ),
    );
  }

  void _deletionMessage(context, String itemName) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("You have deleted $itemName"),
    ));
  }
}
