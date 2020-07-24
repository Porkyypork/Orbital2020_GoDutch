import 'package:app/models/BillDetails.dart';
import 'package:app/models/MemberDetails.dart';
import 'package:app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/screens/pages/group_related/btm_nav_bar/bill_related/DebtListView.dart';

class DebtsDisplay extends StatefulWidget {
  final DataBaseService dbService;
  final BillDetails bill;

  DebtsDisplay({this.dbService, this.bill});

  @override
  _DebtsDisplayState createState() => _DebtsDisplayState(dbService: dbService, bill :bill);
}

class _DebtsDisplayState extends State<DebtsDisplay> {
  final DataBaseService dbService;
  String output;
  BillDetails bill;

  _DebtsDisplayState({this.dbService, this.bill});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<MemberDetails>>.value(
      value: dbService.members,
      child: DebtListView(dbService: dbService, bill: bill),
    );
  }
}
