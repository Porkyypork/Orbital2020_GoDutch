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
          AlertDialog(
            title: Text('Permission Error!'),
            content: Text(
                'Please enable contacts access in Settings > Privacy ' +
                    '> Permission manager > Contacts > \'GoDutch \' > Allow'),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
      },
      backgroundColor: Colors.orange[300],
      label: Text('Add members', style: TextStyle(color: Colors.black)),
      elevation: 0,
      // backgroundColor: Colors.orange[500],
      // child : Container(
      //   height: 70,
      //   width: 70,
      //   decoration: BoxDecoration(
      //     border: Border.all (
      //       color: Colors.teal[500],
      //       width: 5
      //     ),
      //     shape : BoxShape.circle,
      //     color : Color(0xFF48D1CC), // CHANGE HERE
      //   ),
      //   child : Icon(Icons.add, size :30, color: Colors.black,),
      // ),
      //  elevation: 0,
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
