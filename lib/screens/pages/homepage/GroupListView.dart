import 'package:app/models/GroupDetails.dart';
import 'package:app/models/UserDetails.dart';
import 'package:app/screens/pages/group.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class _GroupListViewState extends State<GroupListView> {

  UserDetails currentUser;
  _GroupListViewState({this.currentUser});

  @override
  Widget build(BuildContext context) {

    final groups = Provider.of<List<GroupDetails>>(context);

    if (groups.length > 0) { // if there are groups
      return ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
        itemCount:groups.length,
        itemBuilder: (context, index) {
          return _buildGroupTile(groups[index]);
        }
      );
    } else {
      return _buildNoGroupDisplay();
    }
  }

  Widget _buildGroupTile(GroupDetails group) {

    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          setState(() {
            String groupName = group.groupName;
            //_removeGroup(index); figure out later
            _deletionMessage(context, groupName);
          });
        } else {
          // do something else likely implementation of google vision
        }
      },
      background: _secondaryBackground(),
      secondaryBackground: _deletionBackground(),
      child: ListTile(
        leading: Icon(Icons.group,
            color:
                Colors.black), // replaced with their own personal photo later
        title: Text(
          group.groupName,
          style: TextStyle(
            fontSize: 18.0,
            letterSpacing: 1.5,
          ),
        ),

        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Group(data: group),
          ));
        },
      ),
    );
  }

  Widget _buildNoGroupDisplay() {
    return Container(
      child: Center(
        child: Text(
          "You are not currently in any groups",
          style: TextStyle(
            fontSize: 24.0,
          ),
        )
      )
    );
  }

  Widget _deletionBackground() {
    return Container(
      alignment: AlignmentDirectional.centerEnd,
      padding: EdgeInsets.only(right: 15.0),
      color: Colors.red[600],
      child: Icon(Icons.delete, color: Colors.black),
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

  //TODO: deletion method!
  // void _removeGroup(int index, String groupUID) async {
  //   final user = Provider.of<UserDetails>(context);
  //   List<dynamic> updatedGroups = await usersCollection
  //       .document(user.uid)
  //       .get()
  //       .then((user) => user['groups']);
  //   updatedGroups.removeAt(index);
  //   usersCollection.document(user.uid).updateData({'groups': updatedGroups});

  //   await groupsCollection.document(groupUID).delete();
  //   setState(() {
  //     _groups.removeAt(index);
  //   });
  // }

  void _deletionMessage(context, String groupName) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("You have left $groupName"),
    ));
  }
}

class GroupListView extends StatefulWidget {

  final UserDetails currentUser;
  GroupListView({this.currentUser});

  @override
  _GroupListViewState createState() => _GroupListViewState(currentUser: currentUser);
}