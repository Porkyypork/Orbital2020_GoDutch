import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:app/screens/pages/ContactsPage.dart';

class AccessContacts extends StatelessWidget {
  final String groupUID;

  AccessContacts({this.groupUID});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () async {
        final PermissionStatus status = await _getPermission();
        if (status == PermissionStatus.granted) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ContactsPage(groupUID: groupUID)));
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    child: Container(
                      height: 185,
                      child: Padding(
                        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                        child: Column(
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 40),
                                child: Text(
                                  "Permission Error!",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0),
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    top: 10, left: 30, right: 20),
                                child: Text(
                                    'Please enable contacts access in Settings > Apps ' +
                                        '> \'GoDutch \' > \'Contacts\' > Allow',
                                    style: TextStyle(
                                        fontSize: 20, wordSpacing: 2))),
                          ],
                        ),
                      ),
                    ));
              });
        }
      },
      backgroundColor: Colors.orange[300],
      label: Text('Add members', style: TextStyle(color: Colors.black)),
      elevation: 0,
    );
  }

  //Check contacts permission
  Future<PermissionStatus> _getPermission() async {
    try {
      final PermissionStatus permission = await Permission.contacts.status;
      if (permission != PermissionStatus.granted &&
          permission != PermissionStatus.denied) {
        final Map<Permission, PermissionStatus> permissionStatus =
            await [Permission.contacts].request();
        return permissionStatus[Permission.contacts] ??
            PermissionStatus.undetermined;
      } else {
        return permission;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
