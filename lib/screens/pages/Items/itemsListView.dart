import 'package:app/models/BillDetails.dart';
import 'package:app/models/MemberDetails.dart';
import 'package:app/models/itemDetails.dart';
import 'package:app/screens/pages/Items/ItemCreation.dart';
import 'package:app/services/database.dart';
import 'package:flutter/material.dart';

class ItemListView extends StatefulWidget {
  final DataBaseService dbService;
  final List<ItemDetails> itemList;
  final BillDetails billDetails;

  ItemListView({this.dbService, this.itemList, this.billDetails});

  @override
  _ItemListViewState createState() =>
      _ItemListViewState(dbService: dbService, itemList: itemList, billDetails : this.billDetails);
}

class _ItemListViewState extends State<ItemListView> {
  DataBaseService dbService;
  List<ItemDetails> itemList;
  BillDetails billDetails;

  _ItemListViewState({this.dbService, this.itemList, this.billDetails});
  @override
  Widget build(BuildContext context) {

    return itemList == null || itemList.length == 0
        ? _initialState()
        : ListView.builder(
            itemCount: itemList.length,
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
            itemBuilder: (context, index) {
              return _buildItemTile(
                  itemList[index]); // to ensure latest item at the bottom
            });
  }

  Widget _buildItemTile(ItemDetails item) {
    String name = item.name;
    double totalPrice = item.totalPrice;
    // int numSharing = item.selectedMembers.length;
    // String itemUID = item.itemUID;

    // print(itemUID);
    return Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          if (direction == DismissDirection.endToStart) {
            setState(()  {
              itemList.remove(item);
              _deletionMessage(context, name);
              print(itemList.length);
            });
          }
        },
        background: _deletionBackground(item),
        child: Container(
          decoration: item.selectedMembers.length == 0 ? BoxDecoration(color: Colors.red[300]) : BoxDecoration(),
          child: ListTile(
            onLongPress: () {
              for (MemberDetails member in item.selectedMembers) {
                print(member.name); 
              }
              print(item.name);
            }, // to debug
            onTap: () {
               Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ItemCreation(
                    dbService: dbService, itemList: itemList, item : item, billDetails : billDetails)));
            },
              leading: Icon(
                Icons.restaurant,
                color: Colors.white70,
              ),
              title: Text(name,
                  style: TextStyle(
                    color: Colors.white,
                  )),
              subtitle: Text(
                "\$${totalPrice.toStringAsFixed(2)}",
                style: TextStyle(color: Colors.white54),
              ),
             ),
        ));
  }

  Widget _initialState() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 220),
              Text(
                "Choose one of our functions",
                style: TextStyle(fontSize: 22.0, color: Colors.white),
              ),
              Text("to get Started!",
                  style: TextStyle(fontSize: 22.0, color: Colors.white)),
              SizedBox(height: 60),
            ],
          ),
        ],
      ),
    );
  }

  Widget _deletionBackground(ItemDetails item) {
    return Container(
      alignment: AlignmentDirectional.centerEnd,
      padding: EdgeInsets.only(right: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            'Removing ${item.name}',
            style: TextStyle(color: Colors.red),
          ),
          SizedBox(width: 16),
          Icon(Icons.delete, color: Colors.red),
        ],
      ),
    );
  }

  void _deletionMessage(context, String itemName) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("You have deleted $itemName"),
    ));
  }
}
