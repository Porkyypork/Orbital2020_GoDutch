import 'package:app/models/groupdata.dart';
import 'package:app/services/auth.dart';
import 'package:flutter/material.dart';
import '../pages/group.dart';

// i wanna add a when u scroll up, search bar comes out and swipe to delete
// using high contrast colors rn just to tell the difference between what
// is what

class _HomeState extends State<Home> {
  static List<GroupData> _groups = [];
  AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final String _title = 'GoDutch';

    return Scaffold(
      backgroundColor: Colors.yellow[50],
      appBar: AppBar(
        title: Text(_title),
        elevation: 0,
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),

      endDrawer: _buildDrawerMenu(context), //end drawer menu

      body: (_groups.length > 0)
          ? ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
              itemCount: _groups.length,
              itemBuilder: (context, index) => _buildListTile(context, index),
            )
          : Text("You are not part of any groups"),

      bottomNavigationBar: BottomAppBar(
        color: Colors.blueAccent,
        shape: CircularNotchedRectangle(),
        child: Container(height: 50),
      ),

      floatingActionButton: _buildCreateGroupButton(),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildCreateGroupButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.pushNamed(context, '/group_creation');
        print("proceeding to group creation page\n");
        setState(() {
          // instantiate new group object with what they give and create and add
          GroupData newGroup = new GroupData(
              "I CANT CHANGE THE NAME FML"); // method for group creation here
          _groups.add(
              newGroup); //implement feature to take in unique group name first, then work from there
        });
      },
      backgroundColor: Colors.teal[300],
      child: Icon(Icons.add),
    );
  }

  Dismissible _buildListTile(BuildContext context, int index) {
    return Dismissible(
      key: Key(_groups[index].groupName),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          String groupName = _groups[index].groupName;
          _removeGroup(index);
          _deletionMessage(context, groupName);
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
            accountName: Text("John Doe"),
            accountEmail: Text("johndoe@gmail.com"),
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
