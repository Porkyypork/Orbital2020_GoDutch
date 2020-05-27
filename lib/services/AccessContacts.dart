import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:app/screens/pages/ContactsPage.dart';


class AccessContacts extends StatelessWidget {

  final String groupUID;

  AccessContacts({this.groupUID});

  @override
  Widget build(BuildContext context) {
    return IconButton(                                                                                  
      onPressed: () async {
        final PermissionStatus status = await _getPermission();
        if (status == PermissionStatus.granted) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ContactsPage(groupUID: groupUID)));
        } else {
          AlertDialog(
            title : Text('Permission Error!'),
            content :  Text('Please enable contacts access in Settings > Privacy ' +
                            '> Permission manager > Contacts > \'GoDutch \' > Allow'),
            actions: <Widget>[
              FlatButton (
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
      },
      icon: Icon(Icons.add),
    );
  }

  //Check contacts permission
  Future<PermissionStatus> _getPermission() async {
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
  }
}
