import 'package:app/models/GroupDetails.dart';
import 'package:app/models/MemberDetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/models/UserDetails.dart';
import 'package:contacts_service/contacts_service.dart';

import '../models/UserDetails.dart';

class DataBaseService {

  final String uid;
  final Firestore db = Firestore.instance;
  final String groupUID;

  DataBaseService({this.uid, this.groupUID});

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
  Future<void> updateUserData(String name, String email, String number) async {
    //List<String> groups = List();
    await db.collection('users').document(this.uid).setData({
      "name": name,
      "email": email,
      'Number' : number
      //"groups": groups,
    });
  }

  Future<void> createGroupData(String groupName, UserDetails user) async {

    CollectionReference groupsReference = db.collection("users").document(user.uid)
                                        .collection("groups");
    DocumentReference groups = groupsReference.document();
    String groupUID = groups.documentID;

    groups.setData({
        "groupName": groupName,
      });

    DocumentReference userReference = db.collection("users").document(user.uid)
                                        .collection("groups")
                                        .document(groupUID)
                                        .collection('members').document();
    userReference.setData({
      'Name' : user.name,
      'Number' : user.number,
    });
  }

  List<GroupDetails> _groupDetailsFromSnapshot(QuerySnapshot snap) {
    return snap.documents.map((doc) {
      return new GroupDetails(
        groupName: doc.data['groupName'] ?? 'No name exists',
        groupUID : doc.documentID,
      );
    }).toList();
  }

  Stream<List<GroupDetails>> get groups {
    return db.collection("users").document(this.uid).collection("groups").snapshots().map(_groupDetailsFromSnapshot);
  }

  List<MemberDetails> _memberDetailsFromSnapShot(QuerySnapshot snap) {
    return snap.documents.map((doc) {
      return new MemberDetails(
        name : doc.data['Name'] ?? '',
        number : doc.data['Number'] ?? '',
        email : doc.data['Email'] ?? '',
        memberID: doc.documentID
      );
    }).toList();
  }

  Stream<List<MemberDetails>> get members{
        return db.collection("users").document(this.uid).collection("groups")
              .document(this.groupUID)
              .collection('members')
              .snapshots().map(_memberDetailsFromSnapShot);
  }
}