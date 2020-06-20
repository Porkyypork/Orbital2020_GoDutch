import 'package:app/models/itemDetails.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BillBreakdownListView extends StatefulWidget {
  @override
  _BillBreakdownListViewState createState() => _BillBreakdownListViewState();
}

class _BillBreakdownListViewState extends State<BillBreakdownListView> {
  @override
  Widget build(BuildContext context) {
    final items = Provider.of<List<ItemDetails>>(context);

    return items == null || items.length == 0
        ? _initialState()
        : SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text('Items Breakdown',
                      style: TextStyle(
                          letterSpacing: 1,
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'OpenSans')),
                ),
                _heading(),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: items.length,
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
                    itemBuilder: (context, index) =>
                        _buildBreakdownTile(items[index])),
              ],
            ),
          );
  }

  Widget _heading() {
    final items = Provider.of<List<ItemDetails>>(context);
    double cost = 0;
    for (ItemDetails item in items) {
      cost += item.totalPrice;
    }

    return Container(
        padding: EdgeInsets.only(left: 15, right: 10),
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(width: 1, color: Colors.black),
                bottom: BorderSide(width: 1, color: Colors.black))),
        child: Padding(
          padding: EdgeInsets.only(top: 10.0, bottom: 10, left: 20, right: 20),
          child: Container(
              child: Row(
            children: <Widget>[
              Text('Total :',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans')),
              Spacer(),
              Text('\$${cost.toStringAsFixed(2)}',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans')),
            ],
          )),
        ));
  }

  Widget _buildBreakdownTile(ItemDetails item) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0, bottom: 10, left: 20, right: 20),
      child: Container(
          child: Row(
        children: <Widget>[
          Text(item.name,
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Montserrat',
              )),
          Spacer(),
          Text(
            '\$${item.totalPrice.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 20, fontFamily: 'Montserrat'),
          ),
        ],
      )),
    );
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
                "You have no items in this Bill",
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 140),
            ],
          ),
        ],
      ),
    );
  }
}
