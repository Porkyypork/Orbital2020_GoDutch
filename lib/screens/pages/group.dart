import 'package:app/models/GroupDetails.dart';
import 'package:app/models/MemberDetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/UserDetails.dart';
import '../../services/AccessContacts.dart';
import '../../services/database.dart';

// Everyone else starts with a balance of 0, and as people pay, their value decreases, while others increase.
// i.e. for a group of 4 people and split evenly setting. Members are A, B, C, D.
// 1. A pays $10 for something. NEW STATE: [A = -7.5, B = +2.5, C = +2.5, D = +2.5]
// 2. B pays a back to get rid of their debt. NEW STATE: [A = -5, B = 0, C = +2.5, D = +2.5]
// 3. etc...

class _GroupState extends State<Group> {
  GroupDetails data;
  final Firestore db = Firestore.instance;

  _GroupState(this.data);

  @override
  Widget build(BuildContext context) {
    String groupName = data.groupName;
    String groupUID = data.groupUID;

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
        body: _buildGroupPageBody(),
        //endDrawer: _buildDrawerMenu(context),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // go to camera functions
          },
          child: Icon(Icons.camera_alt, color: Colors.white),
          backgroundColor: Colors.blueAccent,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Widget _buildGroupPageBody() {
    return ListView.builder(
      itemCount: data.members.length,
      itemBuilder: (context, index) =>
          _buildMemberTile(data.members[index], index),
    );
  }

  Widget _buildMemberTile(name, index) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        _removeGroupMember(index);
      },
      background: _deletionBackground(),
      child: Card(
        child: ListTile(
          leading: Icon(Icons.important_devices),
          title: Text(name),
          subtitle: Text('Owed amount goes here'),
          trailing: DropdownButton<Widget>(
            items: null,
            onChanged: null,
            icon: Icon(Icons.more_vert),
          ),
        ),
      ),
    );
  }

  void _removeGroupMember(index) async {
    final user = Provider.of<UserDetails>(context);
    List<dynamic> members = await db
        .collection('users')
        .document(user.uid)
        .collection('groups')
        .document(data.groupUID)
        .get()
        .then((group) => group['members']);

    // buffer time to update for database
    try {
      members.removeAt(index);
    } catch (e) {
      members.removeAt(index - 1);
    }

    await db
        .collection('users')
        .document(user.uid)
        .collection('groups')
        .document(data.groupUID)
        .updateData({'members': members});
  }

  Widget _deletionBackground() {
    return Container(
      alignment: AlignmentDirectional.centerEnd,
      padding: EdgeInsets.only(right: 15.0),
      color: Colors.red[600],
      child: Icon(Icons.delete, color: Colors.black),
    );
  }

  // Probably irrelevant now, check with weilin
  // Drawer _buildDrawerMenu(BuildContext context) {
  //   return Drawer(
  //     child: ListView(
  //       children: <Widget>[
  //         Container(
  //           color: Colors.white10,
  //           child: ListTile (
  //             title: Text (
  //               "Member List",
  //               style: TextStyle(fontSize: 20.0),
  //             ),
  //             trailing: Icon(Icons.group),
  //           ),
  //         ),
  //         Divider(),
  //         ListTile(
  //           title: Text("This is the dailou"),
  //           trailing: Icon(Icons.star),
  //         ),
  //         ListTile(
  //           title: Text("Member 1"),
  //           trailing: Icon(Icons.person),
  //         ),
  //         ListTile(
  //           title: Text("Member 2"),
  //           trailing: Icon(Icons.person),
  //         ),
  //         ListTile(
  //           title: Text("Member 3"),
  //           trailing: Icon(Icons.person),
  //         ),
  //         Divider(),
  //         ListTile(
  //           title: Text("Close"),
  //           trailing: Icon(Icons.cancel),
  //           onTap: () => Navigator.of(context).pop(),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}

class Group extends StatefulWidget {
  final GroupDetails data;
  Group({this.data});

  @override
  _GroupState createState() => _GroupState(data);
}
