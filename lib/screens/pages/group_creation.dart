import 'package:app/models/GroupDetails.dart';
import 'package:app/screens/pages/group.dart';
import 'package:app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/UserDetails.dart';

class _GroupCreationState extends State<GroupCreation> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _name;

  Widget _buildGroupPictureField() {

  }

  Widget _buildNameField() { // format is generally the same across all formfield methods
    return TextFormField(
      decoration: InputDecoration(labelText: "Group Name"),
      maxLength: 24,
      validator: (String value) {
        if (value.isEmpty) {
          return "Group name is required";
        }
        return null;
      },
      onSaved: (String value) {
        _name = value;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[100],
      appBar: AppBar(
        title: Text('this is the group creation page'),
        elevation: 0,
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),

      body: Container(
        margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //_buildGroupPictureField(),
              _buildNameField(),
              //_buildMemberList(),
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
                  _createGroup();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _createGroup() async {
    final user = Provider.of<UserDetails>(context);
    GroupDetails groupsDetails = await DataBaseService().createGroupData(this._name, user);
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    Navigator.push(context, MaterialPageRoute(builder: (context) => Group(data : groupsDetails)));
  }
}

class GroupCreation extends StatefulWidget {
  @override
  _GroupCreationState createState() => _GroupCreationState();
}