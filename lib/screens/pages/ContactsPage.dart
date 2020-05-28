import 'package:app/constants/loading.dart';
import 'package:app/models/UserDetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:provider/provider.dart';

class ContactsPage extends StatefulWidget {
  
  final String groupUID;

  ContactsPage({this.groupUID});

  @override
  _ContactsPageState createState() => _ContactsPageState(groupUID: groupUID);
}

class _ContactsPageState extends State<ContactsPage> {

  final String groupUID;
  Iterable<Contact> _contacts;
  final Firestore db = Firestore.instance;
  

  _ContactsPageState({this.groupUID});

  void initState() {
    getContacts();
    super.initState();
  }

  Future<void> getContacts() async {
    final Iterable<Contact> contacts = await ContactsService.getContacts();
    setState(() => {
          _contacts = contacts,
        });
  }

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserDetails>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Contacts'),
        actions: <Widget>[
          // doneButton(),
        ],
      ),
      
      body: _contacts != null
          ? ListView.builder(
              itemCount: _contacts?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                Contact contact = _contacts?.elementAt(index);
                return Dismissible(
                  key: UniqueKey(),
                  background: _addBackground(),
                  onDismissed: (direction) {
                    addGroupMember(contact, groupUID, user.uid);
                    _addMessage(context, contact.displayName);
                  },
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 18),
                    leading:
                        (contact.avatar != null && contact.avatar.isNotEmpty)
                            ? CircleAvatar(
                                backgroundImage: MemoryImage(contact.avatar),
                              )
                            : CircleAvatar(
                                child: Text(contact.initials()),
                                backgroundColor: Theme.of(context).accentColor,
                              ),
                    title: Text(contact.displayName ?? ''),
                    subtitle: Text(contact.phones.first.value.toString()),
                  ),
                );
              },
            )
          : Center(child: Loading()),
    );
  }

  Widget _addBackground() {
    return Container(
      alignment: AlignmentDirectional.centerEnd,
      padding: EdgeInsets.only(right: 15.0),
      color: Colors.green[600],
      child: Icon(Icons.add, color: Colors.black),
    );
  }

  //lead to calculation page
  Widget doneButton() {
    return FlatButton(
      child: Text('Done'),
      onPressed : () {
        // implement function
      }
    );
  }

  void _addMessage(context, String contact) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("Added $contact"),
    ));
  }

  void addGroupMember(Contact contact, String groupUID, String userUID) async {
    print(userUID + " " + groupUID + " " + contact.displayName);
    try{
     await db.collection('users')
      .document(userUID).collection('groups')
      .document(groupUID)
      .collection('members')
      .add({
        'Name' : contact.displayName,
        'Number' : contact.phones.first.value.toString(),
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
