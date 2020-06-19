import 'package:app/constants/loading.dart';
import 'package:app/models/MemberDetails.dart';
import 'package:app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/models/OwedBills.dart';

class DebtListView extends StatefulWidget {
  final DataBaseService dbService;

  DebtListView({this.dbService});

  @override
  _DebtListViewState createState() => _DebtListViewState(dbService: dbService);
}

class _DebtListViewState extends State<DebtListView> {
  final DataBaseService dbService;

  _DebtListViewState({this.dbService});

  @override
  Widget build(BuildContext context) {
    final members = Provider.of<List<MemberDetails>>(context);

    return FutureBuilder<List<OwedBills>>(
        future: dbService.getDebt(members),
        builder: (BuildContext context, AsyncSnapshot<List<OwedBills>> snap) {
          if (snap.hasData) {
            return SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(snap.data.elementAt(0).billName,
                        style: TextStyle(
                            fontSize: 27, fontWeight: FontWeight.bold)),
                  ),
                  _heading(snap),
                  ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 10.0,
                      ),
                      itemCount: snap.data.length,
                      itemBuilder: (context, index) {
                        return _buildBillsListTile(snap.data[index]);
                      }),
                ],
              ),
            );
          } else {
            return Loading();
          }
        });
  }

  Widget _buildBillsListTile(OwedBills bill) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0, bottom: 10, left: 20, right: 20),
      child: Container(
          child: Row(
        children: <Widget>[
          Text(bill.name,
          style: TextStyle(
            fontSize: 20
          )),
          Spacer(),
          Text('\$${bill.totalOwed.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 20
          )),
        ],
      )),
    );
  }

  Widget _heading(AsyncSnapshot<List<OwedBills>> snap) {
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
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Spacer(),
              Text('\$${snap.data.elementAt(0).totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          )),
        ));
  }
}
