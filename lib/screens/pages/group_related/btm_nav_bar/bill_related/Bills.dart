import 'package:app/models/BillDetails.dart';
import 'package:app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'BillsListView.dart';

class Bills extends StatefulWidget {
  final DataBaseService dbService;

  Bills({this.dbService});
  @override
  _BillsState createState() => _BillsState(dbService: dbService);
}

class _BillsState extends State<Bills> {
  DataBaseService dbService;
  _BillsState({this.dbService});

  @override
  Widget build(BuildContext context) {

    return StreamProvider<List<BillDetails>>.value(
      value: dbService.bill,
      child: BillsListView(dbService: this.dbService,),
    );
  }
}
