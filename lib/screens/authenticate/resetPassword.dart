import 'package:app/constants/colour.dart';
import 'package:app/screens/authenticate/background.dart';
import 'package:app/services/auth.dart';
import 'package:flutter/material.dart';

class ResetPassword extends StatefulWidget {
  final Function setWarning;

  ResetPassword({this.setWarning});

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  String email = '';
  String error = '';
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Background(
        child: SingleChildScrollView(
            child: Column(
      children: <Widget>[
        Text(
          'Reset Password',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        Divider(color: secondary),
        _buildEmailField(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildReturnButton(),
            _buildSubmitButton(),
          ],
        ),
        SizedBox(
            height: 16,
            child: Text(error,
                style: TextStyle(color: Colors.red, fontSize: 14.0))),
      ],
    )));
  }

  Widget _buildEmailField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(29),
          color: tileColour,
        ),
        child: Form(
          key: _formKey,
          child: TextFormField(
            validator: (val) => val.isEmpty ? 'Enter an Email' : null,
            decoration: InputDecoration(
              hintText: 'Please enter your email address',
              labelText: 'Email address',
              icon: Icon(Icons.person),
              border: InputBorder.none,
            ),
            onChanged: (val) {
              setState(() {
                email = val;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FlatButton(
        color: Colors.orange[300],
        splashColor: Colors.grey,
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            int result = await _auth.resetPassword(email);
            if (result == 1) {
              widget
                  .setWarning("A password reset link has been sent to $email");
              Navigator.pop(context);
            } else if (result == -1) {
              setState(() {
                error = 'Please supply a valid email';
              });
            } else {
              setState(() {
                error = "Email not found";
              });
            }
          }
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            width: 70,
            child: Center(
              child: Text(
                'Reset',
                style: TextStyle(
                  fontSize: 20,
                  color: secondary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReturnButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FlatButton(
        color: Colors.orange[300],
        splashColor: Colors.grey,
        onPressed: () async {
          Navigator.pop(context);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            width: 70,
            child: Center(
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 20,
                  color: secondary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
