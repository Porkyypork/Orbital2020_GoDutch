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

import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
  home: GoDutch(),
));

class GoDutch extends StatefulWidget {

  @override
  _GoDutchState createState() => _GoDutchState();
}

class _GoDutchState extends State<GoDutch> {

  int numGroups = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange[50],
      appBar: AppBar(
        title: Text('GoDutch todo list'),
        centerTitle: true,
        backgroundColor: Colors.teal[300],
        elevation: 0.0,
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(30.0),
            color: Colors.pink[50],
            child: Text(
              'List of groups',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
                color: Colors.black,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(30.0),
            color: Colors.pink[100],
            child: Text(
              'Group page',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
                color: Colors.black,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(30.0),
            color: Colors.pink[200],
            child: Text(
              'Login page',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
                color: Colors.black,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(30.0),
            color: Colors.pink[300],
            child: Text(
              'Signup page',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: 30.0),
          Center(
            child: Container(
              child: Text(
                '$numGroups',
                style: TextStyle(
                  fontSize: 36.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  color: Colors.black,
                ),
              ),
            ),
          )
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            numGroups++;
          });

          print('Change this to bring up the group creation page\n');
          print('Currently shows how many \"groups\" there are ==> number of times the button is pressed');
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.cyan[200],
      ),

      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(
          height: 50.0,
        ),
        color: Colors.teal[300],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}