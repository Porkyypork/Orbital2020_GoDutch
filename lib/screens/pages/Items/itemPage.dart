import 'package:app/models/itemDetails.dart';
import 'package:app/screens/pages/Items/itemsListView.dart';
import 'package:flutter/material.dart';
import 'package:app/constants/colour.dart';
import 'package:app/screens/pages/Items/ItemCreation.dart';
import 'package:app/services/database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../group_related/btm_nav_bar/bill_related/BillBreakdown.dart';
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

  List<ItemDetails> itemList = [];

  _ItemPageState({this.dbService, this.billName});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<ItemDetails>>.value(
      value: dbService.items,
      child: Scaffold(
        backgroundColor: bodyColour,
        appBar: AppBar(
          leading: _backButton(),
          backgroundColor: headerColour,
          title: Text(billName),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height - 330,
              child: ItemListView(dbService: dbService, itemList: itemList),
            ),
          ],
        ),
        floatingActionButton: _confirmButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        bottomNavigationBar: BottomNavigationBar(
          elevation: 10.0,
          selectedItemColor: Colors.white70,
          unselectedItemColor: Colors.white70,
          backgroundColor: headerColour,
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

  Widget _backButton() {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () async {
        bool isEmpty = await dbService.isBillEmpty();
        if (isEmpty) {
          showDialog(
            context: context,
            child: _backWarningDialog(),
          );
        } else {
          Navigator.pop(context);
        }
      },
    );
  }

  Widget _confirmButton() {
    return Builder(
      builder: (context) => RaisedButton(
        padding: EdgeInsets.fromLTRB(30, 15, 30, 15),
        onPressed: () async {
          bool isEmpty = await dbService.isBillEmpty();
          if (isEmpty) {
            showDialog(
              context: context,
              child: _buildWarningDialog(),
            );
          } else {
            Navigator.pop(context);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    BillBreakdown(dbService: dbService, billName: billName)));
          }
        },
        color: Colors.orange[300],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(29),
        ),
        child: Text(
          'Confirm'.toUpperCase(),
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildWarningDialog() {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      child: Container(
        height: 150,
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Please add an Item to the Bill!',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 25),
            FlatButton(
                color: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(29),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'))
          ],
        ),
      ),
    );
  }

  Widget _backWarningDialog() {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      child: Container(
        height: 160,
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Going back will delete \ncurrent bill!',
              textAlign : TextAlign.center,
              style: TextStyle(fontSize: 20, wordSpacing: 1),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                    color: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(29),
                    ),
                    onPressed: () {
                      String billUID = dbService.billUID;
                      dbService.removeBill(billUID);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text('OK')),
                SizedBox(width: 35),
                FlatButton(
                    color: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(29),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Close')),
              ],
            )
          ],
        ),
      ),
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
                  ItemCreation(dbService: dbService, itemList: itemList)));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  PhotoPreviewPage(initialSource: ImageSource.gallery)));
    }
  }
}
