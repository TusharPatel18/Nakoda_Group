import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nakoda_group/data/rest_ds.dart';
import 'package:nakoda_group/utils/connectionStatusSingleton.dart';
import 'package:nakoda_group/utils/flash_helper.dart';
import 'package:nakoda_group/utils/internetconnection.dart';
import 'package:nakoda_group/utils/network_util.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class NewsDetailScreen extends StatefulWidget {
  @override
  _NewsDetailScreenState createState() => _NewsDetailScreenState();
}
 
class _NewsDetailScreenState extends State<NewsDetailScreen> {

  NetworkUtil _netUtil = new NetworkUtil();
  BuildContext _ctx;
  bool _isdataLoading=true;
  bool _isLoadingDelete=false;
  bool _isLoadingUpdate=false;
  String NewsId,Title,Remark,AddedOn,ImageUrl,Type;

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
        NewsId  = arguments['NewsId'];
        Title   = arguments['Title'];
        Remark   =arguments['Remark'];
        AddedOn  =arguments['AddedOn'];
        ImageUrl  =arguments['ImageUrl'];
        Type     = arguments['Type'];
      }
    });
    if (isOffline) {
      return connection.nointernetconnection();
    } else {
      return Scaffold(
        appBar: AppBar(
          title: new Text(Title.toUpperCase()),),
        body: ListView(
          children: <Widget>[
            new Column(
              children: <Widget>[
                SizedBox(height: 5,),
                new Card(
                  elevation: 5,
                  margin: EdgeInsets.only(left: 10,right: 10,bottom: 10),
                  child: Column(
                    children: <Widget>[
                      Container(
                          height: 200,
                          width: 500,
                          child:(ImageUrl == null || ImageUrl == "") ? new Text(Title[0].toUpperCase(),style: new TextStyle(
                            fontWeight: FontWeight.bold,fontSize: 50,
                          ),) : Image(image: NetworkImage(RestDatasource.NEWS_URL + ImageUrl),fit: BoxFit.fill,)
                      ),
                    ],
                  ),
                ),
                new Card(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      new Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.all(10),
                        child: new Text('DESCRIPTION',style: TextStyle(fontSize: 18),),
                      ),
                      new Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.all(10),
                        child: new Text(Remark,style: TextStyle(fontSize: 15),),
                      ),
                      new Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.all(10),
                        child: new Text("( "+Type+" )",style: TextStyle(fontSize: 15),),
                      ),
                      new Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.all(10),
                        child: new Text("( "+AddedOn+" )",style: TextStyle(fontSize: 15),),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        )
      );
    }
  }
}
