import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../../constants/colour.dart';
import '../../services/database.dart';
import 'Items/itemPage.dart';
import 'PhotoPreviewPage.dart';

class Bills extends StatefulWidget {

  DataBaseService dbService;
  PanelController pc;

  Bills({this.dbService, this.pc});
  @override
  _BillsState createState() => _BillsState(dbService : dbService, pc : pc);
}

class _BillsState extends State<Bills> {
  DataBaseService dbService;
  PanelController pc;

  _BillsState({this.dbService, this.pc});

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      controller: pc,
      backdropEnabled: true,
      isDraggable: false,
      body: Text('HI'),
      panel: _menu(dbService),
      collapsed: _floatingCollasped(),
      minHeight: 40,
      maxHeight: 232,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(50),
        topRight: Radius.circular(50),
      ),
    );
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
                                  title: Text("Key in a Bill"),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ItemPage(
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
