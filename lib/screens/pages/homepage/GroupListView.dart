import 'package:app/models/GroupDetails.dart';
import 'package:app/models/UserDetails.dart';
import 'package:app/screens/pages/group.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/services/database.dart';

class _GroupListViewState extends State<GroupListView> {
  final Firestore db = Firestore.instance;
  UserDetails currentUser;
  TextEditingController searchController = new TextEditingController();

  _GroupListViewState({this.currentUser});

  @override
  Widget build(BuildContext context) {
    final groups = Provider.of<List<GroupDetails>>(context);

    if (groups == null || groups.length == 0) {
      return _buildNoGroupDisplay();
    } else {
      return Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search *not working yet*',
                border: new OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(1000)),
                  borderSide: BorderSide(color: Colors.red),
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Divider(),
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
                itemCount: groups.length,
                itemBuilder: (context, index) {
                  return _buildGroupTile(groups[index]);
                }),
          ),
        ],
      );
    }
  }

  Widget _buildGroupTile(GroupDetails group) {
    final user = Provider.of<UserDetails>(context);
    DataBaseService dbService =
        new DataBaseService(uid: user.uid, groupUID: group.groupUID);

    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          setState(() {
            String groupName = group.groupName;
            dbService.removeGroup();
            _deletionMessage(context, groupName);
          });
        }
      },
      background: _secondaryBackground(),
      secondaryBackground: _deletionBackground(group.groupName),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Group(data: group),
          ));
        },
        child: Container(
          margin: new EdgeInsets.all(10.0),
          decoration: new BoxDecoration(
            borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
            border: Border.all(),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 15.0),
                  child: Icon(Icons.group, color: Colors.black),
                ),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 180,
                        child: Text(
                          group.groupName,
                          style: TextStyle(
                            fontSize: 26,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      SizedBox(width: 80),
                      Column(
                        children: <Widget>[
                          Text(
                            'Members:',
                            style: TextStyle(
                              fontSize: 10,
                            ),
                          ),
                          Text(
                            '${group.numMembers}',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNoGroupDisplay() {
    return Container(
        child: Center(
            child: Text(
      "You are not currently in any groups!\n\nCreate one to get started",
      style: TextStyle(
        fontSize: 24.0,
      ),
    )));
  }

  Widget _deletionBackground(String groupName) {
    return Container(
      alignment: AlignmentDirectional.centerEnd,
      padding: EdgeInsets.only(right: 15.0),
      // color: Colors.red[600],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            'Deleting $groupName',
            style: TextStyle(
              fontSize: 15.0,
              letterSpacing: 1.0,
            ),
          ),
          SizedBox(width: 16),
          Icon(Icons.delete, color: Colors.black),
        ],
      ),
    );
  }

  Widget _secondaryBackground() {
    return Container(
      alignment: AlignmentDirectional.centerStart,
      padding: EdgeInsets.only(left: 15.0),
      color: Colors.yellow[400],
      child: Icon(Icons.photo_camera, color: Colors.black),
    );
  }

  void _deletionMessage(context, String groupName) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("You have deleted $groupName"),
    ));
  }
}

class GroupListView extends StatefulWidget {
  final UserDetails currentUser;
  GroupListView({this.currentUser});

  @override
  _GroupListViewState createState() =>
      _GroupListViewState(currentUser: currentUser);
}
