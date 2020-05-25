import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/models/UserContact.dart';


class DataBaseService {
  
  List<UserContact> groupMembers;
    
  final Firestore databaseReference = Firestore.instance;

  Future<void> addGroupMembers(String groupName, UserContact contact) async {
    return await databaseReference.collection(groupName)
                                  .document(contact.name)
                                  .setData({
                                    'name' : contact.name,
                                    'number' : contact.number
                                  });
  }

}