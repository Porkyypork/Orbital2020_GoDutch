import 'package:flutter/material.dart';

import '../../../constants/colour.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyColour,
      appBar: AppBar(
        title: Text('About Us'),
        elevation: 0,
        backgroundColor: headerColour,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height/5),
            Icon(Icons.info, color: Colors.white, size: 80),
            SizedBox(height: 50),
            Container(
              padding: EdgeInsets.only(left: 15, right: 10),
              child: Text(
                """This mobile application is built using flutter and Dart. It is a project that is authored by Lim Wei Lin and Darren Chee as part of the National University of Singapore\'s Orbital project.""",
                style: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(15, 20, 10, 0),
              child: Text(
                'Github repo: https://github.com/Porkyypork/Orbital2020_GoDutch',
                style: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
