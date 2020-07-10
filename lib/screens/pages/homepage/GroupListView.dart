import 'package:app/constants/colour.dart';
import 'package:app/models/GroupDetails.dart';
import 'package:app/models/UserDetails.dart';
import 'package:app/screens/pages/group_related/group.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/services/database.dart';

class _GroupListViewState extends State<GroupListView> {
  TextEditingController searchController = new TextEditingController();

  UserDetails currentUser;
  _GroupListViewState({this.currentUser});

  @override
  Widget build(BuildContext context) {
    final groups = Provider.of<List<GroupDetails>>(context);
    if (groups == null || groups.length == 0) {
      return _buildNoGroupDisplay();
    } else {
      return Expanded(
        child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.all(5),
            itemCount: groups.length,
            itemBuilder: (context, index) {
              return _buildGroupTile(groups[index]);
            }),
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
      background: _deletionBackground(group.groupName),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Group(data: group),
          ));
        },
        onLongPress: () {
          showDialog(
            context: context,
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0)),
              child: Container(
                height: 275,
                width: 275,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 20.0, left: 20.0, right: 20.0),
                        child: Text("Members",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0)),
                      ),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.only(
                              bottom: 10.0, left: 10.0, right: 10.0),
                          itemCount: group.members.length,
                          itemBuilder: (context, index) {
                            return Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 20, left: 15, right: 20),
                                  child: Container(
                                      child: Text("${index + 1}.",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontFamily: 'OpenSans'))),
                                ),
                                Flexible(
                                  child: Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 20, left: 10, right: 20),
                                      child: Text(
                                          group.members.elementAt(index),
                                          overflow: TextOverflow.visible,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontFamily: 'OpenSans'))),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        child: Card(
          margin: EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 10),
          color: tileColour,
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 20, 5, 20),
            child: Row(
              children: <Widget>[
                Container(
                    width: 50, child: Icon(Icons.group, color: Colors.black)),
                Container(
                  width: MediaQuery.of(context).size.width - 135,
                  child: Text(
                    group.groupName,
                    style: TextStyle(
                      fontSize: 26,
                      letterSpacing: 1.5,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                ),
                Container(
                  width: 50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Members',
                        style: TextStyle(
                          fontSize: 10,
                          fontFamily: 'OpenSans',
                        ),
                      ),
                      Text(
                        '${group.numMembers}',
                        style: TextStyle(fontSize: 20, fontFamily: 'OpenSans'),
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
        height: MediaQuery.of(context).size.height - 250,
        child: Center(
            child: Text(
          "You are not currently in any groups!\n\nCreate one to get started",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24.0,
            color: Colors.white70,
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
              color: Colors.red,
            ),
          ),
          SizedBox(width: 16),
          Icon(Icons.delete, color: Colors.red),
        ],
      ),
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
