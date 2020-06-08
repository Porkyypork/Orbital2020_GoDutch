import 'package:app/models/GroupDetails.dart';
import 'package:app/models/MemberDetails.dart';
import 'package:app/screens/pages/ContactListView.dart';
import 'package:app/screens/pages/Items/itemPage.dart';
import 'package:app/screens/pages/PhotoPreviewPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../../models/UserDetails.dart';
import '../../services/AccessContacts.dart';
import '../../services/database.dart';

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
        backgroundColor: Colors.blue[50],
        appBar: AppBar(
          title: Text(
            groupName,
            style: TextStyle(color: Colors.white),
          ),
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
          borderRadius: BorderRadius.only(
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[Icon(Icons.menu)],
      ),
    );
  }

  Widget _menu() {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Colors.indigo,
            borderRadius: BorderRadius.only(
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
                      color: Colors.blue[100]),
                  child: Stack(
                    overflow: Overflow.visible,
                    children: <Widget>[
                      Positioned(
                        child: ListView(
                          physics: NeverScrollableScrollPhysics(),
                          children: ListTile.divideTiles(
                            context: context,
                            tiles: [
                              ListTile(
                                  title: Text("Key in a Bill"),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ItemPage()));
                                  },
                                  leading: Icon(Icons.receipt)),
                              ListTile(
                                title: Text('Take a Photo'),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PhotoPreviewPage(
                                                  initialSource: ImageSource.camera)));
                                },
                                leading: Icon(Icons.camera_alt),
                              ),
                              ListTile(
                                title: Text("Add a Receipt from Gallery"),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PhotoPreviewPage(
                                                  initialSource:
                                                      ImageSource.gallery)));
                                },
                                leading: Icon(Icons.collections),
                              ),
                            ],
                          ).toList(),
                        ),
                      ),
                    ],
                  )),
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
