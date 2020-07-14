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
  final Function refreshItemPage;

  ItemListView(
      {this.dbService, this.itemList, this.billDetails, this.refreshItemPage});

  @override
  _ItemListViewState createState() => _ItemListViewState(
      dbService: dbService,
      itemList: itemList,
      billDetails: this.billDetails,
      refreshItemPage: refreshItemPage);
}

class _ItemListViewState extends State<ItemListView> {
  DataBaseService dbService;
  List<ItemDetails> itemList;
  BillDetails billDetails;
  final Function refreshItemPage;

  _ItemListViewState(
      {this.dbService, this.itemList, this.billDetails, this.refreshItemPage});
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

    return Padding(
      padding: item.selectedMembers.length == 0
          ? const EdgeInsets.only(bottom: 2, left: 10, right: 10)
          : const EdgeInsets.symmetric(horizontal: 10),
      child: Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            if (direction == DismissDirection.endToStart) {
              setState(() {
                itemList.remove(item);
                _deletionMessage(context, name);
                print(itemList.length);
              });
            }
          },
          background: _deletionBackground(item),
          child: Container(
            decoration: item.selectedMembers.length == 0
                ? BoxDecoration(
                    color: Colors.red[300],
                    borderRadius: BorderRadius.circular(15))
                : BoxDecoration(),
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
                        dbService: dbService,
                        itemList: itemList,
                        item: item,
                        billDetails: billDetails)));
              },
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.restaurant,
                    color: Colors.white70,
                  ),
                ],
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
          )),
    );
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
              SizedBox(height: 160),
              Text(
                "Choose one of our functions",
                style: TextStyle(fontSize: 22.0, color: Colors.white),
              ),
              Text("to get started!",
                  style: TextStyle(fontSize: 22.0, color: Colors.white)),
              SizedBox(height: 40),
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
