import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nakoda_group/data/rest_ds.dart';
import 'package:nakoda_group/models/category.dart';
import 'package:nakoda_group/utils/connectionStatusSingleton.dart';
import 'package:nakoda_group/utils/internetconnection.dart';
import 'package:nakoda_group/utils/network_util.dart';

class VideoCategory extends StatefulWidget {
  @override
  _VideoCategoryState createState() => _VideoCategoryState();
}

class _VideoCategoryState extends State<VideoCategory> {
  NetworkUtil _netUtil = new NetworkUtil();
  Future<List<CategoryList>> categorydata;


  _loadPref() async {
    setState(() {
      categorydata = _getCategoryData();
    });
  }

  Future<List<CategoryList>> _getCategoryData() async {
    return _netUtil.post(RestDatasource.URL_GET_CATEGORY_TYPE,
        body: {
          "CategoryType" : "video"
        }).then((dynamic res) {
      final items = res.cast<Map<String, dynamic>>();
      List<CategoryList> listofusers = items.map<CategoryList>((json) {
        return CategoryList.fromJson(json);
      }).toList();
      List<CategoryList> revdata = listofusers.reversed.toList();
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
    if (isOffline) {
      return connection.nointernetconnection();
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text("Video Category"),
        ),
        body: Container(
          margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Column(
            children: [
              Expanded(
                child: FutureBuilder<List<CategoryList>>(
                  future: categorydata,
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
                              Navigator.of(context).pushNamed("/video",
                                  arguments: {
                                    "CategoryId": data.CategoryId,
                                  });
                            },
                            child: Card(
                              elevation: 3.0,
                              margin: new EdgeInsets.fromLTRB(5, 5, 5, 60),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.fromLTRB(20, 20, 10, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(Icons.video_library,color: Color(0xFFF44336),size: 35,),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(data.CategoryName,
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
                      ).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
