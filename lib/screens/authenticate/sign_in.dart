import 'package:app/constants/colour.dart';
import 'package:app/constants/loading.dart';
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
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 120),
                      Text("logo and welcome message here"),
                      SizedBox(height: 120),
                      Container(
                          padding: EdgeInsets.only(left: 22, bottom: 2),
                          alignment: Alignment.centerLeft,
                          child: Text("Sign in",
                              style: TextStyle(fontSize: 16))),
                      SizedBox(height: 2),
                      _buildLoginForm(),
                      _buildForgotPassword(),
                      SizedBox(height: 15),
                      _buildSignInButton(),
                      Text(
                        "- OR -",
                        style: TextStyle(
                          fontSize: 15,
                          color: secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12),
                      _buildGoogleSignInButton(),
                      SizedBox(height: 10),
                      _buildNewUser(),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  Widget _buildForgotPassword() {
    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: Container(
        alignment: Alignment.centerRight,
        child: InkWell(
          onTap: () {
            // insert forgot password here
          },
          child: Text.rich(
            TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: "FORGOT YOUR PASSWORD?",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.black,
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
                            color: Colors.black),
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
              color: Colors.blue[100],
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
              color: Colors.blue[100],
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
    return Column(
      children: <Widget>[
        OutlineButton(
          splashColor: Colors.grey,
          onPressed: () async {
            if (_formKey.currentState.validate()) {
              setState(() => loading = true);
              dynamic result =
                  await _auth.signInWithEmailAndPassword(email, password);
              if (result == null) {
                setState(() {
                  error = 'Invalid Email or Password';
                  loading = false;
                });
              }
            }
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          highlightElevation: 0,
          borderSide: BorderSide(color: secondary),
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
        ),
        SizedBox(
            height: 10,
            child: Text(error,
                style: TextStyle(color: Colors.red, fontSize: 14.0))),
      ],
    );
  }

  Widget _buildGoogleSignInButton() {
    return OutlineButton(
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
      highlightElevation: 0,
      borderSide: BorderSide(color: secondary),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
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
