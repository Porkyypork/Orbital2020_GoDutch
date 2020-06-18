import 'package:app/models/UserDetails.dart';
import 'package:app/screens/pages/ContactsPage.dart';
import 'package:app/screens/pages/group_related/group.dart';
import 'package:app/screens/pages/group_related/group_creation.dart';
import 'package:app/screens/pages/sideFunctions/aboutus.dart';
import 'package:app/screens/pages/sideFunctions/debts.dart';
import 'package:app/screens/pages/homepage/home.dart';
import 'package:app/screens/pages/sideFunctions/profile.dart';
import 'package:app/screens/wrapper.dart';
import 'package:app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(GoDutch());

class GoDutch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserDetails>.value(
      value: AuthService().user,
      child: MaterialApp(
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.blue[50],
        ),
        routes: {
          '/home': (context) => Home(),
          '/debts': (context) => Debts(),
          '/profile': (context) => Profile(),
          '/group_creation': (context) => GroupCreation(),
          '/group': (context) => Group(),
          '/about': (context) => AboutUs(),
          '/contacts': (context) => ContactsPage(),
        },
        home: Wrapper(),
      ),
    );
  }
}
