import 'package:app/constants/colour.dart';
import 'package:flutter/material.dart';
//TODO
class MemberDebtBreakdown extends StatefulWidget {
  @override
  _MemberDebtBreakdownState createState() => _MemberDebtBreakdownState();
}

class _MemberDebtBreakdownState extends State<MemberDebtBreakdown> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bodyColour,
      appBar: AppBar(
        backgroundColor: headerColour,
        title: Text('Member breakdown'),
      ),
      body: Text('owed bills here', style: TextStyle(color: Colors.white)),
    );
  }
}
