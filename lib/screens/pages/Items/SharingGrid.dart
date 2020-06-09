import 'package:app/models/MemberDetails.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SharingGrid extends StatefulWidget {


  @override
  _SharingGridState createState() => _SharingGridState();
}

class _SharingGridState extends State<SharingGrid> {

  @override
  Widget build(BuildContext context) {
    
    bool value = false;
    final members = Provider.of<List<MemberDetails>>(context);

    return SizedBox(
        height : 150,
        child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height / 10),
        children : List.generate(members.length, (index) {
          //not working yet
          return CheckboxListTile(
            title: Text(members[index].name),
            value : false,
            onChanged: (bool check) {
              setState (() {
                
              });
            }
          );
        })
      ),
    );
  }
}