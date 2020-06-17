import 'package:app/constants/colour.dart';
import 'package:app/models/GroupDetails.dart';
import 'package:app/models/MemberDetails.dart';
import 'package:app/models/UserDetails.dart';
import 'package:app/screens/pages/group_related/billsDialog.dart';
import 'package:app/services/AccessContacts.dart';
import 'package:app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:app/models/BillDetails.dart';

import 'btm_nav_bar/ContactListView.dart';
import 'btm_nav_bar/bill_related/Bills.dart';

class _GroupState extends State<Group> {
  GroupDetails groupdata;
  final Firestore db = Firestore.instance;
  int _selectedIndex = 0;
  String billName = "";
  BillDetails billDetails;

  _GroupState({this.groupdata});

  @override
  Widget build(BuildContext context) {
    String groupName = groupdata.groupName;
    String groupUID = groupdata.groupUID;

    final user = Provider.of<UserDetails>(context);
    DataBaseService dbService =
        DataBaseService(uid: user.uid, groupUID: groupUID);

    List<Widget> _widgetOptions = <Widget>[
      ContactListView(groupdata: groupdata),
      Bills(dbService: dbService)
    ];

    return StreamProvider<List<MemberDetails>>.value(
      value: dbService.members,
      child: Scaffold(
        backgroundColor: Colors.blue[50],
        appBar: GradientAppBar(
          gradient: appBarGradient,
          title: _selectedIndex == 0
              ? Text(
                'Members',
                style :TextStyle(color: Colors.white), 
              )
              : Text(
                  groupName,
                  style: TextStyle(color: Colors.white),
                ),
          elevation: 0,
          centerTitle: true,
        ),
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          fixedColor: Color(0xFFFFFDD0), // cream
          backgroundColor: Colors.teal[500],
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.group), title: Text('Members')),
            BottomNavigationBarItem(
                icon: Icon(Icons.receipt), title: Text('Bills'))
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
        floatingActionButton: _getFAB(groupUID, dbService),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  Widget _getFAB(String groupUID, DataBaseService dbService) {
    return _selectedIndex == 0
        ? AccessContacts(groupUID: groupUID)
        : _billsFAB(dbService);
  }

  FloatingActionButton _billsFAB(DataBaseService dbService) {
    return FloatingActionButton(
      onPressed: () {
        _billsDialog(dbService);
      },
      child: Container(
        height: 70,
        width: 70,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.teal[500], width: 5),
          shape: BoxShape.circle,
          color: Color(
              0xFF48D1CC), // this is the green button idk if it looks good? need change on AcccessContacts also
        ),
        child: Icon(Icons.add, size: 30, color: Colors.black),
      ),
      elevation: 0,
    );
  }

  Future<dynamic> _billsDialog(DataBaseService dbService) async {
    List<MemberDetails> members = await dbService.members.elementAt(0);
    return showDialog(
      context: context,
      child: BillsDialog(dbService: dbService, billName : billName, members : members)
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

class Group extends StatefulWidget {
  final GroupDetails data;
  Group({this.data});

  @override
  _GroupState createState() => _GroupState(groupdata: data);
}
