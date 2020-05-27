import 'package:app/models/GroupDetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/models/UserDetails.dart';

class DataBaseService {
  final String uid;
  final Firestore db = Firestore.instance;

  DataBaseService({this.uid});

  Future getUserGroups(String userUID) async {
    List<dynamic> groups;
    await db.collection("users").document(userUID).get().then((user) => {
      groups = user["groups"],
    });
    return groups;
  }

  // returns the current user details
  Future<UserDetails> getCurrentUserDetails(String userUID) async {
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



  // creates the user data in the database
  Future<void> updateUserData(String name, String email) async {
    //List<String> groups = List();
    await db.collection('users').document(this.uid).setData({
      "name": name,
      "email": email,
      //"groups": groups,
    });
  }

  Future<void> createGroupData(String groupName, String uid) async {
    List<String> groupMembers = List();
    await db.collection("users").document(uid)
      .collection("groups").document().setData({
        "groupName": groupName,
        "members": groupMembers,
      });
  }

  List<GroupDetails> _groupDetailsFromSnapshot(QuerySnapshot snap) {
    return snap.documents.map((doc) {
      return new GroupDetails(
        groupName: doc.data['groupName'] ?? 'No name exists',
        members: doc.data['members'] ?? ['no members'],
      );
    }).toList();
  }

  Stream<List<GroupDetails>> get groups {
    return db.collection("users").document(this.uid).collection("groups").snapshots().map(_groupDetailsFromSnapshot);
  }
}