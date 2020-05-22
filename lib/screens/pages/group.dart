import 'package:app/models/groupdata.dart';
import 'package:flutter/material.dart';


// Everyone else starts with a balance of 0, and as people pay, their value decreases, while others increase.
// i.e. for a group of 4 people and split evenly setting. Members are A, B, C, D.
// 1. A pays $10 for something. NEW STATE: [A = -7.5, B = +2.5, C = +2.5, D = +2.5]
// 2. B pays a back to get rid of their debt. NEW STATE: [A = -5, B = 0, C = +2.5, D = +2.5]
// 3. etc...

class _GroupState extends State<Group> {

  GroupData data;
  _GroupState(this.data);

  @override
  Widget build(BuildContext context) {

    String groupName = data.groupName;

    return Scaffold(
      backgroundColor: Colors.yellow[50],
      appBar: AppBar(
        title: Text(groupName),
        elevation: 0,
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),

      endDrawer: _buildDrawerMenu(context),

      body: Text('this is the groups page'),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.camera_alt, color: Colors.white),
        backgroundColor: Colors.blueAccent,
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Drawer _buildDrawerMenu(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[

          Container(
            color: Colors.white10,
            child: ListTile(
              title: Text(
                "Member List",
                style: TextStyle(fontSize: 20.0),
                ),
              trailing: Icon(Icons.group),
            ),
          ),

          
          Divider(),

          ListTile(
            title: Text("This is the dailou"),
            trailing: Icon(Icons.star),
          ),

          ListTile(
            title: Text("Member 1"),
            trailing: Icon(Icons.person),
          ),

          ListTile(
            title: Text("Member 2"),
            trailing: Icon(Icons.person),
          ),

          ListTile(
            title: Text("Member 3"),
            trailing: Icon(Icons.person),
          ),

          Divider(),
          ListTile(
            title: Text("Close"),
            trailing: Icon(Icons.cancel),
            onTap: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

class Group extends StatefulWidget {

  GroupData data;
  Group({this.data});

  @override
  _GroupState createState() => _GroupState(data);
}