import 'package:app/models/GroupDetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/models/UserDetails.dart';

class DataBaseService {

  final String uid;
  DataBaseService({ this.uid });
    
  final Firestore db = Firestore.instance;

  // returns the current user details
  Future<UserDetails> getCurrentUser(String uid) async {
    UserDetails currentUser;
    await db.collection("users").document(uid).get().then((value) => {
      currentUser = new UserDetails(
        name: value["name"],
        number: "818181",
        email: value["email"],
        groups: value["groups"],
      ),
    });
    return currentUser;
  }

  Future<GroupDetails> getGroupDetails() async {

  }

  // creates the user data in the database
  Future<void> updateUserData(String name, String email) async {
    List<String> groups = List();
    await db.collection('users')
      .document(this.uid).setData({
        "name": name,
        "email": email,
        "groups": groups,
      });
  }

  // creates the group datas in the database
  Future<void> createGroupData(String groupName, String uid) async {
    List<String> members = List();
    members.add(uid);
    DocumentReference _docRef = await db.collection('groups')
      .add(
        {
          "groupName" : groupName,
          "groupAdmin": uid,
          "members": members,
      });
    String groupUID = _docRef.documentID;
    List<String> newGroups = List();
    newGroups.add(groupUID);
    await db.collection("users").document(uid).updateData({
      "groups": FieldValue.arrayUnion(newGroups),
    });
  }

  // updates 
  Future<void> updateGroupData() async {
    //TODO
  }

}