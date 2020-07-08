import 'package:app/constants/colour.dart';
import 'package:app/models/BillDetails.dart';
import 'package:app/models/MemberDetails.dart';
import 'package:app/models/itemDetails.dart';
import 'package:app/screens/pages/Items/itemPage.dart';
import 'package:app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/screens/pages/Items/SharingGrid.dart';

class ItemCreation extends StatefulWidget {
  final DataBaseService dbService;
  final List<ItemDetails> itemList;
  final BillDetails billDetails;
  final ItemDetails item;

  ItemCreation({this.dbService, this.itemList, this.item, this.billDetails});

  @override
  _ItemCreationState createState() => _ItemCreationState(
      dbService: dbService,
      itemList: itemList,
      item: item,
      billDetails: billDetails);
}

class _ItemCreationState extends State<ItemCreation> {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  DataBaseService dbService;
  String itemName = "";
  String totalPrice = "";
  final BillDetails billDetails;
  final _formKey = GlobalKey<FormState>();
  List<MemberDetails> selectedMembers = [];
  ItemDetails item;
  List<ItemDetails> itemList;

  _ItemCreationState(
      {this.dbService, this.itemList, this.item, this.billDetails});

  @override
  void initState() {
    super.initState();
    if (item != null) {
      nameController.text = item.name;
      double displayPrice = item.totalPrice/ ((100 + billDetails.extraCharges) / 100);
      priceController.text = displayPrice.toStringAsFixed(2);
      itemName = item.name;
      totalPrice = displayPrice.toStringAsFixed(2);
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
        backgroundColor: bodyColour,
        appBar: AppBar(
          title: Text('Create Item'),
          backgroundColor: headerColour,
        ),
        body: Padding(
            padding: EdgeInsets.only(
              top: 15.0,
              left: 10.0,
              right: 10.0,
            ),
            child: ListView(
              children: <Widget>[
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
          color: Colors.orange[300],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          onPressed: () async {
            int extraCharges = 100 + billDetails.extraCharges;
            double price = double.parse(totalPrice) * (extraCharges / 100);
            ItemDetails itemDetails = ItemDetails(
                name: itemName,
                totalPrice: price,
                selectedMembers: selectedMembers);
            
            if (item != null) {
              itemList.remove(item);
            }
            itemList.add(itemDetails);
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ItemPage(
                        dbService: dbService,
                        itemList: itemList,
                        billDetails: billDetails)));
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
                color: Colors.white70,
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
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(color: Colors.white, width: 2.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          labelText: 'Total Price',
          labelStyle: TextStyle(color: Colors.white70),
        ),
        style: TextStyle(color: Colors.white),
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
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(color: Colors.white, width: 2.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          labelText: 'Item Name',
          labelStyle: TextStyle(color: Colors.white70),
        ),
        style: TextStyle(color: Colors.white),
      ),
    );
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
