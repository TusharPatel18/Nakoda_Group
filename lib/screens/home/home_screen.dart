import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nakoda_group/data/database_helper.dart';
import 'package:nakoda_group/data/rest_ds.dart';
import 'package:nakoda_group/models/sponser.dart';
import 'package:nakoda_group/screens/navigation/navigation_screen.dart';
import 'package:nakoda_group/utils/connectionStatusSingleton.dart';
import 'package:nakoda_group/utils/internetconnection.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:nakoda_group/utils/network_util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../auth.dart';
 
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> implements AuthStateListener{
  NetworkUtil _netUtil = new NetworkUtil();
  BuildContext _ctx;
  SharedPreferences prefs;
  String FirstName,MiddleName ,LastGautra,Mobile1;
  Future<List<SponserList>> sponserdata;

  _loadPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      FirstName = prefs.getString("FirstName");
      MiddleName = prefs.getString("MiddleName");
      LastGautra = prefs.getString("LastGautra");
      Mobile1 = prefs.getString("Mobile1");
      sponserdata = _getSponserData();
    });
  }

  Future<List<SponserList>> _getSponserData() async {
    return _netUtil.post(RestDatasource.GET_SPONSER,).then((dynamic res) {
      final items = res.cast<Map<String, dynamic>>();
      List<SponserList> listofusers = items.map<SponserList>((json) {
        return SponserList.fromJson(json);
      }).toList();
      List<SponserList> revdata = listofusers.reversed.toList();
      return revdata;
    });
  }

  bool isOffline = false;
  InternetConnection connection = new InternetConnection();
  StreamSubscription _connectionChangeStream;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ConnectionStatusSingleton connectionStatus =
    ConnectionStatusSingleton.getInstance();
    connectionStatus.initialize();
    _connectionChangeStream =
        connectionStatus.connectionChange.listen(connectionChanged);
      _loadPref();
  }

  void connectionChanged(dynamic hasConnection) {
    setState(() {
      isOffline = !hasConnection;
      //print(isOffline);
    });
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    if (isOffline) {
      return connection.nointernetconnection();
    } else {
      return new Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          title: Text("Nakoda Group"),
        ),
        drawer: NavDrawer(),
        body: DoubleBackToCloseApp(
          snackBar: const SnackBar(
            duration: Duration(seconds: 1),
            content: Text('Press again to exit app'),
          ),
          child: Container(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Card(
                    elevation: 3.0,
                    margin: new EdgeInsets.fromLTRB(5, 10, 5, 5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.fromLTRB(15, 15, 10, 15),
                      child: Column(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 60,
                            child: new Image.asset(
                              'images/logo.png',
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                           "Nakoda Social Group",
                            style: TextStyle(color: Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w100),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: InkWell(
                          onTap: (){
                            Navigator.of(_ctx).pushNamed("/myprofile");
                          },
                          child: Card(
                            elevation: 3.0,
                            margin: new EdgeInsets.all(5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.fromLTRB(15, 15, 10, 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Icon(Icons.person,color: Color(0xFFF44336),size: 35,),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text('My Profile',
                                          style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.w500,color: Colors.black)
                                      ),
                                      Icon(Icons.arrow_forward,color: Colors.red.shade400,size: 15,),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: InkWell(
                          onTap: (){
                            Navigator.of(_ctx).pushNamed("/birthday");
                          },
                          child: Card(
                            elevation: 3.0,
                            margin: new EdgeInsets.all(5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.fromLTRB(15, 15, 10, 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Icon(Icons.cake,color: Color(0xFFF44336),size: 35,),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text('Birthday',
                                          style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.w500,color: Colors.black)
                                      ),
                                      Icon(Icons.arrow_forward,color: Colors.red.shade400,size: 15,),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: InkWell(
                          onTap: (){
                            Navigator.of(_ctx).pushNamed("/achievement");
                          },
                          child: Card(
                            elevation: 3.0,
                            margin: new EdgeInsets.all(5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.fromLTRB(15, 15, 10, 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Icon(Icons.card_giftcard,color: Color(0xFFF44336),size: 35,),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text('Achievements',
                                          style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.w500,color: Colors.black)
                                      ),
                                      Icon(Icons.arrow_forward,color: Colors.red.shade400,size: 15,),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: InkWell(
                          onTap: (){
                            Navigator.of(_ctx).pushNamed("/members");
                          },
                          child: Card(
                            elevation: 3.0,
                            margin: new EdgeInsets.all(5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.fromLTRB(15, 15, 10, 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Icon(Icons.people,color: Color(0xFFF44336),size: 35,),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text('Members',
                                          style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.w500,color: Colors.black)
                                      ),
                                      Icon(Icons.arrow_forward,color: Colors.red.shade400,size: 15,),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: InkWell(
                          onTap: (){
                            Navigator.of(_ctx).pushNamed("/samajratna");
                          },
                          child: Card(
                            elevation: 3.0,
                            margin: new EdgeInsets.all(5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.fromLTRB(15, 15, 10, 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Icon(Icons.star,color: Color(0xFFF44336),size: 35,),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text('Samaj Ratna',
                                          style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.w500,color: Colors.black)
                                      ),
                                      Icon(Icons.arrow_forward,color: Colors.red.shade400,size: 15,),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: InkWell(
                          onTap: (){
                            Navigator.of(_ctx).pushNamed("/news");
                          },
                          child: Card(
                            elevation: 3.0,
                            margin: new EdgeInsets.all(5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.fromLTRB(15, 15, 10, 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Icon(Icons.pages,color: Color(0xFFF44336),size: 35,),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text('News',
                                          style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.w500,color: Colors.black)
                                      ),
                                      Icon(Icons.arrow_forward,color: Colors.red.shade400,size: 15,),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: InkWell(
                          onTap: (){
                            Navigator.pushNamed(context, '/jobs');
                          },
                          child: Card(
                            elevation: 3.0,
                            margin: new EdgeInsets.all(5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.fromLTRB(15, 15, 10, 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Icon(Icons.business_center,color: Color(0xFFF44336),size: 35,),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text('Jobs',
                                          style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.w500,color: Colors.black)
                                      ),
                                      Icon(Icons.arrow_forward,color: Colors.red.shade400,size: 15,),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: InkWell(
                          onTap: (){
                            Navigator.of(_ctx).pushNamed("/trustee");
                          },
                          child: Card(
                            elevation: 3.0,
                            margin: new EdgeInsets.all(5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.fromLTRB(15, 15, 10, 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Icon(Icons.people,color: Color(0xFFF44336),size: 35,),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text('Trustee',
                                          style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.w500,color: Colors.black)
                                      ),
                                      Icon(Icons.arrow_forward,color: Colors.red.shade400,size: 15,),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: InkWell(
                          onTap: (){
                            Navigator.of(_ctx).pushNamed("/committee");
                          },
                          child: Card(
                            elevation: 3.0,
                            margin: new EdgeInsets.all(5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.fromLTRB(15, 15, 10, 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Icon(Icons.people,color: Color(0xFFF44336),size: 35,),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text('Committee',
                                          style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.w500,color: Colors.black)
                                      ),
                                      Icon(Icons.arrow_forward,color: Colors.red.shade400,size: 15,),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: InkWell(
                          onTap: (){
                            Navigator.of(_ctx).pushNamed("/photocategory");
                          },
                          child: Card(
                            elevation: 3.0,
                            margin: new EdgeInsets.all(5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.fromLTRB(15, 15, 10, 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Icon(Icons.photo,color: Color(0xFFF44336),size: 35,),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text('Photo',
                                          style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.w500,color: Colors.black)
                                      ),
                                      Icon(Icons.arrow_forward,color: Colors.red.shade400,size: 15,),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: InkWell(
                          onTap: (){
                            Navigator.of(_ctx).pushNamed("/videocategory");
                          },
                          child: Card(
                            elevation: 3.0,
                            margin: new EdgeInsets.all(5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.fromLTRB(15, 15, 10, 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Icon(Icons.video_library,color: Color(0xFFF44336),size: 35,),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text('Video',
                                          style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.w500,color: Colors.black)
                                      ),
                                      Icon(Icons.arrow_forward,color: Colors.red.shade400,size: 15,),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: InkWell(
                          onTap: (){
                            Navigator.of(_ctx).pushNamed("/audiocategory");
                          },
                          child: Card(
                            elevation: 3.0,
                            margin: new EdgeInsets.all(5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.fromLTRB(15, 15, 10, 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Icon(Icons.audiotrack,color: Color(0xFFF44336),size: 35,),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text('Audio',
                                          style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.w500,color: Colors.black)
                                      ),
                                      Icon(Icons.arrow_forward,color: Colors.red.shade400,size: 15,),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: InkWell(
                          onTap: (){
                            Navigator.of(_ctx).pushNamed("/about");
                          },
                          child: Card(
                            elevation: 3.0,
                            margin: new EdgeInsets.all(5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.fromLTRB(15, 15, 10, 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Icon(Icons.info,color: Color(0xFFF44336),size: 35,),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text('About Us',
                                          style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.w500,color: Colors.black)
                                      ),
                                      Icon(Icons.arrow_forward,color: Colors.red.shade400,size: 15,),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: InkWell(
                          onTap: (){
                            logout();
                          },
                          child: Card(
                            elevation: 3.0,
                            margin: new EdgeInsets.all(5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.fromLTRB(15, 15, 10, 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Icon(Icons.exit_to_app,color: Color(0xFFF44336),size: 35,),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text('Logout',
                                          style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.w500,color: Colors.black)
                                      ),
                                      Icon(Icons.arrow_forward,color: Colors.red.shade400,size: 15,),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: Card(
                          elevation: 3.0,
                          margin: new EdgeInsets.all(5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.fromLTRB(15, 15, 10, 15),
                            child: FutureBuilder<List<SponserList>>(
                              future: sponserdata,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (!snapshot.hasData) {
                                  return Center(
                                    child: Text("No Data Available!"),
                                  );
                                }
                                return ListView(
                                  shrinkWrap: true,
                                  children: snapshot.data
                                      .map(
                                        (data) => InkWell(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return StatefulBuilder(
                                                  builder: (BuildContext context, StateSetter setState) {
                                                    return Dialog(
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(10.0),
                                                      ),
                                                      backgroundColor: Colors.white,
                                                      child: Container(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: <Widget>[
                                                            Center(
                                                              child: Container(
                                                                margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                                                child: Text(
                                                                  data.SponserName,
                                                                  style: TextStyle(
                                                                      fontSize: 20,
                                                                      fontWeight: FontWeight.bold,
                                                                      color: Colors.black),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                            Center(
                                                              child: Container(
                                                                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                                                alignment: Alignment.centerLeft,
                                                                child: Text(
                                                                  data.ContactNo ?? "",
                                                                  style: TextStyle(
                                                                      fontSize: 15,
                                                                      fontWeight: FontWeight.bold,
                                                                      color: Colors.black),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 15,
                                                            ),
                                                            Center(
                                                              child: RaisedButton(
                                                                color: Theme.of(context).primaryColor,
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(25),
                                                                ),
                                                                onPressed:() async {
                                                                  var url = data.ContactNo ?? "";
                                                                  if (await canLaunch('tel:$url')) {
                                                                    await launch('tel:$url');
                                                                  } else {
                                                                    throw 'Could not launch $url';
                                                                  }
                                                                },
                                                                child: Text(
                                                                  "Contact US",
                                                                  style: TextStyle(
                                                                      fontWeight: FontWeight.bold,color: Colors.white),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 15,
                                                            ),
                                                            Center(
                                                              child: InkWell(
                                                                onTap: () async {
                                                                  var url = data.WebLink;
                                                                  if (await canLaunch(url)) {
                                                                    await launch(url);
                                                                  } else {
                                                                    throw 'Could not launch $url';
                                                                  }
                                                                },
                                                                child: Container(
                                                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                                                  child: Text(
                                                                    data.WebLink,
                                                                    style: TextStyle(
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight.bold,
                                                                        color: Colors.black),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  });
                                            });
                                      },
                                      child: Container(
                                        height: MediaQuery.of(context).size.height * 0.86,
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                          child: CachedNetworkImage(
                                            fit: BoxFit.contain,
                                            imageUrl: RestDatasource.Sponser_IMAGE_URL + data.ImageUrl,
                                            errorWidget:
                                                (context, url, error) =>
                                                Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ).toList(),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  void logout() async
  {
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
