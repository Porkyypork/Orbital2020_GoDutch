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
      appBar: AppBar(
        title: Text('Items'),
        centerTitle: true,
      ),
      body: count == 0 ? _buildIntialState() : _listViewWidget(),
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

  Widget _buildIntialState() {
    return Container(
      child: Center(
        child: Text(
          'Tap on the Add Button to add New Items!',
          style: TextStyle(fontSize: 20),
        ),
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

    int quant = 0;
    double pricePerItem = 0.0;
    String name = "";
    double totalPrice = 0.0;

    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
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
                    labelText: "QTY",
                ),
                validator: (qty) => qty.isEmpty ? "Qty is Required" : null,
                onSaved: (qty) => {
                  setState(()  {
                    quant =  qty as int;
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
                onSaved: (price) {
                  setState(() {
                    pricePerItem = price as double;
                    totalPrice = pricePerItem * quant;
                  });
                },
              ),
            ),
            //need to fix this
            Expanded(
              child: SizedBox(
                child: Text("$totalPrice")
              ),
            ),
          ],
        ),
      ),
    );
  }
}
