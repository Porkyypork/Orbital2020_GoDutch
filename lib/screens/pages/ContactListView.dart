import 'package:app/models/MemberDetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/GroupDetails.dart';
import '../../models/UserDetails.dart';
import 'package:app/services/database.dart';

class ContactListView extends StatefulWidget {

  final GroupDetails groupdata;

  ContactListView({this.groupdata});

  @override
  _ContactListViewState createState() => _ContactListViewState(groupdata : groupdata);
}

class _ContactListViewState extends State<ContactListView> {

  final GroupDetails groupdata;
  final Firestore db = Firestore.instance;
 
  _ContactListViewState({this.groupdata});
  
  @override
  Widget build(BuildContext context) {
    
    final members = Provider.of<List<MemberDetails>>(context);
    
    
    return ListView.builder(
      itemCount: members.length,
      itemBuilder: (context, index) =>
          _buildMemberTile(members[index].name, members[index].memberID),
    );
  }

  Widget _buildMemberTile(name, memberID) {

    final user = Provider.of<UserDetails>(context);
    final DataBaseService dbService =  DataBaseService(uid: user.uid, groupUID :groupdata.groupUID);

    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        dbService.removeGroupMember(memberID);
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

  Widget _deletionBackground() {
    return Container(
      alignment: AlignmentDirectional.centerEnd,
      padding: EdgeInsets.only(right: 15.0),
      color: Colors.red[600],
      child: Icon(Icons.delete, color: Colors.black),
    );
  }

}