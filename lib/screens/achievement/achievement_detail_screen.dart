import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nakoda_group/data/rest_ds.dart';
import 'package:nakoda_group/utils/connectionStatusSingleton.dart';
import 'package:nakoda_group/utils/flash_helper.dart';
import 'package:nakoda_group/utils/internetconnection.dart';
import 'package:nakoda_group/utils/network_util.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AchievementDetailScreen extends StatefulWidget {
  @override
  _AchievementDetailScreenState createState() =>
      _AchievementDetailScreenState();
}

class _AchievementDetailScreenState extends State<AchievementDetailScreen> {
  NetworkUtil _netUtil = new NetworkUtil();
  BuildContext _ctx;
  bool _isdataLoading = true;
  bool _isLoadingDelete = false;
  bool _isLoadingUpdate = false;
  String AchivmentId, Title, Category, Remark, ImageUrl, AddedOn;

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
  }

  void connectionChanged(dynamic hasConnection) {
    setState(() {
      isOffline = !hasConnection;
      //print(isOffline);
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _ctx = context;
      final Map arguments = ModalRoute.of(_ctx).settings.arguments as Map;
      if (arguments != null) {
        AchivmentId = arguments['AchivmentId'];
        Title = arguments['Title'];
        Category = arguments['Category'];
        Remark = arguments['Remark'];
        ImageUrl = arguments['ImageUrl'];
        AddedOn = arguments['AddedOn'];
      }
    });
    if (isOffline) {
      return connection.nointernetconnection();
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(Title),
        ),
        body: Container(
          child: ListView(
            children: <Widget>[
              new Center(
                child: new Column(
                  children: <Widget>[
                    Card(
                      semanticContainer: true,
                      elevation: 5,
                      margin: new EdgeInsets.all(5),
                      child: new Column(
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          new Container(
                            margin: EdgeInsets.only(left: 100, right: 100),
                            child: Column(
                              children: <Widget>[
                                new Container(
                                  width: 500,
                                  height: 200,
                                  child: (ImageUrl == null || ImageUrl == "")
                                      ? new Text(
                                          Title[0].toUpperCase(),
                                          style: new TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 50,
                                          ),
                                        )
                                      : Image(
                                          image: NetworkImage(
                                              RestDatasource.Achievement_IMAGE_URL +
                                                  ImageUrl),
                                          fit: BoxFit.fill,
                                        ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                elevation: 5,
                margin: new EdgeInsets.all(5),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new ListTile(
                      title: new Text(
                        'ACHIEVEMENT DETAILS',
                        style: new TextStyle(fontSize: 18),
                      ),
                    ),
                    Divider(
                      thickness: 2,
                      indent: 5,
                      endIndent: 5,
                    ),
                    new ListTile(
                      title: new Text(
                        (Category == null || Category == "") ? "-" : Category,
                        style: new TextStyle(fontSize: 18),
                      ),
                      subtitle: new Text('Category'),
                    ),
                    new ListTile(
                      title: new Text(
                        (Remark == null || Remark == "")
                            ? "-"
                            : Remark.toUpperCase(),
                        style: new TextStyle(fontSize: 16),
                      ),
                      subtitle: new Text('Remark'),
                    ),
                    new ListTile(
                      title: new Text(
                        AddedOn,
                        style: new TextStyle(fontSize: 16),
                      ),
                      subtitle: new Text('Date-Time'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
