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

    return ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
        itemCount: members.length,
        itemBuilder: (context, index) {
          return _buildOwedTile(members[index]);
        });
  }

  Widget _buildOwedTile(MemberDetails member) {
    return Container(
      height: 60,
      margin: EdgeInsets.all(3),
      padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
      decoration: BoxDecoration(
        border: Border.all(),
      ),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              // Navigator.push(
              //     context, MaterialPageRoute(builder: (context) => DebtPreview()));
            },
            child: Row(
              children: <Widget>[
                Container(width: 290, child: Text('${member.name}')),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 50,
                      child: Text('\$${member.debt} ',
                          style: (member.debt != 0)
                              ? TextStyle(
                                  fontSize: 20,
                                  color: Colors.red[700],
                                )
                              : TextStyle(
                                  fontSize: 20,
                                  color: Colors.green[700],
                                )),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              // remove all debts
            },
          ),
        ],
      ),
    );
  }
}
