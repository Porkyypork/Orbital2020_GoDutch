import 'package:app/models/groupdata.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


//after we exit this page by confirming or by exiting, need to refresh
//the states for homepage.

class _GroupCreationState extends State<GroupCreation> {

  //final _user = TestUser(); // fortesting purposes

  String _name;

 final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildName() { // format is generally the same across all formfield methods
    return TextFormField(
      decoration: InputDecoration(labelText: "Group Name"),
      maxLength: 22,
      validator: (String value) {
        if (value.isEmpty) {
          return "Group name is required";
        }
      },
      onSaved: (String value) {
        _name = value;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('this is the group creation page'),
        elevation: 0,
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),

      body: Container(
        margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildName(),
              // any further fields that we need to add ==> Add a group member list
              SizedBox(height: 50.0),

              RaisedButton(
                child: Text(
                  "Create Group",
                  style: TextStyle(color: Colors.red, fontSize: 18.0),
                ),
                onPressed: () {
                  if (!_formKey.currentState.validate()) {
                    return;
                  }
                  _formKey.currentState.save();
                  GroupData newGroup = new GroupData(_name);
                  print("Name: [$_name] is saved");
                  print("Returning to homescreen");
                  Navigator.of(context).pushReplacementNamed('/home');
                },

              ),
            ],
          ),
        ),
      ),


    );
  }
}

class GroupCreation extends StatefulWidget {
  @override
  _GroupCreationState createState() => _GroupCreationState();
}