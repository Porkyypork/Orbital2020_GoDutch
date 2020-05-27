import 'package:app/constants/loading.dart';
import 'package:app/models/UserDetails.dart';
import 'package:app/models/GroupDetails.dart';
import 'package:app/screens/pages/homepage/GroupListView.dart';
import 'package:app/services/auth.dart';
import 'package:app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../group.dart';

class _HomeState extends State<Home> {

  static List<GroupDetails> _groups = [];
  AuthService _auth = AuthService();

  UserDetails currentUser = UserDetails.loadingUser();

  void _getCurrentUserData() async {
    final uid = await _auth.getCurrentUID();
    UserDetails user = await DataBaseService().getCurrentUser(uid);
    setState(() {
      currentUser = user;
    });
  }

  //TODO
  // add method for fetching data from database
  @override
  void initState() {
    _getCurrentUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final String _title = 'GoDutch';

    return Scaffold(
      backgroundColor: Colors.indigo[100],
      appBar: AppBar(
        title: Text(
            "Actual user: ${currentUser.name}\nNumber of groups: ${currentUser.groups.length}"), //change back to _title after debugging
        elevation: 0,
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),

      endDrawer: _buildDrawerMenu(context), //end drawer menu

      /*TODO:
      encapsulate the creation of the body widget into another class called
      GroupListView ==> PROBLEMS: Was not passing the user correctly to the new class
      proof of concept done here, so the code is working just fine, but only user is not
      being passed*/
      body: (_groups.length > 0)
          ? ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
              itemCount: currentUser.groups.length,
              itemBuilder: (context, index) => FutureBuilder(
                  future: _buildGroupTile(context, currentUser.groups[index]),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      // gotta figure out a way to send to loading page rather than each indiv list tile loading
                      case ConnectionState.none:
                        return Loading();
                      case ConnectionState.active:
                        return Loading();
                      case ConnectionState.waiting:
                        return Loading();
                      case ConnectionState.done:
                        return snapshot.data;
                        break;
                      default:
                        return Text("default, it shouldnt reach here");
                    }
                  }))
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
      onPressed: () {
        // change to async function where they can cancel
        Navigator.pushNamed(context, '/group_creation');
        print("proceeding to group creation page\n");
        setState(() {
          GroupDetails newGroup = new GroupDetails(
              groupName: "A"); // method for group creation here
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
    )));
  }

  Future<Widget> _buildGroupTile(BuildContext context, String groupUID) async {
    GroupDetails group = await DataBaseService().getGroupDetails(groupUID);

    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          setState(() {
            String groupName = group.groupName;
            //_removeGroup(index);
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
          group.groupName,
          style: TextStyle(
            fontSize: 18.0,
            letterSpacing: 1.5,
          ),
        ),

        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Group(data: group),
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
      //_groups.removeAt(index);
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
            accountName: Text(currentUser.name),
            accountEmail: Text(currentUser.email),
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
