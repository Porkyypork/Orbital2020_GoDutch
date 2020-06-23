import 'package:app/constants/colour.dart';
import 'package:app/models/UserDetails.dart';
import 'package:app/models/GroupDetails.dart';
import 'package:app/screens/pages/group_related/group.dart';
import 'package:app/screens/pages/homepage/GroupListView.dart';
import 'package:app/services/auth.dart';
import 'package:app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/colour.dart';
import '../../../services/database.dart';

class _HomeState extends State<Home> {
  AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserDetails>(context);

    return StreamProvider<List<GroupDetails>>.value(
      value: DataBaseService(uid: user.uid).groups,
      child: Scaffold(
        drawer: _buildDrawerMenu(context),
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: headerColour,
                child: _buildCustomAppBar(),
              ),
              Positioned(
                top: 30,
                child: Container(
                  height: 50,
                  width: 50,
                  child: Builder(
                    builder: (context) => _buildDrawerIcon(context),
                  ),
                ),
              ),
              Positioned(
                top: 130,
                child: Container(
                  decoration: BoxDecoration(
                    color: bodyColour,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  height: MediaQuery.of(context).size.height - 130,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 5),
                        height: 45,
                        child: Center(
                          child: Text('Your groups',
                              style: TextStyle(
                                fontSize: 32,
                                color: Colors.white70,
                                fontFamily: 'Montserrat',
                              )),
                        ),
                      ),
                      GroupListView(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: _buildCreateGroupButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Widget _buildCustomAppBar() {
    final user = Provider.of<UserDetails>(context);

    return Container(
      padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
      height: 100,
      width: MediaQuery.of(context).size.width,
      child: Align(
        alignment: Alignment.topLeft,
        child: Row(
          children: <Widget>[
            SizedBox(width: 115),
            Text(
              'Welcome back, \n${user.name}',
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.white70,
                  fontFamily: 'Montserrat'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerIcon(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.menu, color: Colors.black),
        iconSize: 22,
        onPressed: () => Scaffold.of(context).openDrawer());
  }

  Widget _buildCreateGroupButton() {
    return Container(
      child: FloatingActionButton.extended(
        backgroundColor: Colors.orange[300],
        label: Text('Create group',
            style: TextStyle(fontSize: 15, color: Colors.black)),
        elevation: 0,
        onPressed: () {
          _groupsDialog();
        },
      ),
    );
  }

  Future<dynamic> _groupsDialog() {
    final _formKey = GlobalKey<FormState>();
    final user = Provider.of<UserDetails>(context);
    DataBaseService dbService = DataBaseService(uid: user.uid);
    String groupName = "";

    return showDialog(
      context: context,
      child: Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          child: Container(
            height: 220,
            child: Padding(
                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Column(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          "New Group",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20.0),
                        )),
                    Padding(
                      padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Group name cannot be Empty';
                            }
                            return null;
                          },
                          onChanged: (name) {
                            setState(() {
                              groupName = name;
                            });
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  )),
                              labelText: 'Group name'),
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(
                                top: 20.0, left: 25.0, right: 30.0),
                            child: FlatButton(
                              child: Text(
                                "Ok",
                                style: TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              color: Colors.teal[300],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  GroupDetails groupsDetails = await dbService
                                      .createGroupData(groupName, user);
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Group(data: groupsDetails)));
                                }
                              },
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                              top: 20.0,
                              left: 15.0,
                            ),
                            child: FlatButton(
                              child: Text(
                                "Close",
                                style: TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              color: Colors.teal[300],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )),
                      ],
                    ),
                  ],
                )),
          )),
    );
  }

  Drawer _buildDrawerMenu(BuildContext context) {
    final user = Provider.of<UserDetails>(context);

    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
              user.name,
              style: TextStyle(color: Colors.white),
            ),
            accountEmail: Text(
              user.email,
              style: TextStyle(color: Colors.white),
            ),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle, //Optional can do a circle
              color: Colors.blue, //default color
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(
                    "https://images.wallpapersden.com/image/wxl-minimal-sunset-purple-mountains-and-birds_61310.jpg"),
              ),
            ),
          ),
          ListTile(
            title: Text("Profile"),
            onTap: () => Navigator.pushNamed(context, '/profile'),
            trailing: Icon(Icons.person),
          ),
          ListTile(
            title: Text("Unsettled"),
            onTap: () => Navigator.pushNamed(context, '/debts'),
            trailing: Icon(Icons.local_atm),
          ),
          ListTile(
            title: Text("About Us"),
            onTap: () => Navigator.pushNamed(context, '/about'),
            trailing: Icon(Icons.info),
          ),
          //SizedBox(height: 250), ==> This is to make the signout button at the botom of the drawer
          Divider(),
          ListTile(
            title: Text("Sign out"),
            onTap: () async {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              await _auth.signOut();
            },
            trailing: Icon(Icons.exit_to_app),
          ),
        ],
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}
