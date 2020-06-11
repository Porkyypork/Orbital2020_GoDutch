import 'package:app/constants/colour.dart';
import 'package:app/models/GroupDetails.dart';
import 'package:app/models/MemberDetails.dart';
import 'package:app/models/UserDetails.dart';
import 'package:app/screens/pages/ContactListView.dart';
import 'package:app/screens/pages/Items/itemPage.dart';
import 'package:app/services/AccessContacts.dart';
import 'package:app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:app/screens/pages/homepage/BtmNavigation/Bills.dart';

class _GroupState extends State<Group> {
  GroupDetails groupdata;
  final Firestore db = Firestore.instance;
  final PanelController pc = new PanelController();
  int _selectedIndex = 0;
  String billName = "";

  _GroupState({this.groupdata});

  @override
  Widget build(BuildContext context) {
    String groupName = groupdata.groupName;
    String groupUID = groupdata.groupUID;

    final user = Provider.of<UserDetails>(context);
    DataBaseService dbService =
        DataBaseService(uid: user.uid, groupUID: groupUID);

    List<Widget> _widgetOptions = <Widget>[
      Bills(dbService: dbService, pc: pc),
      ContactListView(groupdata: groupdata)
    ];

    return StreamProvider<List<MemberDetails>>.value(
      value: dbService.members,
      child: Scaffold(
        backgroundColor: Colors.blue[50],
        appBar: GradientAppBar(
          gradient: appBarGradient,
          title: Text(
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
    return _selectedIndex == 0
        ? _billsFAB()
        : AccessContacts(groupUID: groupUID);
  }

  FloatingActionButton _billsFAB() {
    return FloatingActionButton(
      onPressed: () {
        _billsDialog();
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

  Future<dynamic> _billsDialog() {
    final user = Provider.of<UserDetails>(context);
    String groupUID = groupdata.groupUID;
    DataBaseService dbService =
        DataBaseService(uid: user.uid, groupUID: groupUID);
    return showDialog(
      context: context,
      child: Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          child: Container(
            height: 225,
            child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          "New Bill",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20.0),
                        )),
                    Padding(
                      padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                      child: TextField(
                        onChanged: (name) {
                          setState(() {
                            billName = name;
                            print(billName);
                          });
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                )),
                            labelText: 'Bill Name'),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(
                                top: 30.0, left: 25.0, right: 30.0),
                            child: FlatButton(
                              child: Text(
                                "Ok",
                                style: TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              color: Colors.teal[300],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              onPressed: () {
                                // need add save bill to database
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ItemPage(
                                            dbService: dbService,
                                            pc: pc,
                                            billName: billName)));
                              },
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                              top: 30.0,
                              left: 15.0,
                            ),
                            child: FlatButton(
                              child: Text(
                                "Close",
                                style: TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              color: Colors.teal[300],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )),
                      ],
                    ),
                  ],
                )),
          )),
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
