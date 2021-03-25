import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nakoda_group/utils/connectionStatusSingleton.dart';
import 'package:nakoda_group/utils/internetconnection.dart';
import 'package:nakoda_group/utils/network_util.dart';

class JobDetailScreen extends StatefulWidget {
  @override
  _JobDetailScreenState createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  // NetworkUtil _netUtil = new NetworkUtil();
  BuildContext _ctx;
  bool _isdataLoading = true;
  bool _isLoadingDelete = false;
  bool _isLoadingUpdate = false;
  String JobId, CompanyName, EmailId, Title, ContactNumber, Remark;

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
        JobId = arguments['JobId'];
        Title = arguments['Title'];
        CompanyName = arguments['CompanyName'];
        Remark = arguments['Remark'];
        ContactNumber = arguments['ContactNumber'];
        EmailId = arguments['EmailId'];
      }
    });
    if (isOffline) {
      return connection.nointernetconnection();
    } else {
      return Scaffold(
        appBar: AppBar(
          title: new Text(
            CompanyName.toUpperCase(),
            style: TextStyle(fontSize: 17),
          ),
        ),
        body: Container(
          child: ListView(
            children: <Widget>[
              Card(
                elevation: 5,
                margin: new EdgeInsets.all(5),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new ListTile(
                      title: new Text(
                        'JOB DESCRIPTION',
                        style: new TextStyle(fontSize: 16),
                      ),
                    ),
                    Divider(
                      thickness: 2,
                      indent: 10,
                      endIndent: 10,
                    ),
                    new ListTile(
                      title: new Text(
                        (Title == null || Title == "")
                            ? "-"
                            : Title.toUpperCase(),
                        style: new TextStyle(fontSize: 15),
                      ),
                      subtitle: new Text('Post'),
                    ),
                    new ListTile(
                      title: new Text(
                        (Remark == null || Remark == "")
                            ? "-"
                            : Remark.toUpperCase(),
                        style: new TextStyle(fontSize: 15),
                      ),
                      subtitle: new Text('Remark'),
                    ),
                    new ListTile(
                      title: new Text(
                        (EmailId == null || EmailId == "")
                            ? "-"
                            : EmailId.toUpperCase(),
                        style: new TextStyle(fontSize: 15),
                      ),
                      subtitle: new Text('Email Id'),
                    ),
                    new ListTile(
                      title: new Text(
                        (ContactNumber == null || ContactNumber == "")
                            ? "-"
                            : ContactNumber,
                        style: new TextStyle(fontSize: 15),
                      ),
                      subtitle: new Text('Phone Number'),
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
