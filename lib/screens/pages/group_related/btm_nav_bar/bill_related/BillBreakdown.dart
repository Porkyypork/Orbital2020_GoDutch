import 'package:app/constants/colour.dart';
import 'package:app/models/BillDetails.dart';
import 'package:app/models/itemDetails.dart';
import 'package:app/screens/pages/Items/itemPage.dart';
import 'package:app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:provider/provider.dart';

import 'BillBreakdownListView.dart';

class BillBreakdown extends StatefulWidget {
  final BillDetails billDetails;
  final DataBaseService dbService;
  BillBreakdown({this.billDetails, this.dbService});
  @override
  _BillBreakdownState createState() => _BillBreakdownState(
      billDetails: this.billDetails, dbService: this.dbService);
}

class _BillBreakdownState extends State<BillBreakdown> {
  BillDetails billDetails;
  DataBaseService dbService;

  _BillBreakdownState({this.billDetails, this.dbService});

  @override
  Widget build(BuildContext context) {
    String userUID = dbService.uid;
    String groupUID = dbService.groupUID;
    String billUID = billDetails.billUID;

    DataBaseService dbServiceItems =
        new DataBaseService(uid: userUID, groupUID: groupUID, billUID: billUID);

    return StreamProvider<List<ItemDetails>>.value(
      value: dbServiceItems.items,
      child: Scaffold(
        floatingActionButton: _editButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        backgroundColor: Colors.blue[50],
        appBar: GradientAppBar(
          gradient: appBarGradient,
          title: Text('${billDetails.billName}'),
          elevation: 0,
          centerTitle: true,
        ),
        body: BillBreakdownListView(),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(color: Colors.teal[500]),
          child: Container(height: 50),
        ),
      ),
    );
  }

  Widget _editButton() {
    return Container(
      child: FloatingActionButton.extended(
          backgroundColor: Colors.teal[300],
          label: Text('Edit',
              style: TextStyle(
                fontSize: 20,
              )),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ItemPage(
                        dbService: dbService, billName: billDetails.billName)));
          }),
    );
  }
}
