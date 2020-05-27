import 'package:app/constants/loading.dart';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';

class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  
  Iterable<Contact> _contacts;

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
    return Scaffold(
      appBar: AppBar(title: Text('Contacts')),
      body: _contacts != null
          ? ListView.builder(
              itemCount: _contacts?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                Contact contact = _contacts?.elementAt(index);
                return Dismissible(
                  key: UniqueKey(),
                  background: _addBackground(),
                  onDismissed: (direction) {
                    //add to groups
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

  void _addMessage(context, String contact) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("Added $contact"),
    ));
  }
}
