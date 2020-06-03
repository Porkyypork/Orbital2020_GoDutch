import 'package:flutter/material.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[100],
      appBar: AppBar(
        title: Text('About Us'),
        elevation: 0,
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),

      body: Center(
        child: Text(
          """This project is authored by a group of two National University of Singpapore (NUS) students for Orbital2020""",
        ),
      ),
    );
  }
}