import 'package:app/models/GroupDetails.dart';
import 'package:app/models/MemberDetails.dart';
import 'package:app/screens/pages/ContactListView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../../models/UserDetails.dart';
import '../../services/AccessContacts.dart';
import '../../services/database.dart';

// Everyone else starts with a balance of 0, and as people pay, their value decreases, while others increase.
// i.e. for a group of 4 people and split evenly setting. Members are A, B, C, D.
// 1. A pays $10 for something. NEW STATE: [A = -7.5, B = +2.5, C = +2.5, D = +2.5]
// 2. B pays a back to get rid of their debt. NEW STATE: [A = -5, B = 0, C = +2.5, D = +2.5]
// 3. etc...

class _GroupState extends State<Group> {

  GroupDetails groupdata;
  final Firestore db = Firestore.instance;
  

  _GroupState({this.groupdata});

  @override
  Widget build(BuildContext context) {

    String groupName = groupdata.groupName;
    String groupUID = groupdata.groupUID;

    final user = Provider.of<UserDetails>(context);

    return StreamProvider<List<MemberDetails>>.value(
      value: DataBaseService(uid: user.uid, groupUID: groupUID).members,
      child: Scaffold(
        backgroundColor: Colors.indigo[100],
        appBar: AppBar(
          title: Text(groupName),
          elevation: 0,
          backgroundColor: Colors.indigo,
          centerTitle: true,
          actions: <Widget>[
            AccessContacts(groupUID: groupUID),
          ],
        ),
        body: SlidingUpPanel(
          backdropEnabled: true,
          body: ContactListView(groupdata: this.groupdata),
          panel: _menu(),
          collapsed: _floatingCollasped(),
          minHeight: 40,
          maxHeight: 200,
          borderRadius : BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
          ),
      ),
    );
  }

  Widget _floatingCollasped() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Row(
        children: <Widget>[
          SizedBox(width: 20,),
          Icon(Icons.menu)
        ],
      ),
    );
  }

  Widget _menu() {
    return Stack(
          children :<Widget>[ 
            Container(
              decoration: BoxDecoration(
              color: Colors.blue[600],
              borderRadius:  BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                  height: 30,
                ),
                SizedBox(
                  height: 170,
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0),
                          ),
                          color: Colors.blue[400]
                        ),
                        child: Stack(
                          overflow: Overflow.visible,
                          children: <Widget>[
                            Positioned(
                              child: ListView(
                                physics: NeverScrollableScrollPhysics(),
                                children:ListTile.divideTiles(
                                  context: context,
                                  tiles:
                                [
                                  ListTile(
                                    title: Text("Add a Bill"),
                                    onTap: () {

                                    },
                                    leading: Icon(Icons.receipt)
                                  ),
                                  ListTile(
                                    title: Text('Take a photo'),
                                    onTap :() {

                                    },
                                    leading: Icon(Icons.camera_alt),
                                  ),
                                  ListTile(
                                    title: Text("Add a receipt from gallery"),
                                    onTap: () {

                                    },
                                    leading: Icon(Icons.collections),
                                  ),
                                ],
                                ).toList(),
                              ),
                            ),
                          ], 
                        )
                    ),
                ),
              ],
            ),
          ],
    );
  }
}

class Group extends StatefulWidget {
  
  final GroupDetails data;
  Group({this.data});

  @override
  _GroupState createState() => _GroupState(groupdata: data);
}
