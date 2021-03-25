import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:nakoda_group/data/rest_ds.dart';
import 'package:nakoda_group/utils/connectionStatusSingleton.dart';
import 'package:nakoda_group/utils/internetconnection.dart';
import 'package:nakoda_group/utils/network_util.dart';

 
class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  BuildContext _ctx;
  NetworkUtil _netUtil = new NetworkUtil();
  bool isOffline = false;
  bool _isDataLoading = false;
  InternetConnection connection = new InternetConnection();
  StreamSubscription _connectionChangeStream;
  String AboutText = "";

  _loadPref() async {
    _netUtil.post(RestDatasource.URL_GET_ABOUT)
        .then((dynamic res) async{
          setState(() {
            AboutText = res[0]["AboutText"];
            _isDataLoading = true;
          });
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
    if (isOffline) {
      return connection.nointernetconnection();
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('About'),
        ),
        body: (_isDataLoading == false)
            ? new Center(
          child: CircularProgressIndicator(),
        ) : Container(
          margin: EdgeInsets.only(top: 30),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: HtmlWidget(AboutText,),
          ),
        ),
      );
    }
  }
}
