import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nakoda_group/data/rest_ds.dart';
import 'package:nakoda_group/models/achievement.dart';
import 'package:nakoda_group/utils/connectionStatusSingleton.dart';
import 'package:nakoda_group/utils/internetconnection.dart';
import 'package:nakoda_group/utils/network_util.dart';

class AchievementScreen extends StatefulWidget {
  @override
  _AchievementScreenState createState() => _AchievementScreenState();
}

class _AchievementScreenState extends State<AchievementScreen> {
  NetworkUtil _netUtil = new NetworkUtil();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey1 =
      new GlobalKey<RefreshIndicatorState>();
  Future<List<Achievement>> achievementdata;
  Future<List<Achievement>> achievementfilterdata;
  TextEditingController _searchQueryUser;
  bool _isSearchingUser = false;
  String searchQueryUser = "Search query";

  _loadPref() async {
    setState(() {
      achievementdata = _getUserData("user");
      achievementfilterdata = achievementdata;
    });
  }

  Future<List<Achievement>> _refresh1() async {
    setState(() {
      achievementdata = _getUserData("user");
      achievementfilterdata = achievementdata;
    });
  }

  Future<List<Achievement>> _getUserData(String usertype) async {
    return _netUtil.post(RestDatasource.URL_ACHIEVEMENT_LIST,
        body: {"usertype": usertype}).then((dynamic res) {
      final items = res.cast<Map<String, dynamic>>();
      List<Achievement> listofusers = items.map<Achievement>((json) {
        return Achievement.fromJson(json);
      }).toList();
      List<Achievement> revdata = listofusers.reversed.toList();
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
    _searchQueryUser = new TextEditingController();
  }

  void connectionChanged(dynamic hasConnection) {
    setState(() {
      isOffline = !hasConnection;
      //print(isOffline);
    });
  }

  Widget _buildSearchField() {
    return new TextField(
      controller: _searchQueryUser,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: 'Search...',
        border: InputBorder.none,
        hintStyle: const TextStyle(color: Colors.white),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: updateSearchQuery,
    );
  }

  List<Widget> _buildActions() {
    if (_isSearchingUser) {
      return <Widget>[
        new IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (_searchQueryUser == null || _searchQueryUser.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }
    return <Widget>[
      new IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      ),
    ];
  }

  void _clearSearchQuery() {
    //print("close search box");
    setState(() {
      _searchQueryUser.clear();
      achievementfilterdata = achievementdata;
      updateSearchQuery("");
    });
  }

  void _startSearch() {
    //print("open search box");
    ModalRoute.of(context)
        .addLocalHistoryEntry(new LocalHistoryEntry(onRemove: _stopSearching));
    setState(() {
      _isSearchingUser = true;
    });
  }

  void _stopSearching() {
    _clearSearchQuery();
    setState(() {
      _isSearchingUser = false;
    });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQueryUser = newQuery;
      if (_searchQueryUser.toString().length > 0) {
        //print(searchQuery.toString().length);
        Future<List<Achievement>> items = achievementdata;
        List<Achievement> filter = new List<Achievement>();
        items.then((result) {
          for (var record in result) {
            if (record.Title.toLowerCase()
                    .toString()
                    .contains(searchQueryUser.toLowerCase()) ||
                record.Category.toLowerCase()
                    .toString()
                    .contains(searchQueryUser.toLowerCase())) {
              print(record.Title);
              filter.add(record);
            }
          }
          achievementfilterdata = Future.value(filter);
        });
      } else {
        achievementfilterdata = achievementdata;
      }
    });
    print("search query1 " + newQuery);
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isOffline) {
      return connection.nointernetconnection();
    } else {
      return Scaffold(
        appBar: AppBar(
          title: _isSearchingUser
              ? _buildSearchField()
              : RichText(
                  text: TextSpan(
                      text: "Achievements",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      children: [
                        TextSpan(
                            text: "",
                            style: TextStyle(color: Colors.blue, fontSize: 15))
                      ]),
                ),
          actions: _buildActions(),
        ),
        body: new RefreshIndicator(
          key: _refreshIndicatorKey1,
          onRefresh: _refresh1,
          child: FutureBuilder<List<Achievement>>(
            future: achievementfilterdata,
            builder: (context, snapshot) {
              //print(snapshot.data);
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
                padding: EdgeInsets.only(bottom: 70.0),
                children: snapshot.data
                    .map(
                      (data) => InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed("/achievementdetails", arguments: {
                            "AchivmentId": data.AchivmentId,
                            "Title": data.Title,
                            "Category": data.Category,
                            "Remark": data.Remark,
                            "ImageUrl": data.ImageUrl,
                            "AddedOn": data.AddedOn,
                          });
                        },
                        child: Card(
                            elevation: 8.0,
                            margin: new EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 5.0),
                            child: Container(
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 5.0),
                                title: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          (data.Title == null ||
                                                  data.Title == "")
                                              ? "-"
                                              : data.Title.toUpperCase(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18.0),
                                        ),
                                      ],
                                    ),
                                    _divider(),
                                  ],
                                ),
                                subtitle: Column(
                                  children: <Widget>[
                                    new Column(
                                      children: <Widget>[
                                        Container(
                                          height: 150,
                                          width: 400,
                                          child: (data.ImageUrl == null ||
                                                  data.ImageUrl == "")
                                              ? new Center(
                                                  child: new Text(
                                                    (data.Title == null || data.Title == "")
                                                        ? "No Image"
                                                        : data.Title[0],
                                                    style:
                                                        TextStyle(fontSize: 25),
                                                  ),
                                                )
                                              : new Image(
                                                  image: NetworkImage(
                                                      RestDatasource.Achievement_IMAGE_URL + data.ImageUrl),
                                                  fit: BoxFit.contain,
                                                ),
                                        ),
                                        SizedBox(width: 10),
                                        Container(
                                          width: 500,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 3),
                                                child: Text(
                                                  data.Category,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black),
                                                ),
                                              ),
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 3),
                                                  child: Container(
                                                    width: 500,
                                                    child: Text(
                                                      data.Remark,
                                                      maxLines: 5,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  )),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )),
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

//Container(
//width: 250,
//child: Text(
//data.Remark,
//maxLines: 5,
//overflow: TextOverflow.ellipsis,
//style: TextStyle(
//fontSize: 14,
//),
//),
//)
