import 'package:app/models/GroupDetails.dart';
import 'package:app/models/MemberDetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/models/UserDetails.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:app/models/BillDetails.dart';
import 'package:app/models/OwedBills.dart';

import '../models/itemDetails.dart';

class DataBaseService {
  final String uid;
  final Firestore db = Firestore.instance;
  final String groupUID;
  final String billUID;
  final String owedBillUID;
  final String itemUID;

  DataBaseService(
      {this.uid, this.groupUID, this.owedBillUID, this.billUID, this.itemUID});

  // creates the user data in the database
  Future<void> updateUserData(String name, String email, String number) async {
    await db
        .collection('users')
        .document(this.uid)
        .setData({"name": name, "email": email, 'Number': number});
  }

  Future<UserDetails> get user async {
    await Future.delayed(Duration(seconds: 1));
    print(uid);
    UserDetails user =
        await db.collection('users').document(uid).get().then((snap) {
      return UserDetails(
          email: snap.data['email'],
          name: snap.data['name'],
          number: snap.data['Number'],
          uid: snap.documentID,
          groups: []);
    });
    print(user.name);
    return user;
  }

  Future<GroupDetails> createGroupData(
      String groupName, UserDetails user) async {
    CollectionReference groupsReference =
        db.collection("users").document(user.uid).collection("groups");
    DocumentReference groups = groupsReference.document();
    String groupUID = groups.documentID;

    List<String> members = [];
    members.add(user.name);

    groups.setData({
      "groupName": groupName,
      "groupUID": groupUID,
      "groupAdmin": user.name,
      "numMembers": 1,
      "members": members,
    });

    GroupDetails groupDetails = new GroupDetails(
      groupName: groupName,
      groupUID: groupUID,
      groupAdmin: user.name,
      numMembers: 1,
      members: members,
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
          members: doc.data['members']);
    }).toList();
  }

  void removeGroupMember(MemberDetails member) async {
    await db
        .collection('users')
        .document(uid)
        .collection('groups')
        .document(groupUID)
        .collection('members')
        .document(member.memberID)
        .delete();

    var groupDocRef = db
        .collection('users')
        .document(this.uid)
        .collection('groups')
        .document(groupUID);

    int newNumMembers = await groupDocRef.get().then((group) {
          return group['numMembers'];
        }) -
        1;
    groupDocRef.updateData({
      'numMembers': newNumMembers,
    });
    List<dynamic> members = await groupDocRef.get().then((group) {
      return group['members'];
    });

    members.remove(member.name);

    groupDocRef.updateData({
      'members': members,
    });
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
        'Number':
            contact.phones.isEmpty ? "" : contact.phones.first.value.toString(),
      });

      var groupDocRef = db
          .collection('users')
          .document(this.uid)
          .collection('groups')
          .document(groupUID);
      int newNumMembers = await groupDocRef.get().then((group) {
        return group['numMembers'] + 1;
      });

      groupDocRef.updateData({
        'numMembers': newNumMembers,
      });

      List<dynamic> members = await groupDocRef.get().then((group) {
        return group['members'];
      });
      for (String member in members) {
        print(member);
      }
      members.add(contact.displayName);

      groupDocRef.updateData({
        'members': members,
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
        doc.data['Debt'] ?? -1, //here
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
      return new BillDetails(
          doc.data['Name'] ?? '',
          doc.documentID,
          doc.data['owedBillUID'],
          doc.data['totalPrice'] ?? -1.0,
          doc.data['Date'].toDate(),
          doc.data['extraCharges']);
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

  Future<BillDetails> createBill(
      String billName, List<MemberDetails> members, int extraCharges) async {
    DocumentReference billReference = db
        .collection("users")
        .document(this.uid)
        .collection("groups")
        .document(this.groupUID)
        .collection('bills')
        .document();

    String billUID = billReference.documentID;
    //create a new collection in each member to store their owed bills
    String owedBillUID = db
        .collection("users")
        .document(this.uid)
        .collection("groups")
        .document(this.groupUID)
        .collection('members')
        .document(members.elementAt(0).memberID)
        .collection('owedBills')
        .document()
        .documentID;

    for (MemberDetails member in members) {
      DocumentReference owedBillRef = db
          .collection("users")
          .document(this.uid)
          .collection("groups")
          .document(this.groupUID)
          .collection('members')
          .document(member.memberID)
          .collection('owedBills')
          .document(owedBillUID);

      owedBillRef.setData({
        'billName': billName,
        'Name': member.name,
        'totalPrice': 0.00,
        'totalOwed': 0.00,
      });
    }
    billReference.setData({
      'Name': billName,
      'billUID': billUID,
      'owedBillUID': owedBillUID,
      'totalPrice': 0.0,
      'Date': DateTime.now(),
      'extraCharges': extraCharges
    });

    return new BillDetails(
        billName, billUID, owedBillUID, 0.0, DateTime.now(), extraCharges);
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

  Future<ItemDetails> createItem(
      String itemName, double itemPrice, List<MemberDetails> members) async {
    int numMembers = 0;
    for (MemberDetails member in members) {
      numMembers = numMembers + 1;
    }
    // print(numMembers); THIS IS WORKING
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
      'numSharing': numMembers,
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

    double totalPrice = currentPrice + itemPrice;

    billsDocRef.updateData({
      'totalPrice': totalPrice,
    });

    for (MemberDetails member in members) {
      DocumentReference memberDocRef = db
          .collection('users')
          .document(this.uid)
          .collection('groups')
          .document(this.groupUID)
          .collection('members')
          .document(member.memberID)
          .collection('owedBills')
          .document(this.owedBillUID);

      double currentDebt =
          await memberDocRef.get().then((bill) => bill['totalOwed']);
      memberDocRef.updateData({
        'totalOwed': currentDebt + (itemPrice / members.length),
        'totalPrice': totalPrice
      });
    }

    return new ItemDetails(
        name: itemName,
        itemUID: itemReference.documentID,
        totalPrice: itemPrice,
        selectedMembers: members);
  }

  void shareItemWith(MemberDetails member) async {
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
      'Name': member.name,
      'Number': member.number,
      "memberUID": member.memberID
    });
  }

  List<ItemDetails> _itemDetailsFromSnapShot(QuerySnapshot snap) {
    return snap.documents.map((doc) {
      return new ItemDetails(
          name: doc.data['Name'],
          itemUID: doc.data['itemUID'],
          totalPrice: doc.data['totalPrice']);
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

  void deleteItem(String itemUID, double itemPrice, int numSharing) async {
    List<String> sharingUID = [];
    DocumentReference billRef = db
        .collection('users')
        .document(uid)
        .collection('groups')
        .document(groupUID)
        .collection('bills')
        .document(this.billUID);

    CollectionReference memRef = db
        .collection('users')
        .document(uid)
        .collection('groups')
        .document(groupUID)
        .collection('members');

    //delete item
    await billRef.collection('items').document(itemUID).delete();

    //updating total Price
    double currentPrice =
        await billRef.get().then((bill) => bill['totalPrice']);
    billRef.updateData({'totalPrice': currentPrice - itemPrice});

    String owedBillUID =
        await billRef.get().then((bill) => bill['owedBillUID']);

    // updating individual owedBill
    QuerySnapshot sharingSnap = await billRef
        .collection('items')
        .document(itemUID)
        .collection('sharingList')
        .getDocuments();
    List<DocumentSnapshot> sharingDoc = sharingSnap.documents;
    for (DocumentSnapshot doc in sharingDoc) {
      sharingUID.add(doc.data['memberUID']);
    }

    String memberUID = sharingUID.elementAt(0);

    double currentTotal = await memRef
        .document(memberUID)
        .collection('owedBills')
        .document(owedBillUID)
        .get()
        .then((bill) => bill['totalPrice']);

    for (String uid in sharingUID) {
      double currentOwed = await memRef
          .document(uid)
          .collection('owedBills')
          .document(owedBillUID)
          .get()
          .then((bill) => bill['totalOwed']);

      memRef
          .document(uid)
          .collection('owedBills')
          .document(owedBillUID)
          .updateData({
        "totalPrice": currentTotal - itemPrice,
        "totalOwed": currentOwed - (itemPrice / numSharing),
      });
    }
  }

  Future<List<OwedBills>> getDebt(List<MemberDetails> members) async {
    List<OwedBills> debts = [];
    for (MemberDetails member in members) {
      OwedBills debt;
      DocumentSnapshot doc = await db
          .collection('users')
          .document(uid)
          .collection('groups')
          .document(groupUID)
          .collection('members')
          .document(member.memberID)
          .collection('owedBills')
          .document(owedBillUID)
          .get();
      debt = OwedBills.fromSnapshot(doc);
      if (debt.name != null) {
        debts.add(debt);
      }
    }
    return debts;
  }
}
