import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nakoda_group/data/rest_ds.dart';
import 'package:nakoda_group/models/photolist.dart';
import 'package:nakoda_group/utils/connectionStatusSingleton.dart';
import 'package:nakoda_group/utils/internetconnection.dart';
import 'package:nakoda_group/utils/network_util.dart';

class PhotoScreen extends StatefulWidget {
  @override
  _PhotoScreenState createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {

  NetworkUtil _netUtil = new NetworkUtil();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey1 =
      new GlobalKey<RefreshIndicatorState>();

  BuildContext _ctx;
  String CategoryId;
  bool _isdataLoading = true;

  Future<List<PhotoList>> userdata;


  _loadPref() async {
    setState(() {
      userdata = _getUserData();

    });
  }

  Future<List<PhotoList>> _refresh1() async {
    setState(() {
      userdata = _getUserData();
    });
  }

  Future<List<PhotoList>> _getUserData() async {
    return _netUtil.post(RestDatasource.URL_GET_PHOTO,body: {
      "CategoryId" : CategoryId.toString()
    }).then((dynamic res) {
      final items = res.cast<Map<String, dynamic>>();
      List<PhotoList> listofusers = items.map<PhotoList>((json) {
        return PhotoList.fromJson(json);
      }).toList();
      List<PhotoList> revdata = listofusers.reversed.toList();
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
      setState(() {
        _ctx = context;
        final Map arguments = ModalRoute.of(_ctx).settings.arguments as Map;
        if (arguments != null) {
          CategoryId = arguments['CategoryId'];
          _isdataLoading = false;
          _loadPref();
        }
      });
      return Scaffold(
        appBar: AppBar(
          title: Text("Photos"),
        ),
        body: (_isdataLoading)
            ?  new Center(
          child: CircularProgressIndicator(),
             )
            :
        Container(
          margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: new RefreshIndicator(
                    key: _refreshIndicatorKey1,
                    onRefresh: _refresh1,
                    child: FutureBuilder<List<PhotoList>>(
                      future: userdata,
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
                        return GridView.count(
                          crossAxisCount: 2,
                          children: snapshot.data
                              .map(
                                (data) => Container(
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                          "/photodetails",
                                          arguments: {
                                            "GalleryId": data.GalleryId,
                                            "Title": data.Title,
                                            "ImageUrl": data.ImageUrl,
                                          });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              RestDatasource.IMAGE_URL +
                                                  data.ImageUrl),
                                        ),
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
        ),
      );
    }
  }
}
