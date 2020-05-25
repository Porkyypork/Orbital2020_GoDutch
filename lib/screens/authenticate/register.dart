import 'package:app/constants/loading.dart';
import 'package:app/models/UserDetails.dart';
import 'package:app/services/auth.dart';
import 'package:flutter/material.dart';

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
    return ListTile(
      leading: const Icon(Icons.create),
      title: TextFormField(
        validator: (val) => val.isEmpty ? 'Enter your name' : null,
        decoration: new InputDecoration(
          hintText: 'Please enter your name',
          labelText: 'Name',
        ),
        onChanged: (val) {
          setState(() => name = val);
        },
      ),
    );
  }

  Widget _buildPhoneNumberField() {
    return ListTile(
      leading: const Icon(Icons.phone),
      title: TextFormField(
        validator: (val) => val.isEmpty ? 'Enter your mobile phone number' : null,
        decoration: new InputDecoration(
          hintText: 'Please enter your mobile phone number',
          labelText: 'Phone number',
        ),
        onChanged: (val) {
          setState(() => phoneNumber = val);
        },
      ),
    );
  }

  Widget _buildEmailField() {
    return ListTile(
      leading: const Icon(Icons.person),
      title: TextFormField(
        validator: (val) => val.isEmpty ? 'Enter an Email' : null,
        decoration: new InputDecoration(
          hintText: 'Please enter your email address',
          labelText: 'Email address',
        ),
        onChanged: (val) {
          setState(() => email = val);
        },
      ),
    );
  }

  Widget _buildPasswordField() {
    return ListTile(
      leading: const Icon(Icons.lock),
      title: TextFormField(
        decoration: new InputDecoration(
          hintText: 'Please enter your password',
          labelText: 'Password',
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
    return ListTile(
      leading: const Icon(Icons.priority_high),
      title: TextFormField(
        decoration: new InputDecoration(
          hintText: 'Please re-enter your password',
          labelText: 'Re-enter password',
        ),
        validator: (val) => val != password
            ? 'Your passwords do not match'
            : null,
        onChanged: (val) {
          setState(() => confirmPassword = val);
        },
        obscureText: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Stack(
            children: <Widget>[
              Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: Colors.grey[300],
                appBar: AppBar(
                  title: Text(
                    'GoDutch',
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                  centerTitle: true,
                  backgroundColor: Colors.teal[300],
                  elevation: 0.0,
                  leading: IconButton(
                      icon:
                          Icon(Icons.keyboard_arrow_left, color: Colors.black),
                      onPressed: () {
                        widget.toogleView();
                      }),
                ),
              ),
              Center(
                child: Container(
                  height: 500,
                  child: Opacity(
                    opacity: 0.7,
                    child: Card(
                      color: Colors.blue[50],
                      elevation: 6.0,
                      margin: EdgeInsets.only(right: 15.0, left: 15.0),
                      child: new Wrap(
                        children: <Widget>[
                          Center(
                            child: Container(
                              margin: EdgeInsets.only(top: 20.0),
                              child: Text(
                                'Create Your GoDutch Account',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                _buildNameField(),
                                _buildPhoneNumberField(),
                                _buildEmailField(),
                                _buildPasswordField(),
                                _buildConfirmPasswordField(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                children: <Widget>[
                  Container(
                    height: 420,
                  ),
                  SizedBox(height: 80),
                  Center(
                    child: OutlineButton(
                      splashColor: Colors.grey,
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          setState(() => loading = true);
                          UserDetails newUser = new UserDetails(name: name, number: phoneNumber, email: email);
                          dynamic result = await _auth
                              .registerWithEmailAndPassword(newUser, password);
                          if (result.id == 'Error_1') {
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
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)),
                      highlightElevation: 0,
                      borderSide: BorderSide(color: Colors.grey),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                'Create',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.blue,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                      height: 16,
                      child: Text(error,
                          style: TextStyle(color: Colors.red, fontSize: 14.0))),
                ],
              ),
            ],
          );
  }
}
