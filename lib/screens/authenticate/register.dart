import 'package:app/constants/loading.dart';
import 'package:app/services/auth.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  final Function toogleView;
  Register({this.toogleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String email = '';
  String password = '';
  String error = '';
  bool loading = false;

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

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
                  height: 340,
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
                                ListTile(
                                  leading: const Icon(Icons.person),
                                  title: TextFormField(
                                    validator: (val) =>
                                        val.isEmpty ? 'Enter an Email' : null,
                                    decoration: new InputDecoration(
                                      hintText: 'Please enter email',
                                      labelText: 'Enter Your Email address',
                                    ),
                                    onChanged: (val) {
                                      setState(() => email = val);
                                    },
                                  ),
                                ),
                                ListTile(
                                  leading: const Icon(Icons.lock),
                                  title: TextFormField(
                                    decoration: new InputDecoration(
                                      hintText: 'Please enter password',
                                      labelText: 'Enter Your Password',
                                    ),
                                    validator: (val) => val.length < 6
                                        ? 'Enter a password with 6 or more characters'
                                        : null,
                                    onChanged: (val) {
                                      setState(() => password = val);
                                    },
                                    obscureText: true,
                                  ),
                                ),
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
                  Center(
                    child: OutlineButton(
                      splashColor: Colors.grey,
                      onPressed: () async {
                       if (_formKey.currentState.validate()) {
                         setState(() => loading = true);
                          dynamic result = await _auth
                              .registerWithEmailAndPassword(email, password);
                          if (result == null) {
                            setState(() {
                            error = 'Please supply a valid email';
                            loading = false;
                            });
                          }
                        } 
                      },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
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
                  SizedBox(height:10),
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
