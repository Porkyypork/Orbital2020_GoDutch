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
            return ListView.builder(
                padding: EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 10.0,
                ),
                itemCount: snap.data.length,
                itemBuilder: (context, index) {
                  return _buildBillsListTile(snap
                      .data[index]); // to ensure the latest bill is at the top
                });
          } else {
            return _initialState();
          }
        });
  }

  Widget _buildBillsListTile(OwedBills bill) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Container(
          child: Row(
        children: <Widget>[
          Text(bill.name),
          Text(bill.totalOwed.toStringAsFixed(2)),
        ],
      )),
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
                style: TextStyle(fontSize: 22.0),
              ),
              SizedBox(height: 140),
            ],
          ),
        ],
      ),
    );
  }

  void debug(List<OwedBills> bills) {
    for (OwedBills bill in bills) {
      print(bill.name);
    }
  }
}
