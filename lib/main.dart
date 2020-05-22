// important notes :
// The top appbar, bottom appbar and floating button will be STATELESS, as they
// are always there as part of the interface, at least on the home page.
// However, the list of groups itself will be STATEFUL as it will have to be updated dynamically
// by the user. Need to determine if when going to other pages, such as personal profile page and
// expenditure page, will the currently stateless properties need to be converted to stateful. Determine
// another day upon reading up more on stateful widgets.
// at least the button is working rn just gotta make it go to a new page
// ----------------------------------------------------------------
// TO ADD in priority order:
// A dynamic list of groups on the main home page, where each group is of a profile picture, followed by group name.
// A page for when the user enters the group.
// Sign up page
// Login apge

import 'package:app/models/user.dart';
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
        },
        home: Wrapper(),
      ),
    );
  }
}
