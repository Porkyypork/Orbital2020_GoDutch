import 'package:flutter/material.dart';


class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('this is the profile page'),
        elevation: 0,
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),

      body: Text('this is the profile page')
    );
  }
}

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}
