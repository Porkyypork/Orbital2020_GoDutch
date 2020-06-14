import 'package:app/constants/colour.dart';
import 'package:app/models/BillDetails.dart';
import 'package:app/models/itemDetails.dart';
import 'package:app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:provider/provider.dart';

import 'BillBreakdownListView.dart';

class BillBreakdown extends StatefulWidget {
  BillDetails billDetails;
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
}
