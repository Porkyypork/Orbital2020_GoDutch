import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/models/UserDetails.dart';


class DataBaseService {

  final String uid;
  DataBaseService({ this.uid });
    
  final Firestore databaseReference = Firestore.instance;

  Future<void> updateUserData(String name, String email) async {
    List<String> groups = List();
    await databaseReference.collection('users')
      .document(this.uid).setData({
        "name": name,
        "email": email,
        "groups": groups,
      });
  }

  Future<void> createGroupData(String groupName, String uid) async {
    List<String> members = List(); // this list of strings stores unique uids, so a separate class is not needed
    members.add(uid); // only need to know the uid of individual members, not all their details
    await databaseReference.collection('groups')
      .add(
        {
          "groupName" : groupName,
          "groupAdmin": uid,
          "members": members,
      });

    //TODO: Update the individual user's groups list by adding this one

  }

  Future<void> updateGroupDate() async {
    //TODO
  }

}