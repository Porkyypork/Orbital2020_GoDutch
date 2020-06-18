import 'package:app/constants/colour.dart';
import 'package:app/models/GroupDetails.dart';
import 'package:app/models/MemberDetails.dart';
import 'package:app/models/UserDetails.dart';
import 'package:app/screens/pages/group_related/billsDialog.dart';
import 'package:app/services/AccessContacts.dart';
import 'package:app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/models/BillDetails.dart';

import 'btm_nav_bar/ContactListView.dart';
import 'btm_nav_bar/bill_related/Bills.dart';

class _GroupState extends State<Group> {
  PageController _pageController = PageController(
    initialPage: 0,
  );
  int _selectedIndex = 0;
  String billName = "";
  BillDetails billDetails;

    GroupDetails groupdata;

  _GroupState({this.groupdata});

  @override
  Widget build(BuildContext context) {
    String groupName = groupdata.groupName;
    String groupUID = groupdata.groupUID;

    final user = Provider.of<UserDetails>(context);
    DataBaseService dbService =
        DataBaseService(uid: user.uid, groupUID: groupUID);

    return StreamProvider<List<MemberDetails>>.value(
      value: dbService.members,
      child: Scaffold(
        backgroundColor: bodyColour,
        appBar: AppBar(
          backgroundColor: headerColour,
          title: _selectedIndex == 0
              ? Text(
                  groupName,
                  style: TextStyle(color: Colors.white),
                )
              : Text(
                  groupName,
                  style: TextStyle(color: Colors.white),
                ),
          elevation: 0,
          centerTitle: true,
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: (page) {
            setState(() {
              _selectedIndex = page;
            });
          },
          children: <Widget>[
            ContactListView(groupdata: groupdata),
            Bills(dbService: dbService)
          ],
        ),

        bottomNavigationBar: BottomNavigationBar(
          fixedColor: Color(0xFFFFFDD0), // cream
          backgroundColor: headerColour,
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Widget _getFAB(String groupUID, DataBaseService dbService) {
    return _selectedIndex == 0
        ? AccessContacts(groupUID: groupUID)
        : _billsFAB(dbService);
  }

  FloatingActionButton _billsFAB(DataBaseService dbService) {
    return FloatingActionButton.extended(
      onPressed: () {
        _billsDialog(dbService);
      },
      backgroundColor: Colors.orange[300],
      label: Text('Add bill', style: TextStyle(color: Colors.black)),
      elevation: 0,
    );
  }

  Future<dynamic> _billsDialog(DataBaseService dbService) async {
    List<MemberDetails> members = await dbService.members.elementAt(0);
    return showDialog(
        context: context,
        child: BillsDialog(
            dbService: dbService, billName: billName, members: members));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(index, duration: Duration(milliseconds: 340), curve: Curves.easeIn);
    });
  }
}

class Group extends StatefulWidget {
  final GroupDetails data;
  Group({this.data});

  @override
  _GroupState createState() => _GroupState(groupdata: data);
}
