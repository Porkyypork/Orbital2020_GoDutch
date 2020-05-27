import 'package:app/services/auth.dart';
import 'package:app/services/database.dart';
import 'package:flutter/material.dart';

class _GroupCreationState extends State<GroupCreation> {

  AuthService _auth = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _name;

  Widget _buildGroupPictureField() {

  }

  Widget _buildNameField() { // format is generally the same across all formfield methods
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

  Widget _buildMemberListField() {

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
    final uid = await _auth.getCurrentUID();
    await DataBaseService().createGroupData(this._name, uid);
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
  }
}

class GroupCreation extends StatefulWidget {
  @override
  _GroupCreationState createState() => _GroupCreationState();
}