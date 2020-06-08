import 'package:app/models/itemDetails.dart';
import 'package:flutter/material.dart';
import 'package:app/constants/colour.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:app/screens/pages/Items/ItemCreation.dart';


class ItemPage extends StatefulWidget {
  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {

  List<ItemDetails> _items = [];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: GradientAppBar(
        gradient: appBarGradient,
        title: Text('Items'),
        centerTitle: true,
      ),
      body : Container(
        child: _listItems(),
      ),
      floatingActionButton: _createButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _listItems() {
    return _items == null || _items.length == 0 ? 
     _initialState() : ListView.builder(
      itemCount: _items.length,
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
      itemBuilder: (context, index) {
        return _buildItemTile(index);
      }
    );
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
          title : Text('Item Name'),
          subtitle: Text('Total Price'),
          trailing : SizedBox(
            child : Text('QTY')
          ),
          onTap : () {
             //
          }
        ),
      )
      
    );
  }

  Widget _initialState() {
    return Container(
      child: Center( 
        child: Text(
          "Tap on the Add Icon to get Started!",
          style: TextStyle(
            fontSize : 22.0
          ),        
        )
      ),
    );
  }

  Widget _createButton() {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed : () {
       Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ItemCreation()));      },
    );
  }

  void _deletionMessage(context, String itemName) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("You have deleted $itemName"),
    ));
  }
}
