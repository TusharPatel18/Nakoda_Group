import 'package:nakoda_group/data/database_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth.dart';

class NavDrawer extends StatefulWidget {
  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> implements AuthStateListener {
  BuildContext _ctx;
  String loggedinname = "";
  String loggedincontact = "";
  String loggedinemail = "";
  bool _isratemenu = false;
  bool _isuser = false;

  List<Color> _colors = [Colors.white, Colors.white];
  List<double> _stops = [0.0, 0.7];
  _loadPref() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loggedinname = prefs.getString("name") ?? '';
      loggedincontact = prefs.getString("contact") ?? '';
      loggedinemail = prefs.getString("email") ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    _loadPref();
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            color: Color(0xFFF44336),
            child: DrawerHeader(
              padding: EdgeInsets.fromLTRB(0, 5.0, 0, 0),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: new Image.asset(
                  'images/logo.png',
                  width: 50.0,
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person, color: Colors.black),
            title: Text('My Profile',
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black)),
            onTap: () {
              Navigator.of(_ctx).pop();
              Navigator.of(_ctx).pushNamed("/myprofile");
            },
          ),
          // ListTile(
          //   leading: Icon(Icons.people, color: Colors.black),
          //   title: Text('My Family',
          //       style: TextStyle(
          //           fontSize: 15.0,
          //           fontWeight: FontWeight.w500,
          //           color: Colors.black)),
          //   onTap: () {
          //     Navigator.of(_ctx).pop();
          //     Navigator.of(_ctx).pushNamed("/myfamily");
          //   },
          // ),
          ListTile(
            leading: Icon(Icons.cake, color: Colors.black),
            title: Text('Birthday',
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black)),
            onTap: () {
              Navigator.of(_ctx).pop();
              Navigator.of(_ctx).pushNamed("/birthday");
            },
          ),
          ListTile(
            leading: Icon(Icons.card_giftcard, color: Colors.black),
            title: Text('Achievements',
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black)),
            onTap: () {
              Navigator.of(_ctx).pop();
              Navigator.of(_ctx).pushNamed("/achievement");
            },
          ),
          ListTile(
            leading: Icon(Icons.people, color: Colors.black),
            title: Text('Members',
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black)),
            onTap: () {
              Navigator.of(_ctx).pop();
              Navigator.of(_ctx).pushNamed("/members");
            },
          ),
          ListTile(
            leading: Icon(Icons.star, color: Colors.black),
            title: Text('Samaj Ratna',
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black)),
            onTap: () {
              Navigator.of(_ctx).pop();
              Navigator.of(_ctx).pushNamed("/samajratna");
            },
          ),
//          ListTile(
//            leading: Icon(Icons.notifications_active,color: Colors.black),
//            title: Text('Notifications',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.w500,color: Colors.black)),
//            onTap: (){
//              Navigator.of(_ctx).pop();
//              Navigator.of(_ctx).pushNamed("/notifications");
//            },
//          ),
          ListTile(
            leading: Icon(Icons.pages, color: Colors.black),
            title: Text('News',
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black)),
            onTap: () {
              Navigator.of(_ctx).pop();
              Navigator.of(_ctx).pushNamed("/news");
            },
          ),
          ListTile(
            leading: Icon(Icons.business_center, color: Colors.black),
            title: Text('Jobs',
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black)),
            onTap: () {
              Navigator.of(_ctx).pop();
              Navigator.pushNamed(context, '/jobs');
            },
          ),
          ListTile(
            leading: Icon(Icons.people, color: Colors.black),
            title: Text('Trustee',
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black)),
            onTap: () {
              Navigator.of(_ctx).pop();
              Navigator.of(_ctx).pushNamed("/trustee");
            },
          ),
          ListTile(
            leading: Icon(Icons.people, color: Colors.black),
            title: Text('Committee',
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black)),
            onTap: () {
              Navigator.of(_ctx).pop();
              Navigator.of(_ctx).pushNamed("/committee");
            },
          ),
          ListTile(
            leading: Icon(Icons.photo, color: Colors.black),
            title: Text('Photo',
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black)),
            onTap: () {
              Navigator.of(_ctx).pop();
              Navigator.of(_ctx).pushNamed("/photo");
            },
          ),
          ListTile(
            leading: Icon(Icons.video_library, color: Colors.black),
            title: Text('Video',
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black)),
            onTap: () {
              Navigator.of(_ctx).pop();
              Navigator.of(_ctx).pushNamed("/video");
            },
          ),
          ListTile(
            leading: Icon(Icons.audiotrack, color: Colors.black),
            title: Text('Audio',
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black)),
            onTap: () {
              Navigator.of(_ctx).pop();
              Navigator.of(_ctx).pushNamed("/audio");
            },
          ),
          ListTile(
            leading: Icon(Icons.info, color: Colors.black),
            title: Text('About',
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black)),
            onTap: () {
              Navigator.of(_ctx).pop();
              Navigator.of(_ctx).pushNamed("/about");
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app, color: Colors.black),
            title: Text('Logout',
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black)),
            onTap: () => logout(),
          ),
          _divider(),
          SizedBox(
            height: 10,
          ),
          Column(
            children: <Widget>[
              new Center(
                child: new Text("Version 1.0",
                    style: TextStyle(color: Colors.red)),
              ),
              SizedBox(
                height: 10,
              ),
              new Center(
                child: new Text("Developed by Karon Infotech",
                    style: TextStyle(fontSize: 12.0)),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          )
        ],
      ),
    );
  }

  void logout() async {
    var authStateProvider = new AuthStateProvider();
    authStateProvider.dispose(this);
    var db = new DatabaseHelper();
    await db.deleteUsers();
    authStateProvider.notify(AuthState.LOGGED_OUT);
    Navigator.of(_ctx).pushReplacementNamed("/login");
  }

  @override
  void onAuthStateChanged(AuthState state) {
    // TODO: implement onAuthStateChanged
  }
}
