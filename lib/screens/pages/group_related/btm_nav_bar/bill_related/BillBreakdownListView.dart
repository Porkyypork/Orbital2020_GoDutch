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

    return ListView.builder(
        itemCount: items.length,
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
        itemBuilder: (context, index) => _buildBreakdownTile(items[index]));
  }

  Widget _buildBreakdownTile(ItemDetails item) {
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(),
      ),
      child: Column(
        children: <Widget>[
          Text(item.name),
          Text('${item.totalPrice}'),
          //TODO: print out the members names
        ],
      ),
    );
  }
}
