import 'package:cloud_firestore/cloud_firestore.dart';


class DataBaseService {
  
  final String uid;

  DataBaseService({ this.uid });
  
  //collection reference 
  
  final CollectionReference userGroups = Firestore.instance.collection('Groups');

  Future updateGroups(String name, int number) async {
    return await userGroups.document(uid).setData({
      'name' : name,
      'number' : number
    });
  } 

  // get data stream
  Stream<QuerySnapshot> get groups {
    return userGroups.snapshots();
  }

}