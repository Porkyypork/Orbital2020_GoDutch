import 'package:app/constants/colour.dart';
import 'package:app/models/UserDetails.dart';
import 'package:app/models/GroupDetails.dart';
import 'package:app/screens/pages/group_related/group.dart';
import 'package:app/screens/pages/homepage/GroupListView.dart';
import 'package:app/services/auth.dart';
import 'package:app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../services/database.dart';

class _HomeState extends State<Home> {
  AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserDetails>(context);

    return StreamProvider<List<GroupDetails>>.value(
      value: DataBaseService(uid: user.uid).groups,
      child: Scaffold(
        backgroundColor: Colors.blue[50],
        body: Column(
          children: <Widget>[
            _buildCustomAppBar(),
            SizedBox(height: 5),
            GroupListView(),
            SizedBox(height: 30),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(color: Colors.teal[500]),
          child: Container(height: 50),
        ),
        floatingActionButton: _buildCreateGroupButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  Widget _buildCustomAppBar() {
    final user = Provider.of<UserDetails>(context);

    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: appBarGradient,
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(40)),
      ),
      child: Row(
        children: <Widget>[
          SizedBox(width: 10),
          Column(
            children: <Widget>[
              SizedBox(height: 30),
              Text(
                "Welcome back,",
                style: TextStyle(fontSize: 24),
              ),
              Text(
                user.name,
                style: TextStyle(fontSize: 24),
              ),
            ],
          ),
          SizedBox(width: 150),
          IconButton(
            onPressed: () async {
              Navigator.of(context).pushReplacementNamed('/');
              await _auth.signOut();
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateGroupButton() {
    return FloatingActionButton(
      onPressed: () {
        _groupsDialog();
      },
      child: Container(
        height: 70,
        width: 70,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.teal[500], width: 5),
          shape: BoxShape.circle,
          color: Color(
              0xFF48D1CC), // this is the green button idk if it looks good? need change on AcccessContacts also
        ),
        child: Icon(Icons.add, size: 30, color: Colors.black),
      ),
      elevation: 0,
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
            currentAccountPicture: GestureDetector(
              // onTap: () {}, can further implement features if we decide to
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://res.cloudinary.com/fleetnation/image/private/c_fit,w_1120/g_south,l_text:style_gothic2:%C2%A9%20Erik%20Reis,o_20,y_10/g_center,l_watermark4,o_25,y_50/v1454956714/jcz04ojmkyyz4wq5wvqf.jpg"),
              ),
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
