import 'package:app/constants/colour.dart';
import 'package:app/constants/loading.dart';
import 'package:app/screens/authenticate/resetPassword.dart';
import 'package:app/services/auth.dart';
import 'package:flutter/material.dart';

import 'background.dart';

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
        : Background(
            child: Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  child: Stack(children: <Widget>[
                    Positioned(top: 45, child: showAlert()),
                    Positioned(
                      top: 75,
                      left: 50,
                      child: Image(
                          image: AssetImage('assets/godutch_logo.PNG'),
                          height: 420,
                          width: 300),
                    ),
                    Positioned(
                      top: 100,
                      left: MediaQuery.of(context).size.width / 7,
                      child: Text(
                        'GoDutch',
                        style: TextStyle(
                            color: Colors.orange[300],
                            fontSize: 56,
                            fontFamily: 'Montserrat'),
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        SizedBox(
                            height: MediaQuery.of(context).size.height - 450),
                        Container(
                            padding: EdgeInsets.only(left: 22, bottom: 2),
                            alignment: Alignment.centerLeft,
                            child: Text("Sign in",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ))),
                        SizedBox(height: 2),
                        _buildLoginForm(),
                        _buildForgotPassword(),
                        SizedBox(height: 15),
                        _buildSignInButton(),
                        SizedBox(height: 5),
                        Text(
                          "- OR -",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 7),
                        _buildGoogleSignInButton(),
                        SizedBox(height: 10),
                        _buildNewUser(),
                      ],
                    ),
                  ]),
                ),
              ),
            ),
          );
  }

  void setWarning(String newError) {
    setState(() {
      error = newError;
    });
  }

  Widget showAlert() {
    if (error.isNotEmpty) {
      return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.orange[300]),
          width: 390,
          padding: EdgeInsets.all(8),
          child: Row(
            children: <Widget>[
              Icon(Icons.error_outline),
              Flexible(
                fit: FlexFit.tight,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(error),
                ),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    error = "";
                  });
                },
              )
            ],
          ));
    }
    return SizedBox(height: 0);
  }

  Widget _buildForgotPassword() {
    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: Container(
        alignment: Alignment.centerRight,
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ResetPassword(setWarning: setWarning)));
          },
          child: Text.rich(
            TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: "FORGOT YOUR PASSWORD?",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.white70,
                      fontSize: 10.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNewUser() {
    return Center(
      child: Container(
          margin: EdgeInsets.only(top: 5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "DON'T HAVE AN ACCOUNT?",
                style: TextStyle(
                  fontSize: 13.0,
                  color: Colors.white70,
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
                            decoration: TextDecoration.underline,
                            color: Colors.orange[300]),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(29),
              color: tileColour,
            ),
            child: TextFormField(
              validator: (val) => val.isEmpty ? 'Enter an email' : null,
              decoration: InputDecoration(
                hintText: 'Please enter email',
                labelText: 'Enter your email address',
                icon: Icon(Icons.person),
                border: InputBorder.none,
              ),
              onChanged: (val) {
                setState(() => email = val);
              },
            ),
          ),
          SizedBox(height: 5),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(29),
              color: tileColour,
            ),
            child: TextFormField(
              validator: (val) => val.length < 6
                  ? 'Enter a password with 6 or more characters'
                  : null,
              decoration: InputDecoration(
                hintText: 'Please enter password',
                labelText: 'Enter your password',
                icon: Icon(Icons.lock),
                border: InputBorder.none,
              ),
              onChanged: (val) {
                setState(() => password = val);
              },
              obscureText: true,
            ),
          ),
          SizedBox(height: 5),
        ],
      ),
    );
  }

  Widget _buildSignInButton() {
    return FlatButton(
      color: Colors.orange[300],
      splashColor: Colors.grey,
      onPressed: () async {
        if (_formKey.currentState.validate()) {
          setState(() => loading = true);
          dynamic result =
              await _auth.signInWithEmailAndPassword(email, password);
          if (result is String) {
            setState(() {
              error = result;
              loading = false;
            });
          }
        }
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 5, 9, 5),
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
                  color: secondary,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildGoogleSignInButton() {
    return FlatButton(
      color: Colors.white,
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 5, 5, 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/google_logo.png"), height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
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
}
