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

  // creates the user data in the database
  Future<void> updateUserData(String name, String email, String number) async {
    await db
        .collection('users')
        .document(this.uid)
        .setData({"name": name, "email": email, 'Number': number});
  }

  Future<GroupDetails> createGroupData(
      String groupName, UserDetails user) async {
    CollectionReference groupsReference =
        db.collection("users").document(user.uid).collection("groups");
    DocumentReference groups = groupsReference.document();
    String groupUID = groups.documentID;

    groups.setData({
      "groupName": groupName,
      "groupUID": groupUID,
      "groupAdmin": user.name,
      "numMembers": 1,
    });

    GroupDetails groupDetails = new GroupDetails(
      groupName: groupName,
      groupUID: groupUID,
      groupAdmin: user.name,
      numMembers: 1,
    );

    DocumentReference userReference = db
        .collection("users")
        .document(user.uid)
        .collection("groups")
        .document(groupUID)
        .collection('members')
        .document();
    userReference.setData({
      'Name': user.name,
      'Number': user.number,
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
        groupUID: doc.documentID,
        numMembers: doc.data['numMembers'],
      );
    }).toList();
  }

  void removeGroupMember(String memberID) async {
    await db
        .collection('users')
        .document(uid)
        .collection('groups')
        .document(groupUID)
        .collection('members')
        .document(memberID)
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
        'Debt': 0,
      });

      var groupDocRef = db
          .collection('users')
          .document(this.uid)
          .collection('groups')
          .document(groupUID);
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
    return db
        .collection("users")
        .document(this.uid)
        .collection("groups")
        .snapshots()
        .map(_groupDetailsFromSnapshot);
  }

  List<MemberDetails> _memberDetailsFromSnapShot(QuerySnapshot snap) {
    return snap.documents.map((doc) {
      return new MemberDetails(
        doc.data['Name'] ?? '',
        doc.data['Number'] ?? '',
        doc.data['Email'] ?? '',
        doc.documentID,
        doc.data['Debt'] ?? -1,
      );
    }).toList();
  }

  Stream<List<MemberDetails>> get members {
    return db
        .collection("users")
        .document(this.uid)
        .collection("groups")
        .document(this.groupUID)
        .collection('members')
        .snapshots()
        .map(_memberDetailsFromSnapShot);
  }

  List<BillDetails> _billDetailsFromSnapshot(QuerySnapshot snap) {
    return snap.documents.map((doc) {
      return new BillDetails(doc.data['Name'] ?? '', doc.documentID,
          doc.data['totalPrice'] ?? -1.0, doc.data['Date'].toDate());
    }).toList();
  }

  Stream<List<BillDetails>> get bill {
    return db
        .collection('users')
        .document(this.uid)
        .collection('groups')
        .document(this.groupUID)
        .collection('bills')
        .orderBy('Date', descending: true)
        .snapshots()
        .map(_billDetailsFromSnapshot);
  }

  Future<BillDetails> createBill(String billName) async {
    DocumentReference billReference = db
        .collection("users")
        .document(this.uid)
        .collection("groups")
        .document(this.groupUID)
        .collection('bills')
        .document();
    billReference.setData({
      'Name': billName,
      'billUID': billReference.documentID,
      'totalPrice': 0.0,
      'Date': DateTime.now(),
    });

    return new BillDetails(
        billName, billReference.documentID, 0.0, DateTime.now());
  }

  Future<void> removeBill(String billUID) async {
    await db
        .collection('users')
        .document(uid)
        .collection('groups')
        .document(groupUID)
        .collection('bills')
        .document(billUID)
        .delete();
  }

  List<ItemDetails> _itemDetailsFromSnapshot(QuerySnapshot snap) {
    return snap.documents.map((doc) {
      return new ItemDetails(
        name: doc['Name'] ?? '',
        itemUID: doc.documentID,
        totalPrice: doc['totalPrice'] ?? -1.0,
        sharingMembers: doc['sharedWith'] ?? [],
      );
    }).toList();
  }

  Stream<List<ItemDetails>> get item {
    return db
        .collection('users')
        .document(this.uid)
        .collection('groups')
        .document(this.groupUID)
        .collection('bills')
        .document(this.billUID)
        .collection('items')
        .snapshots()
        .map(_itemDetailsFromSnapshot);
  }

  Future<ItemDetails> createItem(
      String itemName, double itemPrice, List<MemberDetails> members) async {
    List<String> memberNames = [];
    for (MemberDetails member in members) {
      memberNames.add(member.name);
    }
    DocumentReference itemReference = db
        .collection("users")
        .document(this.uid)
        .collection("groups")
        .document(this.groupUID)
        .collection('bills')
        .document(this.billUID)
        .collection('items')
        .document();
    itemReference.setData({
      'Name': itemName,
      'itemUID': itemReference.documentID,
      'totalPrice': itemPrice,
      'sharedWith': memberNames,
    });

    var billsDocRef = db
        .collection('users')
        .document(this.uid)
        .collection('groups')
        .document(this.groupUID)
        .collection('bills')
        .document(this.billUID);

    double currentPrice =
        await billsDocRef.get().then((bill) => bill['totalPrice']);

    billsDocRef.updateData({'totalPrice': currentPrice + itemPrice});

    return new ItemDetails(
        name: itemName,
        itemUID: itemReference.documentID,
        totalPrice: itemPrice);
  }

  Future<ItemDetails> editItem(
      String itemName, double itemPrice, List<MemberDetails> members) async {
    List<String> memberNames = [];
    for (MemberDetails member in members) {
      memberNames.add(member.name);
    }
    DocumentReference itemReference = db
        .collection("users")
        .document(this.uid)
        .collection("groups")
        .document(this.groupUID)
        .collection('bills')
        .document(this.billUID)
        .collection('items')
        .document(this.itemUID);
    double prevPrice =
        await itemReference.get().then((item) => item['totalPrice']);
    itemReference.setData({
      'Name': itemName,
      'itemUID': itemReference.documentID,
      'totalPrice': itemPrice,
      'sharedWith': memberNames,
    });

    var billsDocRef = db
        .collection('users')
        .document(this.uid)
        .collection('groups')
        .document(this.groupUID)
        .collection('bills')
        .document(this.billUID);

    double currentPrice =
        await billsDocRef.get().then((bill) => bill['totalPrice']);

    billsDocRef
        .updateData({'totalPrice': currentPrice + itemPrice - prevPrice});

    return new ItemDetails(
        name: itemName,
        itemUID: itemReference.documentID,
        totalPrice: itemPrice);
  }

  //TODO: Not working for some reason
  void updateMember(MemberDetails member, double price) async {
    var memberDocRef = db
        .collection('users')
        .document(this.uid)
        .collection('groups')
        .document(this.groupUID)
        .collection('members')
        .document(member.memberID);

    double currentDebt =
        await memberDocRef.get().then((member) => member['Debt']);
    memberDocRef.updateData({'Debt': currentDebt + price});
  }

  void shareItemWith(MemberDetails member) async {
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
          .add({'Name': member.name, 'Number': member.number});
    } catch (e) {
      print(e.toString());
    }
  }

  List<ItemDetails> _itemDetailsFromSnapShot(QuerySnapshot snap) {
    return snap.documents.map((doc) {
      return new ItemDetails(
          name: doc.data['Name'],
          itemUID: doc.data['itemUID'],
          totalPrice: doc.data["totalPrice"]);
    }).toList();
  }

  Stream<List<ItemDetails>> get items {
    return db
        .collection("users")
        .document(this.uid)
        .collection("groups")
        .document(this.groupUID)
        .collection('bills')
        .document(this.billUID)
        .collection('items')
        .snapshots()
        .map(_itemDetailsFromSnapShot);
  }

  Future<void> deleteItem(String itemUID) async {
    await db
        .collection('users')
        .document(uid)
        .collection('groups')
        .document(groupUID)
        .collection('bills')
        .document(this.billUID)
        .collection('items')
        .document(itemUID)
        .delete();
  }
}
