import 'package:cloud_firestore/cloud_firestore.dart';


class DataBaseService {
  
  final String uid;

  DataBaseService({ this.uid });
  
  //collection reference 
  final CollectionReference userContacts = Firestore.instance.collection('Contacts');
  final CollectionReference userGroups = Firestore.instance.collection('Groups');

  Future updateGroups(String name, int number) async {
    return await userContacts.document(uid).setData({
      'name' : name,
      'number' : number
    });
  }


}