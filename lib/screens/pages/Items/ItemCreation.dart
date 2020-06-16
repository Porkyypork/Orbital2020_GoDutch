import 'package:app/constants/colour.dart';
import 'package:app/models/MemberDetails.dart';
import 'package:app/models/itemDetails.dart';
import 'package:app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:app/screens/pages/Items/SharingGrid.dart';

class ItemCreation extends StatefulWidget {
  final DataBaseService dbService;
  final ItemDetails item;
  final bool edit;

  ItemCreation({this.dbService, this.item, this.edit});

  @override
  _ItemCreationState createState() =>
      _ItemCreationState(dbService: dbService, item: item, edit: edit);
}

class _ItemCreationState extends State<ItemCreation> {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  DataBaseService dbService;
  String itemName = "";
  String totalPrice = "";
  ItemDetails itemDetails;
  final _formKey = GlobalKey<FormState>();
  List<MemberDetails> selectedMembers = [];
  ItemDetails item;
  final bool edit;

  _ItemCreationState({this.dbService, this.item, this.edit});

  @override
  void initState() {
    super.initState();
    if (item != null) {
      nameController.text = item.name;
      priceController.text = item.totalPrice.toString();
      itemName = item.name;
      totalPrice = item.totalPrice.toString();
    }
    nameController.addListener(_nameListener);
    priceController.addListener(_priceListener);
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<MemberDetails>>.value(
      value: dbService.members,
      child: Scaffold(
        appBar: GradientAppBar(
          title: Text('Edit Item'),
          gradient: appBarGradient,
        ),
        body: Padding(
            //edit accordingly
            padding: EdgeInsets.only(
              top: 15.0,
              left: 10.0,
              right: 10.0,
            ),
            child: ListView(
              children: <Widget>[
                Container(
                    //add if need any
                    ),
                _itemText(),
                _priceText(),
                _shareTextWidget(),
                SharingGrid(
                  selectedMembers: selectedMembers,
                ),
                _splitbutton(),
              ],
            )),
      ),
    );
  }

  Padding _splitbutton() {
    return Padding(
        padding: EdgeInsets.all(10.0),
        child: FlatButton(
          child: Text(
            "Split!",
            style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
          ),
          color: Colors.teal[300],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          onPressed: () async {
            double price = double.parse(totalPrice);
            int numShared = selectedMembers.length;
            double pricePerPax = price / numShared;
            if (edit) {
              itemDetails =
                  await dbService.editItem(itemName, price, selectedMembers);
            } else {
              itemDetails =
                  await dbService.createItem(itemName, price, selectedMembers);
            }
            // for (MemberDetails member in selectedMembers) {
            //   dbService.updateMember(member, pricePerPax);
            // } TODO: NOT WORKING
            dbService = new DataBaseService(
                uid: dbService.uid,
                groupUID: dbService.groupUID,
                billUID: dbService.billUID,
                itemUID: itemDetails.itemUID);
            // addMembers(selectedMembers);
            Navigator.pop(context);
          },
        ));
  }

  Padding _shareTextWidget() {
    return Padding(
        padding: EdgeInsets.only(
          left: 18.0,
          top: 10.0,
          bottom: 10.0,
        ),
        child: Text("Share With : ",
            style: TextStyle(
                fontSize: 17.0,
                color: Colors.black,
                fontWeight: FontWeight.bold)));
  }

  Padding _priceText() {
    return Padding(
      key: _formKey,
      padding:
          EdgeInsets.only(top: 5.0, bottom: 15.0, left: 10.0, right: 200.0),
      child: TextFormField(
        validator: (val) {
          if (val.isEmpty) {
            return 'Total Price cannot be empty!';
          }
          return null;
        },
        keyboardType: TextInputType.number,
        controller: priceController,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
          labelText: 'Total Price',
        ),
      ),
    );
  }

  Widget _itemText() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: TextFormField(
        validator: (val) {
          if (val.isEmpty) {
            return 'Item Name cannot be empty!';
          }
          return null;
        },
        controller: nameController,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
          labelText: 'Item Name',
        ),
      ),
    );
  }

  Future<void> addMembers(List<MemberDetails> members) async {
    for (MemberDetails member in members) {
      print(member.name);
      dbService.shareItemWith(member);
    }
  }

  void _nameListener() {
    setState(() {
      itemName = nameController.text;
    });
    print(itemName); // for debugging
  }

  void _priceListener() {
    setState(() {
      totalPrice = priceController.text;
    });
    print(totalPrice); // for debugging
  }
}
