import 'package:app/models/user.dart';
import 'package:app/screens/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'authenticate/authenticate.dart';

class Wrapper extends StatelessWidget {
  
  /* return home page if the user is signed in else return login page
     first page the user will see after launching the app*/
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if (user == null) {
      return Authenticate(); 
    }
    return Home();
  }
}