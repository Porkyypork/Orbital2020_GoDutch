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
        : ListView.builder(
            itemCount: items.length,
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
            itemBuilder: (context, index) => _buildBreakdownTile(items[index]));
  }

  Widget _buildBreakdownTile(ItemDetails item) {
    return Card(
      margin: EdgeInsets.all(5),
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 10, 15, 10),
        child: Row(
          children: <Widget>[
            Container(
              child : Text(
                        item.name,
                        style: TextStyle(color: Colors.black, fontSize: 30),
                      )
            ),
            Spacer(),
            Container(
              child: Text(
                        '\$${item.totalPrice.toStringAsFixed(2)}',
                        style: TextStyle(color: Colors.black, fontSize: 25),
                      )
            )
            // Align(
            //   alignment: Alignment.,
            //   child: Column(
            //     children: <Widget>[
            //       Align(
            //         alignment: Alignment.centerLeft,
            //         child: Text(
            //           item.name,
            //           style: TextStyle(
            //             color: Colors.black,
            //             fontSize: 28,
            //           ),
            //         ),
            //       ),
            //       Align(
            //           alignment: Alignment.centerLeft,
            //           child: Text(
            //             'Total price: \$${item.totalPrice.toStringAsFixed(2)}',
            //             style: TextStyle(color: Colors.grey, fontSize: 18),
            //           )),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
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
