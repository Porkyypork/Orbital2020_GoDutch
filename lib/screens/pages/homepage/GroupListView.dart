import 'package:app/constants/loading.dart';
import 'package:app/models/GroupDetails.dart';
import 'package:app/models/UserDetails.dart';
import 'package:app/screens/pages/group.dart';
import 'package:app/services/database.dart';
import 'package:flutter/material.dart';

class _GroupListViewState extends State<GroupListView> {

  UserDetails currentUser;
  _GroupListViewState({this.currentUser});

  @override
  Widget build(BuildContext context) {

    List<dynamic> _groupsUID = currentUser.groups;

    if(_groupsUID.length > 0) {
      return ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
        itemCount: _groupsUID.length,
        itemBuilder: (context, index) => FutureBuilder(
          future: _buildGroupTile(context, _groupsUID[index]),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) { // gotta figure out a way to send to loading page rather than each indiv list tile loading
              case ConnectionState.none:
                return Loading();
              case ConnectionState.active:
                return Loading();
              case ConnectionState.waiting:
                return Loading();
              case ConnectionState.done:
                return snapshot.data;
                break;
              default:
                return Text("default, it shouldnt reach here");
            }
          }),
        // next attribute if needed starts here
      );
    } else {
      return _buildNoGroupDisplay();
    }
  }

  Future<Widget> _buildGroupTile(BuildContext context, String groupUID) async {

    GroupDetails group = await DataBaseService().getGroupDetails(groupUID);

    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          setState(() {
            String groupName = group.groupName;
            //_removeGroup(index);
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
          "You are not currently in any groups\nLoaded user: ${currentUser.name}",
          // error is that it is passing the UserDetails.loading() user rather than the active user
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

  void _removeGroup(index) {
    setState(() {
      //_groups.removeAt(index);
    });
  }

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