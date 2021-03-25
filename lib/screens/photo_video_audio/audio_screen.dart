import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nakoda_group/data/rest_ds.dart';
import 'package:nakoda_group/models/audiolist.dart';
import 'package:nakoda_group/utils/connectionStatusSingleton.dart';
import 'package:nakoda_group/utils/internetconnection.dart';
import 'package:nakoda_group/utils/network_util.dart';

class AudioScreen extends StatefulWidget {
  @override
  _AudioScreenState createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  NetworkUtil _netUtil = new NetworkUtil();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey1 =
      new GlobalKey<RefreshIndicatorState>();
  Future<List<AudioList>> userdata;
  Future<List<AudioList>> userfilterData;
  bool _isdataLoading = true;

  BuildContext _ctx;
  String CategoryId;

  _loadPref() async {
    setState(() {
      userdata = _getUserData();
      userfilterData = userdata;
    });
  }

  Future<List<AudioList>> _refresh1() async {
    setState(() {
      userdata = _getUserData();
      userfilterData = userdata;
    });
  }

  Future<List<AudioList>> _getUserData() async {
    return _netUtil.post(RestDatasource.URL_GET_AUDIO,body: {
      "CategoryId" : CategoryId.toString()
    }).then((dynamic res) {
      final items = res.cast<Map<String, dynamic>>();
      List<AudioList> listofusers = items.map<AudioList>((json) {
        return AudioList.fromJson(json);
      }).toList();
      List<AudioList> revdata = listofusers.reversed.toList();
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
    setState(() {
      _isdataLoading = false;
    });
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
          title: Text("Audio"),
        ),
        body:  (_isdataLoading)
            ?  new Center(
          child: CircularProgressIndicator(),
        ) :
        new RefreshIndicator(
          key: _refreshIndicatorKey1,
          onRefresh: _refresh1,
          child: FutureBuilder<List<AudioList>>(
            future: userfilterData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (!snapshot.hasData) {
                return Center(
                  child: Text("No Data Available!"),
                );
              }
              return ListView(
                padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                shrinkWrap: true,
                children: snapshot.data
                    .map(
                      (data) => Card(
                        elevation: 8.0,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed("/audiodetails", arguments: {
                              "AudioUrl": data.AudioUrl,
                              "Title": data.Title,
                            });
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child: Icon(
                                    Icons.audiotrack,
                                    color: Color(0xFFF44336),
                                    size: 35,
                                  ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
                                    child: Text(data.Title,
                                        style: TextStyle(
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                  ),
                                  Container(
                                      margin: EdgeInsets.fromLTRB(0, 0, 10, 10),
                                      child: Icon(
                                        Icons.arrow_forward,
                                        color: Colors.red.shade400,
                                        size: 30,
                                      ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ),
      );
    }
  }
}
