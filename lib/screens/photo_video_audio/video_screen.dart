import 'dart:async';
import 'dart:io';

import 'package:add_thumbnail/thumbnail_list_vew.dart';
import 'package:flutter/material.dart';
import 'package:nakoda_group/data/rest_ds.dart';
import 'package:nakoda_group/models/videolist.dart';
import 'package:nakoda_group/utils/connectionStatusSingleton.dart';
import 'package:nakoda_group/utils/internetconnection.dart';
import 'package:nakoda_group/utils/network_util.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoScreen extends StatefulWidget {
  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  NetworkUtil _netUtil = new NetworkUtil();
  bool _isdataLoading = true;
  List<String> urlList = [];
  BuildContext _ctx;
  String  CategoryId;

  _loadPref() async {
    urlList.clear();
    _netUtil.post(RestDatasource.URL_GET_VIDEO,body: {
      "CategoryId" : CategoryId.toString()
    }).then((dynamic res) {
      urlList.add("https://www.youtube.com/watch?v=${res[0]["VideoUrl"]}");
      // print(urlList);
      // print(res[0]["VideoUrl"]);
      // for (var rowData in res)
      // {
      //   print(rowData);
      //   urlList.add("https://www.youtube.com/watch?v=" + rowData["VideoUrl"]);
      // }
      setState(() {
        _isdataLoading = false;
      });
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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _onload();
      _loadPref();
    });
  }

  _onload(){
    setState(() {
      _ctx = context;
      final Map arguments = ModalRoute.of(_ctx).settings.arguments as Map;
      if (arguments != null) {
        CategoryId = arguments['CategoryId'];
        _isdataLoading = false;
      }
    });
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
          title: Text("Videos"),
        ),
        body:  (_isdataLoading) ?
            new Center(
              child: CircularProgressIndicator(),
                 )
            : MediaQuery.removePadding(
          context: context,
          removeTop: true,
          removeLeft: true,
          removeRight: true,
          removeBottom: true,
          child: MediaListView(
            titleTextStyle: TextStyle(color:Colors.black),
            urls: urlList,
            onPressed: (urls) {
              _launchURL(urls);
            },
          ),
        ),
      );
    }
  }

  _launchURL(String urldata) async {
    if (Platform.isIOS) {
      if (await canLaunch(urldata)) {
        await launch(urldata, forceSafariVC: false);
      } else {
        if (await canLaunch(urldata)) {
          await launch(urldata);
        } else {
          throw 'Could not launch https://www.youtube.com/channel/UCwXdFgeE9KYzlDdR7TG9cMw';
        }
      }
    } else {
      // const url = 'https://www.youtube.com/channel/UCwXdFgeE9KYzlDdR7TG9cMw';
      if (await canLaunch(urldata)) {
        await launch(urldata);
      } else {
        throw 'Could not launch $urldata';
      }
    }
  }
}
