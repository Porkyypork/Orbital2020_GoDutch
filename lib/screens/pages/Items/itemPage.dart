import 'package:app/constants/loading.dart';
import 'package:app/models/BillDetails.dart';
import 'package:app/models/MemberDetails.dart';
import 'package:app/models/itemDetails.dart';
import 'package:app/screens/pages/Items/itemsListView.dart';
import 'package:flutter/material.dart';
import 'package:app/constants/colour.dart';
import 'package:app/screens/pages/Items/ItemCreation.dart';
import 'package:app/services/database.dart';
import 'package:image_picker/image_picker.dart';

import '../group_related/btm_nav_bar/bill_related/BillBreakdown.dart';
import 'PhotoPreviewPage.dart';

class ItemPage extends StatefulWidget {
  final BillDetails billDetails;
  final DataBaseService dbService;
  final List<ItemDetails> itemList;

  ItemPage({this.dbService, this.billDetails, this.itemList});

  @override
  _ItemPageState createState() => _ItemPageState(
      dbService: dbService, billDetails: billDetails, itemList: itemList);
}

class _ItemPageState extends State<ItemPage> {
  DataBaseService dbService;
  final BillDetails billDetails;

  List<ItemDetails> itemList;

  _ItemPageState({this.dbService, this.billDetails, this.itemList});

  @override
  Widget build(BuildContext context) {
    if (itemList == null) {
      itemList = [];
    }
    return WillPopScope(
      onWillPop: () => _onWillPop(),
      child: Scaffold(
        backgroundColor: bodyColour,
        appBar: AppBar(
          leading: _backButton(),
          backgroundColor: headerColour,
          title: Text(billDetails.billName),
          centerTitle: true,
          actions: <Widget>[
            Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.delete_sweep, color: Colors.black, size: 28),
                onPressed: () {
                  setState(() {
                    itemList.clear();
                  });
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text('All items have been deleted'),
                  ));
                },
              ),
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ItemListView(
                dbService: dbService,
                itemList: itemList,
                billDetails: billDetails,
              ),
            ),
            Container(height: 80),
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
        showDialog(
          context: context,
          child: _backWarningDialog(),
        );
      },
    );
  }

  Widget _confirmButton() {
    return Builder(
      builder: (context) => RaisedButton(
        padding: EdgeInsets.fromLTRB(30, 15, 30, 15),
        onPressed: () async {
          if (itemList.isEmpty) {
            showDialog(
              context: context,
              child: _buildWarningDialog(),
            );
          } else {
            bool isValid = true;

            for (ItemDetails item in itemList) {
              // if any item detail has no selected members, it is empty
              if (item.selectedMembers.isEmpty) {
                isValid = false;
                break; // as long as there is one itemDetail object that has no selected members, the bill is invalid
              }
            }

            if (!isValid) {
              // print('bill is not valid');
              showDialog(
                context: context,
                child: _inValidBillWarningDialog(),
              );
            } else {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Loading()));
              for (ItemDetails item in itemList) {
                ItemDetails itemDetails = await dbService.createItem(
                    item.name, item.totalPrice, item.selectedMembers);
                dbService = new DataBaseService(
                    uid: dbService.uid,
                    groupUID: dbService.groupUID,
                    billUID: dbService.billUID,
                    owedBillUID: dbService.owedBillUID,
                    itemUID: itemDetails.itemUID);
                addMembers(item.selectedMembers);
              }
              Navigator.pop(context); // pop loading
              Navigator.pop(context); // pop itempage
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => BillBreakdown(
                      dbService: dbService, billName: billDetails.billName)));
            }
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

  Widget _inValidBillWarningDialog() {
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
              'Some items are not shared',
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
              textAlign: TextAlign.center,
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
                      Navigator.pop(context, true);
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
                      Navigator.pop(context, false);
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
              builder: (context) => PhotoPreviewPage(
                  initialSource: ImageSource.camera,
                  dbService: dbService,
                  itemList: itemList,
                  billDetails: billDetails)));
    } else if (index == 1) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ItemCreation(
                  dbService: dbService,
                  itemList: itemList,
                  billDetails: billDetails)));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PhotoPreviewPage(
                  initialSource: ImageSource.gallery,
                  dbService: dbService,
                  itemList: itemList,
                  billDetails: billDetails)));
    }
  }

  Future<void> addMembers(List<MemberDetails> members) async {
    for (MemberDetails member in members) {
      dbService.shareItemWith(member);
    }
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
            context: context, builder: (context) => _backWarningDialog())) ??
        false;
  }
}
