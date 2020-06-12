import 'package:app/models/itemDetails.dart';
import 'package:app/screens/pages/PhotoPreviewPage.dart';
import 'package:flutter/material.dart';
import 'package:app/constants/colour.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:app/screens/pages/Items/ItemCreation.dart';
import 'package:app/services/database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ItemPage extends StatefulWidget {

  final String billName;
  final DataBaseService dbService;
  final PanelController pc;

  ItemPage({this.dbService, this.pc, this.billName});

  @override
  _ItemPageState createState() => _ItemPageState(dbService: dbService, pc: pc, billName: billName);
}

class _ItemPageState extends State<ItemPage> {
  List<ItemDetails> _items = [];

  final DataBaseService dbService;
  final PanelController pc;
  final String billName;

  _ItemPageState({this.dbService, this.pc, this.billName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: GradientAppBar(
        gradient: appBarGradient,
        title: Text(billName),
        centerTitle: true,
      ),
      body: SlidingUpPanel(
        controller: pc,
        backdropEnabled: true,
        isDraggable: false,
        body: _listItems(),
        panel: _menu(dbService),
        collapsed: _floatingCollasped(),
        minHeight: 0,
        maxHeight: 232,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      floatingActionButton: _createButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar:
          BottomAppBar(color: Colors.teal[500], child: SizedBox(height: 54)),
    );
  }

  Widget _listItems() {
    return _items == null || _items.length == 0
        ? _initialState()
        : ListView.builder(
            itemCount: _items.length,
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
            itemBuilder: (context, index) {
              return _buildItemTile(index);
            });
  }

  Widget _buildItemTile(int index) {
    return Dismissible(
        key: UniqueKey(),
        onDismissed: (direction) {
          setState(() {
            String itemName = _items.elementAt(index).name;
            _items.removeAt(index);
            _deletionMessage(context, itemName);
          });
        },
        child: Container(
          child: ListTile(
              leading: Icon(Icons.restaurant),
              title: Text('Item Name'),
              subtitle: Text('Total Price'),
              trailing: SizedBox(child: Text('QTY')),
              onTap: () {
                //
              }),
        ));
  }

  Widget _initialState() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Tap on the Add Icon to get Started!",
            style: TextStyle(fontSize: 22.0),
          ),
          SizedBox(height: 140),
        ],
      ),
    );
  }

  FloatingActionButton _createButton() {
    return FloatingActionButton(
      onPressed: () {
        pc.open();
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

  void _deletionMessage(context, String itemName) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("You have deleted $itemName"),
    ));
  }

  Widget _floatingCollasped() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFA5CFE3),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
    );
  }

  Widget _menu(DataBaseService dbService) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Color(0xFFA5CFE3),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
              height: 30,
            ),
            SizedBox(
              height: 202,
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                      color: Color(0xFFDEE2EC)),
                  child: Stack(
                    overflow: Overflow.visible,
                    children: <Widget>[
                      Positioned(
                        child: ListView(
                          physics: NeverScrollableScrollPhysics(),
                          children: ListTile.divideTiles(
                            context: context,
                            tiles: [
                              ListTile(
                                  title: Text("Add an Item"),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ItemCreation(
                                                dbService: dbService)));
                                  },
                                  leading: Icon(Icons.receipt)),
                              ListTile(
                                title: Text('Take a Photo'),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PhotoPreviewPage(
                                                  initialSource:
                                                      ImageSource.camera)));
                                },
                                leading: Icon(Icons.camera_alt),
                              ),
                              ListTile(
                                title: Text("Add a Receipt from Gallery"),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PhotoPreviewPage(
                                                  initialSource:
                                                      ImageSource.gallery)));
                                },
                                leading: Icon(Icons.collections),
                              ),
                            ],
                          ).toList(),
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ],
    );
  }
}
