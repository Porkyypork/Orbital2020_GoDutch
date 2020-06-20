import 'package:app/constants/colour.dart';
import 'package:app/models/GroupDetails.dart';
import 'package:app/models/MemberDetails.dart';
import 'package:app/models/UserDetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/services/database.dart';

class ContactListView extends StatefulWidget {
  final GroupDetails groupdata;

  ContactListView({this.groupdata});

  @override
  _ContactListViewState createState() =>
      _ContactListViewState(groupdata: groupdata);
}

class _ContactListViewState extends State<ContactListView> {
  final GroupDetails groupdata;
  final Firestore db = Firestore.instance;

  _ContactListViewState({this.groupdata});

  @override
  Widget build(BuildContext context) {
    final members = Provider.of<List<MemberDetails>>(context);

    return ListView.builder(
      padding: EdgeInsets.all(10),
      itemCount: members.length,
      itemBuilder: (context, index) => _buildMemberTile(members[index]),
    );
  }

  Widget _buildMemberTile(MemberDetails member) {
    final user = Provider.of<UserDetails>(context);
    final DataBaseService dbService =
        DataBaseService(uid: user.uid, groupUID: groupdata.groupUID);

    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          dbService.removeGroupMember(member.memberID);
        }
      },
      background: _deletionBackground(member),
      child: GestureDetector(
        onTap: () {},
        child: Card(
          color: tileColour,
          child: Container(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
                child: Icon(Icons.important_devices, color: Colors.grey),
              ),
              Container(
                width: MediaQuery.of(context).size.width - 130,
                child: Column(
                  children: <Widget>[
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          member.name,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontFamily: 'Montserrat'),
                        )),
                    SizedBox(height: 2),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Amount owed: ${member.debt}',
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                              fontFamily: 'OpenSans'),
                        )),
                  ],
                ),
              ),
              IconButton(
                  icon: Icon(Icons.check, color: Colors.green[900]),
                  onPressed: () {
                    // member has settled
                  }),
            ],
          )),
        ),
      ),
    );
  }

  Widget _deletionBackground(MemberDetails member) {
    return Container(
      alignment: AlignmentDirectional.centerEnd,
      padding: EdgeInsets.only(right: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            'Removing ${member.name}',
            style: TextStyle(color: Colors.red),
          ),
          SizedBox(width: 16),
          Icon(Icons.delete, color: Colors.red),
        ],
      ),
    );
  }
}
