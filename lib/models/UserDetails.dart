//might not be needed

class UserDetails {

  final String name;
  final String number;
  final String email;

  UserDetails({this.name, this.number, this.email});

  String get userName {
    return name;
  }

  String get userNumber {
    return number;
  }
}
