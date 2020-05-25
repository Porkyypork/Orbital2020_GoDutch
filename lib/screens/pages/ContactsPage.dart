import 'package:app/constants/loading.dart';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';

class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {

  Iterable<Contact> _contacts;

  Future<void> getContacts() async {
    final Iterable<Contact> contacts = await ContactsService.getContacts();
    setState(() => {
      _contacts = contacts,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar : AppBar(
        title: Text('Contacts')
      ),
      body : _contacts !=null ? 
      ListView.builder(
        itemCount: _contacts?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
        Contact contact = _contacts?.elementAt(index);
        return ListTile(
          contentPadding:
          const EdgeInsets.symmetric(vertical: 2, horizontal: 18),
          leading: (contact.avatar != null && contact.avatar.isNotEmpty)
          ? CircleAvatar(
            backgroundImage: MemoryImage(contact.avatar),
          )
          : CircleAvatar(
            child: Text(contact.initials()),
            backgroundColor: Theme.of(context).accentColor,
            ),
          title: Text(contact.displayName ?? ''),
          subtitle: Text(contact.phones.elementAt(0).toString() ?? ""),
          trailing: IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // add to groups (database)
            },
          ),
                  //This can be further expanded to showing contacts detail
                  // onPressed().
                );
              },
            )
          : Center(child: Loading()),
    );
  }
}