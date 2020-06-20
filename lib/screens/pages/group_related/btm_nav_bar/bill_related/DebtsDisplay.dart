import 'package:app/constants/colour.dart';
import 'package:app/models/MemberDetails.dart';
import 'package:app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:app/screens/pages/group_related/btm_nav_bar/bill_related/DebtListView.dart';

class DebtsDisplay extends StatefulWidget {
  final DataBaseService dbService;

  DebtsDisplay({this.dbService});

  @override
  _DebtsDisplayState createState() => _DebtsDisplayState(dbService: dbService);
}

class _DebtsDisplayState extends State<DebtsDisplay> {
  final DataBaseService dbService;

  _DebtsDisplayState({this.dbService});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<MemberDetails>>.value(
      value: dbService.members,
      child: DebtListView(dbService: dbService),
    );
  }
}
