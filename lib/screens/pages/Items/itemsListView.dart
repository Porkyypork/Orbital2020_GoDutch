import 'package:app/models/itemDetails.dart';
import 'package:app/screens/pages/Items/ItemCreation.dart';
import 'package:app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemListView extends StatefulWidget {
  final DataBaseService dbService;

  ItemListView({this.dbService});

  @override
  _ItemListViewState createState() => _ItemListViewState(dbService: dbService);
}

class _ItemListViewState extends State<ItemListView> {
  DataBaseService dbService;

  _ItemListViewState({this.dbService});
  @override
  Widget build(BuildContext context) {
    final _items = Provider.of<List<ItemDetails>>(context);

    return _items == null || _items.length == 0
        ? _initialState()
        : ListView.builder(
            itemCount: _items.length,
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
            itemBuilder: (context, index) {
              return _buildItemTile(index, _items[index]);
            });
  }

  Widget _buildItemTile(int index, ItemDetails item) {
    String itemUID = item.itemUID;
    String name = item.name;
    String totalPrice = item.totalPrice.toStringAsFixed(2);
    print(itemUID);
    return Dismissible(
        key: UniqueKey(),
        onDismissed: (direction) {
          setState(() async {
            await dbService.deleteItem(itemUID);
            _deletionMessage(context, name);
          });
        },
        child: Container(
          child: ListTile(
              leading: Icon(Icons.restaurant),
              title: Text(name),
              subtitle: Text("\$$totalPrice"),
              onTap: () {
                dbService = new DataBaseService(
                    uid: dbService.uid,
                    groupUID: dbService.groupUID,
                    billUID: dbService.billUID,
                    itemUID: itemUID);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ItemCreation(
                            dbService: dbService, item: item, edit: true)));
              }),
        ));
  }

  Widget _initialState() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 120),
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

  void _deletionMessage(context, String itemName) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("You have deleted $itemName"),
    ));
  }
}
