import 'package:app/constants/colour.dart';
import 'package:app/models/GroupDetails.dart';
import 'package:app/models/UserDetails.dart';
import 'package:app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:provider/provider.dart';

import 'group.dart';

class _GroupCreationState extends State<GroupCreation> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _name;

  Widget _buildNameField() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: TextFormField(
        validator: (val) {
          if (val.isEmpty) {
            return 'Group Name cannot be empty!';
          }
          return null;
        },
        onSaved: (name) {
          _name = name;
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
          labelText: 'Group Name',
        ),
      ),
    );
  }

  Widget _createGroupButton() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: RaisedButton(
        child: Text(
          "Create Group",
          style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
        ),
         color: Colors.teal[300],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        onPressed: () {
          if (!_formKey.currentState.validate()) {
            return;
          }
          _formKey.currentState.save();
          _createGroup();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: Text('New Group'),
        gradient: appBarGradient,
        elevation: 0,
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
              _createGroupButton(),
            ],
          ),
        ),
      ),
    );
  }

  void _createGroup() async {
    final user = Provider.of<UserDetails>(context);
    GroupDetails groupsDetails =
        await DataBaseService().createGroupData(this._name, user);
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Group(data: groupsDetails)));
  }
}

class GroupCreation extends StatefulWidget {
  @override
  _GroupCreationState createState() => _GroupCreationState();
}
