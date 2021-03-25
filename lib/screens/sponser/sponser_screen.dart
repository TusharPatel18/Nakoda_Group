import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nakoda_group/data/rest_ds.dart';
import 'package:nakoda_group/models/sponser.dart';
import 'package:nakoda_group/utils/connectionStatusSingleton.dart';
import 'package:nakoda_group/utils/internetconnection.dart';
import 'package:nakoda_group/utils/network_util.dart';
import 'package:url_launcher/url_launcher.dart';

class SponserScreen extends StatefulWidget {
  @override
  _SponserScreenState createState() => _SponserScreenState();
}

class _SponserScreenState extends State<SponserScreen> {
  NetworkUtil _netUtil = new NetworkUtil();
  BuildContext _ctx;
  bool isOffline = false;
  InternetConnection connection = new InternetConnection();
  StreamSubscription _connectionChangeStream;

  Future<List<SponserList>> sponserdata;

  _loadPref() async {
    setState(() {
      sponserdata = _getSponserData();
    });
  }

  Future<List<SponserList>> _getSponserData() async {
    return _netUtil.post(RestDatasource.GET_DASHBOARD_SPONSER,).then((dynamic res) {
      final items = res.cast<Map<String, dynamic>>();
      List<SponserList> listofusers = items.map<SponserList>((json) {
        return SponserList.fromJson(json);
      }).toList();
      List<SponserList> revdata = listofusers.reversed.toList();
      return revdata;
    });
  }

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
    }
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            InkWell(
              onTap: (){
                Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
              },
              child: Container(
                alignment: Alignment.topRight,
                margin: EdgeInsets.fromLTRB(0, 30, 20, 0),
                child: Chip(
                  labelPadding: EdgeInsets.all(2.0),
                  label: Text(
                    "Skip",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  backgroundColor: Colors.grey[300],
                  elevation: 6.0,
                  shadowColor: Colors.grey[60],
                  padding: EdgeInsets.all(8.0),
                ),
              ),
            ),
            FutureBuilder<List<SponserList>>(
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
                                                      "Contact Us",
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.bold,color: Colors.white,fontSize: 17,),
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
                            height: MediaQuery.of(context).size.height * 0.8,
                            child: CachedNetworkImage(
                              fit: BoxFit.contain,
                              imageUrl:
                              RestDatasource.Sponser_IMAGE_URL +
                                  data.ImageUrl,
                              // placeholder: (context, url) =>
                              //     CircularProgressIndicator(),
                              errorWidget:
                                  (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                        ),
                  ).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}