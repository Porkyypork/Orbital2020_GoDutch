import 'package:app/models/GroupDetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/models/UserDetails.dart';

class DataBaseService {
  final String uid;
  final Firestore db = Firestore.instance;

  DataBaseService({this.uid});

  // returns the current user details
  Future<UserDetails> getCurrentUser(String userUID) async {
    UserDetails currentUser;
    await db.collection("users").document(userUID).get().then((user) => {
          currentUser = new UserDetails(
            name: user["name"],
            uid : userUID,
            number: "818181",
            email: user["email"],
            groups: user["groups"],
          ),
        });
    return currentUser;
  }

  // returns the group details for a given uid
  Future<GroupDetails> getGroupDetails(String groupUID) async {

    GroupDetails currentGroup;
    try{
      await db.collection("groups").document(groupUID).get().then((group) => {
            currentGroup = new GroupDetails(
              uid: groupUID,
              uidGroupAdmin: group["groupAdmin"],
              groupName: group["groupName"],
              members: group["members"],
            ),
          });
    } catch (e) {
      print(e.toString);
    }
    return currentGroup;
  }

  // creates the user data in the database
  Future<void> updateUserData(String name, String email) async {
    List<String> groups = List();
    await db.collection('users').document(this.uid).setData({
      "name": name,
      "email": email,
      "groups": groups,
    });
  }

  // creates the group datas in the database
  Future<void> createGroupData(String groupName, String uid) async {
    List<dynamic> members = List();
    members.add(uid);
    DocumentReference _docRef = await db.collection('groups').add({
      "groupName": groupName,
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
}