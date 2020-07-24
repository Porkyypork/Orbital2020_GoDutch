import 'package:app/constants/colour.dart';
import 'package:app/models/BillDetails.dart';
import 'package:app/models/itemDetails.dart';
import 'package:app/screens/pages/group_related/btm_nav_bar/bill_related/DebtsDisplay.dart';
import 'package:app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../constants/colour.dart';
import 'BillBreakdownListView.dart';
import 'DebtsDisplay.dart';

class BillBreakdown extends StatefulWidget {
  final BillDetails bill;
  final DataBaseService dbService;
  BillBreakdown({this.bill, this.dbService});
  @override
  _BillBreakdownState createState() =>
      _BillBreakdownState(bill: this.bill, dbService: this.dbService);
}

class _BillBreakdownState extends State<BillBreakdown> {
  PageController _pageController = PageController(
    initialPage: 0,
  );
  int _selectedIndex = 0;
  static int billsCount = 0;

  BillDetails bill;
  DataBaseService dbService;

  _BillBreakdownState({this.bill, this.dbService});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<ItemDetails>>.value(
      value: dbService.items,
      child: Scaffold(
        backgroundColor: tileColour,
        appBar: AppBar(
          backgroundColor: headerColour,
          title: Text('${bill.billName}'),
          elevation: 0,
          centerTitle: true,
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: (page) {
            setState(() {
              _selectedIndex = page;
            });
          },
          children: <Widget>[
            DebtsDisplay(dbService: dbService, bill: bill),
            BillBreakdownListView(bill : bill),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: headerColour,
          fixedColor: Color(0xFFFFFDD0), // cream
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.monetization_on), title: Text('Overview')),
            BottomNavigationBarItem(
                icon: Icon(Icons.list), title: Text('Items'))
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  } 

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(index,
          duration: Duration(milliseconds: 200), curve: Curves.easeIn);
    });
  }
}
