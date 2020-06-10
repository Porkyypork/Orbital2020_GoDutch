import 'package:app/models/GroupDetails.dart';
import 'package:app/models/MemberDetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/models/UserDetails.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:app/models/BillDetails.dart';

import '../models/itemDetails.dart';


class DataBaseService {

  final String uid;
  final Firestore db = Firestore.instance;
  final String groupUID;
  final String billUID;
  final String itemUID;

  DataBaseService({this.uid, this.groupUID, this.billUID, this.itemUID});

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
        doc.data['Name'] ?? '',
        doc.data['Number'] ?? '',
        doc.data['Email'] ?? '',
        doc.documentID
      );
    }).toList();
  }

  Stream<List<MemberDetails>> get members{
    return db.collection("users").document(this.uid).collection("groups")
            .document(this.groupUID)
            .collection('members')
            .snapshots().map(_memberDetailsFromSnapShot);
  }

  Future<BillDetails> createBill(String billName) async {

    DocumentReference billReference = db.collection("users").document(this.uid)
                                          .collection("groups")
                                          .document(this.groupUID)
                                          .collection('bills')
                                          .document();
    billReference.setData({
      'Name' : billName,
      'billUID' : billReference.documentID,
      'totalPrice' : 0.0,
      'Date' : DateTime.now(),
    });

    return new BillDetails(billName, billReference.documentID);
  }

  Future<ItemDetails> createItem(String itemName, itemPrice) async {

    DocumentReference itemReference = db.collection("users").document(this.uid)
                                          .collection("groups")
                                          .document(this.groupUID)
                                          .collection('bills')
                                          .document(this.billUID)
                                          .collection('items')
                                          .document();
    itemReference.setData({
      'Name' : itemName,
      'itemUID' : itemReference.documentID,
      'totalPrice' : itemPrice,
    });
    
    return new ItemDetails(
      name : itemName,
      itemUID : itemReference.documentID,
      totalPrice : itemPrice
    );
  }

  void shareItemWith(Contact contact) async {
     try {
      await db
          .collection('users')
          .document(this.uid)
          .collection('groups')
          .document(groupUID)
          .collection('bills')
          .document(billUID)
          .collection('items')
          .document(itemUID)
          .collection('sharingList')
          .add({
        'Name': contact.displayName,
        'Number': contact.phones.first.value.toString(),
      });
    } catch (e) {
      print(e.toString());
    }
  }
}