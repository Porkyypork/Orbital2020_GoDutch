import 'package:app/models/UserDetails.dart';
import 'package:app/models/GroupDetails.dart';
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
    final String _title = 'GoDutch';
    final user = Provider.of<UserDetails>(context);

    return StreamProvider<List<GroupDetails>>.value(
      value: DataBaseService(uid: user.uid).groups,
      child: Scaffold(
        backgroundColor: Colors.blue[50],
        appBar: AppBar(
          title: Text(
            _title,
            style: TextStyle(color: Colors.white),
          ),
          elevation: 0,
          backgroundColor: Colors.indigo,
          centerTitle: true,
        ),

        drawer: _buildDrawerMenu(context), //end drawer menu

        body: GroupListView(),

        bottomNavigationBar: BottomAppBar(
          color: Colors.indigo,
          shape: CircularNotchedRectangle(),
          child: Container(height: 50),
        ),

        floatingActionButton: _buildCreateGroupButton(),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  Widget _buildCreateGroupButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.pushNamed(context, '/group_creation');
        print("proceeding to group creation page\n");
      },
      backgroundColor: Colors.teal[300],
      child: Icon(Icons.add),
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
