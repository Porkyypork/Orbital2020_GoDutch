import 'package:app/constants/colour.dart';
import 'package:app/models/GroupDetails.dart';
import 'package:app/models/MemberDetails.dart';
import 'package:app/models/UserDetails.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:provider/provider.dart';

class ItemCreation extends StatefulWidget {
  @override
  _ItemCreationState createState() => _ItemCreationState();
}

class _ItemCreationState extends State<ItemCreation> {

  TextEditingController nameController = TextEditingController();
  TextEditingController qtyControlller = TextEditingController();
  TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    
    return Scaffold(
      appBar: GradientAppBar(
        title : Text('Edit Item'),
        gradient: appBarGradient,
      ),
      body: Padding(
        //edit accordingly
        padding: EdgeInsets.only(
          top : 15.0,
          left: 10.0,
          right : 10.0,
        ),
        child : ListView(
          children: <Widget>[
            Container(
              //add if need any
            ),
            _itemText(),
            _priceText(),
            _shareWidget(),
            //_buildGridView(members),
            _splitbutton(),
          ],
        )
      ),
    );
  }

  Padding _splitbutton() {
    return Padding(
            padding : EdgeInsets.all(10.0),
            child : FlatButton(
              child : Text(
                "Split!",
                style : TextStyle(
                  fontSize : 17.0,
                  fontWeight: FontWeight.bold
                ),
              ),
              color : Colors.teal[300],
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
              ),
              onPressed: () {
                //save
              },
            )
          );
  }

  GridView _buildGridView(List<MemberDetails> members) {
    return GridView.count(
            crossAxisCount : 2,
            children: List.generate(members.length, (index) => null)
          );
  }

  Padding _shareWidget() {
    return Padding(
            padding : EdgeInsets.only(
              left : 18.0,
              top : 10.0,
              bottom: 10.0,
            ),
            child : Text(
              "Share With : ",
              style: TextStyle(
                fontSize : 17.0,
                color: Colors.black,
                fontWeight: FontWeight.bold
              )
              )
          );
  }

  Padding _priceText() {
    return Padding(
            padding : EdgeInsets.only(
              top : 15.0,
              bottom : 15.0,
              left: 10.0,
              right : 200.0
            ),
            child : TextField(
              keyboardType: TextInputType.number,
              controller : nameController,
              decoration: InputDecoration(
                border : OutlineInputBorder(
                  borderRadius : BorderRadius.circular(30.0),
                  borderSide: BorderSide(
                    color : Colors.black,
                  ),
                ),
                labelText: 'Total Price',
              ),
            ),
          );
  }

  Widget _itemText() {
    return Padding(
              padding : EdgeInsets.all(10.0),
              child : TextField(
                controller : nameController,
                decoration: InputDecoration(
                  border : OutlineInputBorder(
                    borderRadius : BorderRadius.circular(30.0),
                    borderSide: BorderSide(
                      color : Colors.black,
                    ),
                  ),
                  labelText: 'Item Name',
                ),
              ),
            );
  }
}