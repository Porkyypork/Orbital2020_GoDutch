import 'package:app/constants/loading.dart';
import 'package:app/services/auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {

  final Function toogleView;
  SignIn({this.toogleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  
  final AuthService _auth = AuthService();
  String email = '';
  String password = '';
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

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
                ),
              ),
              Center(
                child: Container(
                  height: 470,
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
                                'Login',
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
                                  title: new TextFormField(
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
                                  title: new TextFormField(
                                    validator: (val) => val.length < 6
                                        ? 'Enter a password with 6 or more characters'
                                        : null,
                                    decoration: new InputDecoration(
                                      hintText: 'Please enter password',
                                      labelText: 'Enter Your Password',
                                    ),
                                    onChanged: (val) {
                                      setState(() => password = val);
                                    },
                                    obscureText: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Center(
                            child: Container(
                              margin: EdgeInsets.only(top: 40.0, bottom: 10.0),
                              child: InkWell(
                                onTap: () {
                                  // insert forgot password here
                                },
                                child: Text.rich(
                                  TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: "FORGOT PASSWORD",
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            color: Colors.black,
                                            fontSize: 12.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Container(
                                margin:
                                    EdgeInsets.only(bottom: 40.0, top: 10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "NEW USER?",
                                      style: TextStyle(
                                        fontSize: 13.0,
                                      ),
                                    ),
                                    SizedBox(width: 5.0),
                                    InkWell(
                                      onTap: () {
                                        widget.toogleView();
                                      },
                                      child: Text.rich(
                                        TextSpan(
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: 'REGISTER',
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  decoration:
                                                      TextDecoration.underline,
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
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
                              .signInWithEmailAndPassword(email, password);
                          if (result == null) {
                            setState(() {
                              error = 'Invalid Email or Password';
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
                                'Sign in',
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
                  Container(
                    margin: EdgeInsets.only(top: 0.0, bottom: 10.0),
                    child: OutlineButton(
                      splashColor: Colors.grey,
                      onPressed: () async {
                        setState(() => loading = true);
                        dynamic result = await _auth.signInWithGoogle();
                        if (result == null) {
                          setState(() {
                            error = 'Error logging in with Google';
                            setState(() {
                              loading = false;
                            });
                          });
                        }
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)),
                      highlightElevation: 0,
                      borderSide: BorderSide(color: Colors.grey),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image(
                                image: AssetImage("assets/google_logo.png"),
                                height: 35.0),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                'Sign in with Google',
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
                ],
              ),
            ],
          );
  }
}
