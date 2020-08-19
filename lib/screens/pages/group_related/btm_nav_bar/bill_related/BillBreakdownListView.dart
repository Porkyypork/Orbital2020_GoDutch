import 'package:app/models/BillDetails.dart';
import 'package:app/models/itemDetails.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BillBreakdownListView extends StatefulWidget {
  final BillDetails bill;

  BillBreakdownListView({this.bill});

  @override
  _BillBreakdownListViewState createState() =>
      _BillBreakdownListViewState(bill: bill);
}

class _BillBreakdownListViewState extends State<BillBreakdownListView> {
  final BillDetails bill;
  double cost = 0;
  bool first = true;

  _BillBreakdownListViewState({this.bill});

  @override
  Widget build(BuildContext context) {
    final items = Provider.of<List<ItemDetails>>(context);

    return items == null
        ? _initialState()
        : Column(
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
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: items.length + 2,
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
                    itemBuilder: (context, index) {
                      if (index == items.length + 1) {
                        if (bill.extraCharges != 0) {
                          return _buildGstSvc();
                        } else {
                          return SizedBox();
                        }
                      } else if (index == items.length) {
                        if (bill.disc != 0) {
                          return _buildDiscounts();
                        } else {
                          return SizedBox();
                        }
                      } else {
                        return _buildBreakdownTile(items[index]);
                      }
                    }),
              ),
            ],
          );
  }

  Widget _heading() {
    final items = Provider.of<List<ItemDetails>>(context);
    if (first) {
      for (ItemDetails item in items) {
        cost += item.totalPrice;
      }
      cost = cost * ((100 + bill.extraCharges) / 100) - bill.disc;
      first = false;
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
          Flexible(
            child: Container(
              width: 250,
              child: Text(item.name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Montserrat',
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 45.0),
            child: Text(
              '\$${item.totalPrice.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, fontFamily: 'Montserrat'),
            ),
          ),
        ],
      )),
    );
  }

  Widget _buildGstSvc() {
    double extra = (cost / (bill.extraCharges + 100)) * bill.extraCharges;
    return Padding(
      padding: EdgeInsets.only(top: 10.0, bottom: 10, left: 20, right: 20),
      child: Container(
          child: Row(
        children: <Widget>[
          Container(
            width : 250,
            child: Text("GST/ SVC",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Montserrat',
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(left : 45.0),
            child: Text(
              '\$${extra.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, fontFamily: 'Montserrat'),
            ),
          ),
        ],
      )),
    );
  }

  Widget _buildDiscounts() {
    double disc = bill.disc;
    return Padding(
      padding: EdgeInsets.only(top: 10.0, bottom: 10, left: 20, right: 20),
      child: Container(
          child: Row(
        children: <Widget>[
          Container(
            width : 250,
            child: Text("Discounts",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Montserrat',
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(left : 45.0),
            child: Text(
              '-\$${disc.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, fontFamily: 'Montserrat'),
            ),
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
