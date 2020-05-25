import 'package:app/models/groupdata.dart';
import 'package:app/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../pages/group.dart';

class _HomeState extends State<Home> {
  static List<GroupData> _groups = [];
  AuthService _auth = AuthService();
  final db = Firestore.instance;

  String name;
  String email;

  void _getCurrentUserData() async {
    final uid = await _auth.getCurrentUID();
    await db.collection("users").document(uid).get().then((value) => {
          setState(() {
            name = value["name"];
            email = value["email"];
          })
        });
  }

  @override
  void initState() {
    super.initState();
    _getCurrentUserData();
  }

  @override
  Widget build(BuildContext context) {
    final String _title = 'GoDutch';

    return Scaffold(
      backgroundColor: Colors.indigo[100],
      appBar: AppBar(
        title: Text(_title),
        elevation: 0,
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),

      endDrawer: _buildDrawerMenu(context), //end drawer menu

      body: (_groups.length > 0)
          ? ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
              itemCount: _groups.length,
              itemBuilder: (context, index) => _buildListTile(context, index),
            )
          : _buildNoGroupsHomeScreen(),

      bottomNavigationBar: BottomAppBar(
        color: Colors.indigo,
        shape: CircularNotchedRectangle(),
        child: Container(height: 50),
      ),

      floatingActionButton: _buildCreateGroupButton(),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildCreateGroupButton() {
    return FloatingActionButton(
      onPressed: () { // change to async function where they can cancel
        Navigator.pushNamed(context, '/group_creation');
        print("proceeding to group creation page\n");
        setState(() {
          GroupData newGroup = new GroupData(
              "I CANT CHANGE THE NAME FML"); // method for group creation here
          _groups.add(newGroup);
        });
      },
      backgroundColor: Colors.teal[300],
      child: Icon(Icons.add),
    );
  }

  Widget _buildNoGroupsHomeScreen() {
    return Container(
      child: Center(
        child: Text(
          "You are not currently in any groups",
          style: TextStyle(
            fontSize: 24.0,
          ),
        )
      )
    );
  }

/* TODO: 
1. Fix deletion to update properly and not return an error
2. properly update the database for proper group creation
3. turn off left swipe first
*/
  Dismissible _buildListTile(BuildContext context, int index) {
    return Dismissible(
      key: Key(_groups[index].groupName),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          setState(() {
            String groupName = _groups[index].groupName;
            _removeGroup(index);
            _deletionMessage(context, groupName);
          });
        } else {
          // do something else likely implementation of google vision
        }
      },
      background: _secondaryBackground(),
      secondaryBackground: _deletionBackground(),
      child: ListTile(
        leading: Icon(Icons.group,
            color:
                Colors.black), // replaced with their own personal photo later
        title: Text(
          _groups[index].groupName,
          style: TextStyle(
            fontSize: 18.0,
            letterSpacing: 1.5,
          ),
        ),

        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Group(data: _groups[index]),
          ));
        },
      ),
    );
  }

  Widget _deletionBackground() {
    return Container(
      alignment: AlignmentDirectional.centerEnd,
      padding: EdgeInsets.only(right: 15.0),
      color: Colors.red[600],
      child: Icon(Icons.delete, color: Colors.black),
    );
  }

  Widget _secondaryBackground() {
    return Container(
      alignment: AlignmentDirectional.centerStart,
      padding: EdgeInsets.only(left: 15.0),
      color: Colors.yellow[400],
      child: Icon(Icons.photo_camera, color: Colors.black),
    );
  }

  void _removeGroup(index) {
    setState(() {
      _groups.removeAt(index);
    });
  }

  void _deletionMessage(context, String groupName) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("You have left $groupName"),
    ));
  }

  Drawer _buildDrawerMenu(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(name),
            accountEmail: Text(email),
            currentAccountPicture: GestureDetector(
              // onTap: () {}, can further implement features if we decide to
              child: CircleAvatar(
                backgroundImage:
                    NetworkImage("https://i.imgflip.com/1pl7m4.jpg"),
              ),
            ),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle, //Optional can do a circle
              color: Colors.blue, //default color
              image: DecorationImage(
                fit: BoxFit.fill,
                // can easily change
                image: NetworkImage(
                    "https://www.hitc.com/static/uploads/hitcn/1641/smudge_the_cat_1390117.jpg"),
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
