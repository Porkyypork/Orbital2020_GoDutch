import 'package:app/models/BillDetails.dart';
import 'package:app/models/MemberDetails.dart';
import 'package:app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Bills extends StatefulWidget {
  final DataBaseService dbService;
  final PanelController pc;

  Bills({this.dbService, this.pc});
  @override
  _BillsState createState() => _BillsState(dbService: dbService, pc: pc);
}

class _BillsState extends State<Bills> {
  DataBaseService dbService;
  PanelController pc;

  _BillsState({this.dbService, this.pc});

  @override
  Widget build(BuildContext context) {
    final members = Provider.of<List<MemberDetails>>(context);

    return StreamProvider<List<BillDetails>>.value(
      value: dbService.bill,
      child: _buildBillsList(),
    );
  }

  Widget _buildBillsList() {
    final bills = Provider.of<List<BillDetails>>(context);

    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0,),
      itemCount: bills.length,
      itemBuilder: (context, index) {
        return _buildBillsListTile(bills[index]);
      }
    );
  }

  Widget _buildBillsListTile(BillDetails bill) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(),
      ),
      child: Row(
        children: <Widget>[
          Text(bill.billName),
          Text('${bill.totalPrice}'),
        ],
      )
    );
  }

}
