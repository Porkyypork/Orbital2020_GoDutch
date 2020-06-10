import 'package:app/models/GroupDetails.dart';
import 'package:app/models/MemberDetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:gradient_bottom_navigation_bar/gradient_bottom_navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../../constants/colour.dart';
import '../../models/UserDetails.dart';
import '../../services/AccessContacts.dart';
import '../../services/database.dart';
import 'package:app/screens/pages/Bills.dart';

import 'ContactListView.dart';
import 'Items/itemPage.dart';

class _GroupState extends State<Group> {

  GroupDetails groupdata;
  final Firestore db = Firestore.instance;
  int _selectedIndex = 0;
  final PanelController pc = new PanelController();

  _GroupState({this.groupdata});

  @override
  Widget build(BuildContext context) {

    String groupName = groupdata.groupName;
    String groupUID = groupdata.groupUID;

    final user = Provider.of<UserDetails>(context);
    DataBaseService dbService =
        DataBaseService(uid: user.uid, groupUID: groupUID);

    List<Widget> _widgetOptions = 
              <Widget>[
                Bills(dbService : dbService, pc : pc),
                ContactListView(groupdata : groupdata)
              ];

    return StreamProvider<List<MemberDetails>>.value(
      value: dbService.members,
      child: Scaffold(
        backgroundColor: Colors.blue[50],
        appBar: GradientAppBar(
          gradient : appBarGradient,
          title: Text(
            groupName,
            style: TextStyle(color: Colors.white),
          ),
          elevation: 0,
          centerTitle: true,
        ),
        body : _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          fixedColor: Color(0xFFFFFDD0), // cream
          backgroundColor: Colors.teal[500],
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.receipt), title: Text('Bills')),
            BottomNavigationBarItem(
                icon: Icon(Icons.group), title: Text('Members'))
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
        floatingActionButton: _getFAB(groupUID),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  Widget _getFAB(String groupUID) {
    return _selectedIndex == 0 ? _billsFAB() : AccessContacts(groupUID: groupUID);
  }

  FloatingActionButton _billsFAB() {
    final user = Provider.of<UserDetails>(context);
    String groupUID = groupdata.groupUID;
    DataBaseService dbService =
        DataBaseService(uid: user.uid, groupUID: groupUID);

      return FloatingActionButton(
        onPressed : () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ItemPage(dbService: dbService, pc: pc)));
        },
        child : Container(
        height: 70,
        width: 70,
        decoration: BoxDecoration(
          border: Border.all (
            color: Colors.teal[500],
            width: 5
          ),
          shape : BoxShape.circle,
          color : Color(0xFF48D1CC), // this is the green button idk if it looks good? need change on AcccessContacts also
        ),
        child : Icon(Icons.add, size :30, color: Colors.black),
      ),
       elevation: 0,
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
