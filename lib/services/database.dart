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

  Future<GroupDetails> createGroupData(String groupName, UserDetails user) async {

    CollectionReference groupsReference = db.collection("users").document(user.uid)
                                        .collection("groups");
    DocumentReference groups = groupsReference.document();
    String groupUID = groups.documentID;

    groups.setData({
        "groupName": groupName,
        "groupUID": groupUID,
        "numMembers": 1,
      });

    GroupDetails groupDetails = new GroupDetails(
      groupName: groupName,
      groupUID: groupUID,
      numMembers: 1,
    );

    DocumentReference userReference = db.collection("users").document(user.uid)
                                        .collection("groups")
                                        .document(groupUID)
                                        .collection('members').document();
    userReference.setData({
      'Name' : user.name,
      'Number' : user.number,
    });

    return groupDetails;
  }

  void removeGroup() {

    CollectionReference groupsReference =
        db.collection('users').document(this.uid).collection('groups');
    groupsReference.document(groupUID).delete();
  }


  List<GroupDetails> _groupDetailsFromSnapshot(QuerySnapshot snap) {
    return snap.documents.map((doc) {
      return new GroupDetails(
        groupName: doc.data['groupName'] ?? 'No name exists',
        groupUID : doc.documentID,
        numMembers: doc.data['numMembers'],
      );
    }).toList();
  }

  void removeGroupMember(memberID) async {

    await db.collection('users').document(uid)
            .collection('groups').document(groupUID)
            .collection('members').document(memberID)
            .delete();
  }

  void addGroupMember(Contact contact) async {

    try {
      await db
          .collection('users')
          .document(this.uid)
          .collection('groups')
          .document(groupUID)
          .collection('members')
          .add({
        'Name': contact.displayName,
        'Number': contact.phones.first.value.toString(),
      });

      var groupDocRef = db.collection('users').document(this.uid).collection('groups').document(groupUID);
      int newNumMembers = await groupDocRef.get().then((group) {
        return group['numMembers'];
      });
      
      groupDocRef.updateData({
        'numMembers': newNumMembers++,
      });
    } catch (e) {
      print(e.toString());
    }
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