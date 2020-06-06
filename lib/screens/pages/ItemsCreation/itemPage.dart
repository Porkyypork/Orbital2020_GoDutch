import 'package:flutter/material.dart';
import 'package:app/constants/colour.dart';

class ItemPage extends StatefulWidget {
  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {

  var listView = List<Widget>();
  int count = 1;

  @override
  void initState() {
    super.initState();
    _add();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: Text('Items'),
        centerTitle: true,
      ),
      body:  _listViewWidget(),
      bottomNavigationBar: BottomAppBar(
        color: appBar,
        shape: CircularNotchedRectangle(),
        child: Container(height: 50),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _add();
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _listViewWidget() {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return listView.elementAt(index);
        },
        itemCount: listView.length,
      ),
    );
  }

  void _add() {
    int keyValue = count;
    var _listView = List.from(listView);
    listView.add(_buildList(keyValue, _listView));
    setState(() {
      count++;
    });
  }

  Widget _buildList(int index, List<dynamic> listView) {

    int quant;
    double pricePerItem;
    String itemName;
    
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        listView.removeAt(index);
      },
      background: _deletionBackground(),
      child: Form(
          child: Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            key: Key("$index"),
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Item Name",
                  ),
                  validator: (name) =>
                      name.isEmpty ? "Item name is required" : null,
                  onChanged: (name) {
                    setState(() => itemName = name);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
              ),
              SizedBox(
                width: 40,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "Qty",
                  ),
                  validator: (qty) => qty.isEmpty ? "Qty is Required" : null,
                  onChanged: (qty) => {
                    setState(() => {
                      quant =  int.parse(qty),
                    })
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
              ),
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "Price per Item",
                  ),
                  validator: (price) => price.isEmpty ? "Price is Required" : null,
                  onChanged: (price) {
                    setState(() {
                      pricePerItem = double.parse(price);
                    });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal : 10),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _deletionBackground() {
    return Container(
      alignment: AlignmentDirectional.centerEnd,
      padding: EdgeInsets.only(right: 15.0),
       //color: Colors.red[600],
      child: Row (
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          SizedBox(width: 16),
          Icon(Icons.delete, color: Colors.black),
        ],
      ),
    );
  }

}
