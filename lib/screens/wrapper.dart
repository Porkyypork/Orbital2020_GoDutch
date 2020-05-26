import 'package:app/models/user.dart';
import 'package:app/screens/pages/homepage/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'authenticate/authenticate.dart';

// controls which page is shown to users depending on authentication state

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