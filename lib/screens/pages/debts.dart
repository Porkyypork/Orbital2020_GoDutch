import 'package:flutter/material.dart';

//gives an overview across all of the users groups unsettled debts / repayments
class _DebtsState extends State<Debts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[100],
      appBar: AppBar(
        title: Text('this is the unsettled screen'),
        elevation: 0,
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),

      body: Text('this is the menu page')
    );
  }
}

class Debts extends StatefulWidget {
  @override
  _DebtsState createState() => _DebtsState();
}