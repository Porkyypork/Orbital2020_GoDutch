import 'package:app/models/itemDetails.dart';
import 'package:app/screens/pages/Items/itemsListView.dart';
import 'package:flutter/material.dart';
import 'package:app/constants/colour.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:app/screens/pages/Items/ItemCreation.dart';
import 'package:app/services/database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:app/screens/pages/group_related/btm_nav_bar/bill_related/DebtsDisplay.dart';

import 'PhotoPreviewPage.dart';

class ItemPage extends StatefulWidget {
  final String billName;
  final DataBaseService dbService;

  ItemPage({this.dbService, this.billName});

  @override
  _ItemPageState createState() =>
      _ItemPageState(dbService: dbService, billName: billName);
}

class _ItemPageState extends State<ItemPage> {
  final DataBaseService dbService;
  final String billName;

  _ItemPageState({this.dbService, this.billName});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<ItemDetails>>.value(
      value: dbService.items,
      child: Scaffold(
        backgroundColor: Colors.blue[50],
        appBar: GradientAppBar(
          gradient: appBarGradient,
          title: Text(billName),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height - 210,
              child: ItemListView(dbService: dbService),
            ),
            RaisedButton(
              padding: EdgeInsets.fromLTRB(30, 15, 30, 15),
              onPressed: () {
               Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DebtsDisplay(dbService : dbService)));
              },
              color: Colors.teal[300],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(29),
              ),
              child: Text(
                'Confirm'.toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          elevation: 10.0,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black,
          backgroundColor: Colors.teal[500],
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.camera_alt),
                title: Text(
                  'Take a Photo',
                  style: TextStyle(fontSize: 14),
                )),
            BottomNavigationBarItem(
                icon: Icon(Icons.edit),
                title: Text(
                  'Manual entry',
                  style: TextStyle(fontSize: 14),
                )),
            BottomNavigationBarItem(
                icon: Icon(Icons.perm_media),
                title: Text(
                  'Gallery',
                  style: TextStyle(fontSize: 14),
                )),
          ],
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  FloatingActionButton _createButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ItemCreation(dbService: dbService, edit: false)));
      },
      child: Container(
        height: 70,
        width: 70,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.teal[500], width: 5),
          shape: BoxShape.circle,
          color: Color(
              0xFF48D1CC), // this is the green button idk if it looks good? need change on AcccessContacts also
        ),
        child: Icon(Icons.add, size: 30, color: Colors.black),
      ),
      elevation: 0,
    );
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  PhotoPreviewPage(initialSource: ImageSource.camera)));
    } else if (index == 1) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ItemCreation(dbService: dbService, edit: false)));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  PhotoPreviewPage(initialSource: ImageSource.gallery)));
    }
  }
}
