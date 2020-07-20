import 'package:app/constants/colour.dart';
import 'package:app/constants/loading.dart';
import 'package:app/models/UserDetails.dart';
import 'package:app/services/auth.dart';
import 'package:flutter/material.dart';

import 'background.dart';

class Register extends StatefulWidget {
  final Function toogleView;
  Register({this.toogleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String name = '';
  String phoneNumber = '';
  String email = '';
  String password = '';
  String confirmPassword = '';
  String error = '';
  bool loading = false;

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  Widget _buildNameField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(29),
        color: tileColour,
      ),
      child: TextFormField(
        validator: (val) => val.isEmpty ? 'Enter your name' : null,
        decoration: InputDecoration(
          hintText: 'Please enter your name',
          labelText: 'Name',
          icon: Icon(Icons.create),
          border: InputBorder.none,
        ),
        onChanged: (val) {
          setState(() => name = val);
        },
      ),
    );
  }

  Widget _buildPhoneNumberField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(29),
        color: tileColour,
      ),
      child: TextFormField(
        validator: (val) =>
            val.isEmpty ? 'Enter your mobile phone number' : null,
        decoration: InputDecoration(
          hintText: 'Please enter your mobile phone number',
          labelText: 'Phone number',
          icon: Icon(Icons.phone),
          border: InputBorder.none,
        ),
        onChanged: (val) {
          setState(() => phoneNumber = val);
        },
      ),
    );
  }

  Widget _buildEmailField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(29),
        color: tileColour,
      ),
      child: TextFormField(
        validator: (val) => val.isEmpty ? 'Enter an Email' : null,
        decoration: InputDecoration(
          hintText: 'Please enter your email address',
          labelText: 'Email address',
          icon: Icon(Icons.person),
          border: InputBorder.none,
        ),
        onChanged: (val) {
          setState(() => email = val);
        },
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(29),
        color: tileColour,
      ),
      child: TextFormField(
        decoration: new InputDecoration(
          hintText: 'Please enter your password',
          labelText: 'Password',
          icon: Icon(Icons.lock),
          border: InputBorder.none,
        ),
        validator: (val) => val.length < 6
            ? 'Enter a password with 6 or more characters'
            : null,
        onChanged: (val) {
          setState(() => password = val);
        },
        obscureText: true,
      ),
    );
  }

  Widget _buildConfirmPasswordField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(29),
        color: tileColour,
      ),
      child: TextFormField(
        decoration: new InputDecoration(
          hintText: 'Please re-enter your password',
          labelText: 'Re-enter password',
          icon: Icon(Icons.priority_high),
          border: InputBorder.none,
        ),
        validator: (val) =>
            val != password ? 'Your passwords do not match' : null,
        onChanged: (val) {
          setState(() => confirmPassword = val);
        },
        obscureText: true,
      ),
    );
  }

  Widget _buildRegisterButton() {
    return FlatButton(
      color: Colors.orange[300],
      splashColor: Colors.grey,
      onPressed: () async {
        if (_formKey.currentState.validate()) {
          print('attempting to register user');
          setState(() => loading = true);
          UserDetails newUser =
              new UserDetails(name: name, number: phoneNumber, email: email);
          dynamic result =
              await _auth.registerWithEmailAndPassword(newUser, password);
          if (result.uid == 'Error_1') {
            setState(() {
              error = 'Email already in use';
              loading = false;
            });
          } else if (result == null) {
            setState(() {
              error = 'Please supply a valid email';
              loading = false;
            });
          }
        }
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Register',
                style: TextStyle(
                  fontSize: 20,
                  color: secondary,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAlreadyHaveAccount() {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 5),
        child: Column(
          children: <Widget>[
            Text(
              "ALREADY HAVE AN ACCOUNT?",
              style: TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 5),
            InkWell(
              onTap: widget.toogleView,
              child: Text.rich(TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: "LOG IN",
                    style: TextStyle(
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                      color: Colors.orange[300],
                    ),
                  ),
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Background(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Text(
                    "Create your GoDutch account\n",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Divider(color: secondary),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 3),
                          _buildNameField(),
                          SizedBox(height: 5),
                          _buildPhoneNumberField(),
                          SizedBox(height: 5),
                          _buildEmailField(),
                          SizedBox(height: 5),
                          _buildPasswordField(),
                          SizedBox(height: 5),
                          _buildConfirmPasswordField(),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildRegisterButton(),
                  SizedBox(height: 15),
                  _buildAlreadyHaveAccount(),
                  SizedBox(
                      height: 16,
                      child: Text(error,
                          style: TextStyle(color: Colors.red, fontSize: 14.0))),
                ],
              ),
            ),
          );
  }
}
