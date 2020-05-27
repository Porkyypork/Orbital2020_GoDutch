class UserDetails {

  String name;
  String number;
  String email;
  String uid;
  List<dynamic> groups;
  
  UserDetails.loadingUser() {
    this.name = "USER IS LOADING";
    this.uid = "";
    this.number = "";
    this.email = "";
    this.groups = [];
  }

  UserDetails({this.name, this.uid, this.number, this.email, this.groups});

  String get userName {
    return name;
  }

  String get userNumber {
    return number;
  }


  String get userEmail {
    return email;
  }

  List<String> get userGroups {
    return this.groups;
  }
}
