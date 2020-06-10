class MemberDetails {

  String _name;
  String _number;
  String _email;
  String _memberID;

  MemberDetails(
    this._name, this._number, this._email, this._memberID, 
  );

  String get name => _name;

  String get number => _number;

  String get email => _email;

  String get memberID => _memberID;
}