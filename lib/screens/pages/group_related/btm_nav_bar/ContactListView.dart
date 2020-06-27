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
    final user = Provider.of<UserDetails>(context);

    return (members.length == null)
        ? Container()
        : SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _buildAdminTile(user),
                Container(
                  height: MediaQuery.of(context).size.height - 305,
                  child: ListView.builder(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                    itemCount: members.length,
                    itemBuilder: (context, index) =>
                        members[index].name != user.name
                            ? _buildMemberTile(members[index])
                            : ListTile(),
                  ),
                ),
              ],
            ),
          );
  }

  Widget _buildAdminTile(UserDetails user) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Column(
        children: <Widget>[
          Card(
            color: tileColour,
            child: Container(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
                  child: Icon(Icons.star, color: Colors.grey),
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 130,
                  child: Column(
                    children: <Widget>[
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            user.name,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontFamily: 'Montserrat'),
                          )),
                    ],
                  ),
                ),
              ],
            )),
          ),
          Divider(color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildMemberTile(MemberDetails member) {
    final user = Provider.of<UserDetails>(context);
    final DataBaseService dbService =
        DataBaseService(uid: user.uid, groupUID: groupdata.groupUID);

    return GestureDetector(
      onTap: () {},
      child: Card(
        color: tileColour,
        child: Container(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
              child: Icon(Icons.person, color: Colors.grey),
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
                ],
              ),
            ),
            IconButton(
                icon: Icon(Icons.clear, color: Colors.red[900]),
                onPressed: () {
                  dbService.removeGroupMember(member.memberID);
                })
          ],
        )),
      ),
    );
  }
}
