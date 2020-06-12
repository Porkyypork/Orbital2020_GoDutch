import 'package:app/constants/colour.dart';
import 'package:app/constants/loading.dart';
import 'package:app/models/UserDetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:app/services/database.dart';

class ContactsPage extends StatefulWidget {
  final String groupUID;

  ContactsPage({this.groupUID});

  @override
  _ContactsPageState createState() => _ContactsPageState(groupUID: groupUID);
}

class _ContactsPageState extends State<ContactsPage> {
  final String groupUID;
  Iterable<Contact> _contactsAll;
  final Firestore db = Firestore.instance;
  List<Contact> contactsFiltered = [];
  TextEditingController searchController = new TextEditingController();

  _ContactsPageState({this.groupUID});

  @override
  void initState() {
    getContacts();
    super.initState();
    searchController.addListener(() {
      filterContacts();
    });
  }

  Future<void> getContacts() async {
    final Iterable<Contact> contacts = await ContactsService.getContacts();
    setState(() => {
          _contactsAll = contacts,
        });
  }

  filterContacts() {
    List<Contact> _contacts = [];
    _contacts.addAll(_contactsAll);
    if (searchController.text.isNotEmpty) {
      _contacts.retainWhere((contact) {
        String searchTerm = searchController.text.toLowerCase();
        String contactName = contact.displayName.toLowerCase();
        return contactName.contains(searchTerm);
      });
      setState(() {
        contactsFiltered = _contacts;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserDetails>(context);
    bool isSearching = searchController.text.isNotEmpty;
    final DataBaseService dbService =
        new DataBaseService(uid: user.uid, groupUID: groupUID);

    return _contactsAll != null
        ? Scaffold(
            appBar: GradientAppBar(
              title: Text('Contacts'),
              gradient: appBarGradient,
              actions: <Widget>[
                // doneButton(),
              ],
            ),
            body: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Container(
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        labelText: 'Search',
                        border: new OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(1000)),
                        ),
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: isSearching
                          ? contactsFiltered.length
                          : _contactsAll.length ?? 0,
                      itemBuilder: (BuildContext context, int index) {
                        Contact contact = isSearching
                            ? contactsFiltered[index]
                            : _contactsAll.elementAt(index);
                        return Dismissible(
                          key: UniqueKey(),
                          background: _addBackground(),
                          onDismissed: (direction) {
                            dbService.addGroupMember(contact);
                            _addMessage(context, contact.displayName);
                          },
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 18),
                            leading: (contact.avatar != null &&
                                    contact.avatar.isNotEmpty)
                                ? CircleAvatar(
                                    backgroundImage:
                                        MemoryImage(contact.avatar),
                                  )
                                : CircleAvatar(
                                    child: Text(
                                      contact.initials(),
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    backgroundColor: Colors.teal[300],
                                  ),
                            title: Text(contact.displayName ?? ''),
                            subtitle:
                                Text(contact.phones.first.value.toString()),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ))
        : Loading();
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
        onPressed: () {
          // implement function
        });
  }

  void _addMessage(context, String contact) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("Added $contact"),
    ));
  }
}
