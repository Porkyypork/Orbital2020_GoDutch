import 'package:app/models/user.dart';
import 'package:app/screens/pages/ContactsPage.dart';
import 'package:app/screens/pages/aboutus.dart';
import 'package:app/screens/pages/debts.dart';
import 'package:app/screens/pages/group.dart';
import 'package:app/screens/pages/group_creation.dart';
import 'package:app/screens/pages/profile.dart';
import 'package:app/screens/wrapper.dart';
import 'package:app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/pages/home.dart';

void main() => runApp(GoDutch());

class GoDutch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
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
