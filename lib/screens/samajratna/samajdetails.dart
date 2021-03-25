import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nakoda_group/data/rest_ds.dart';
import 'package:nakoda_group/utils/connectionStatusSingleton.dart';
import 'package:nakoda_group/utils/flash_helper.dart';
import 'package:nakoda_group/utils/internetconnection.dart';
import 'package:nakoda_group/utils/network_util.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class SamajDetailScreen extends StatefulWidget {
  @override
  _SamajDetailScreenState createState() => _SamajDetailScreenState();
}

class _SamajDetailScreenState extends State<SamajDetailScreen> {
  NetworkUtil _netUtil = new NetworkUtil();
  BuildContext _ctx;
  bool _isdataLoading = true;
  bool _isLoadingDelete = false;
  bool _isLoadingUpdate = false;
  String SamajId, Name, ImageUrl, Achivment, Story;

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
        SamajId = arguments['SamajId'];
        Name = arguments['Name'];
        ImageUrl = arguments['ImageUrl'];
        Achivment = arguments['Achivment'];
        Story = arguments['Story'];
      }
    });
    if (isOffline) {
      return connection.nointernetconnection();
    } else {
      return Scaffold(
        appBar: AppBar(
          title:
              new Text((Name == null || Name == "") ? "-" : Name.toUpperCase()),
        ),
        body: Container(
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 5,
              ),
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
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: <Widget>[
                                new CircleAvatar(
                                  child: (ImageUrl == null || ImageUrl == "")
                                      ? CircleAvatar(
                                          radius: 80,
                                          child: new Text(
                                            Name[0].toUpperCase(),
                                            style: new TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 50,
                                            ),
                                          ),
                                          backgroundColor: Colors.red.shade100,
                                        )
                                      : CircleAvatar(
                                          radius: 95,
                                          backgroundImage: NetworkImage(
                                              'https://karoninfotech.com/demo/nakoda/uploads/samaj/' +
                                                  ImageUrl)),
                                  radius: 85,
                                  backgroundColor: Color(0xFFF44336),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  (Name == null) ? "-" : Name.toUpperCase(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w100),
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
                        (Achivment == null || Achivment == "")
                            ? "-"
                            : Achivment.toUpperCase(),
                        style: new TextStyle(fontSize: 20),
                      ),
                    ),
                    Divider(
                      thickness: 2,
                      indent: 5,
                      endIndent: 5,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 15, right: 5, bottom: 20),
                      child: Text(
                        Story,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    )
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
