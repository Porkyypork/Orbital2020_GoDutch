class MemberDetails {

  String _name;
  String _number;
  String _email;
  String _memberID;
  int _debt;

  MemberDetails(
    this._name, this._number, this._email, this._memberID, this._debt,
  );

  String get name => _name;

  String get number => _number;

  String get email => _email;

  String get memberID => _memberID;

  int get debt => _debt;
}