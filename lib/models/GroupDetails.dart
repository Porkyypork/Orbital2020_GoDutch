import 'package:app/models/UserDetails.dart';

class GroupDetails {

  String uid;
  String groupName;
  List<UserDetails> members = new List();

  GroupDetails({this.groupName});
}