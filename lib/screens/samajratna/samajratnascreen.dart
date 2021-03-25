import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nakoda_group/data/rest_ds.dart';
import 'package:nakoda_group/models/samajratna.dart';
import 'package:nakoda_group/utils/connectionStatusSingleton.dart';
import 'package:nakoda_group/utils/internetconnection.dart';
import 'package:nakoda_group/utils/network_util.dart';

class SamajRatnaScreen extends StatefulWidget {
  @override
  _SamajRatnaScreenState createState() => _SamajRatnaScreenState();
}

class _SamajRatnaScreenState extends State<SamajRatnaScreen> {
  NetworkUtil _netUtil = new NetworkUtil();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey1 =
      new GlobalKey<RefreshIndicatorState>();
  Future<List<SamajRatna>> samajdata;
  Future<List<SamajRatna>> samajfilterData;
  TextEditingController _searchQueryUser;
  bool _isSearchingUser = false;
  String searchQueryUser = "Search query";

  _loadPref() async {
    setState(() {
      samajdata = _getUserData("user");
      samajfilterData = samajdata;
    });
  }

  Future<List<SamajRatna>> _refresh1() async {
    setState(() {
      samajdata = _getUserData("user");
      samajfilterData = samajdata;
    });
  }

  Future<List<SamajRatna>> _getUserData(String usertype) async {
    return _netUtil.post(RestDatasource.GET_SAMAJRATNA_URL,
        body: {"usertype": usertype}).then((dynamic res) {
      final items = res.cast<Map<String, dynamic>>();
      List<SamajRatna> listofusers = items.map<SamajRatna>((json) {
        return SamajRatna.fromJson(json);
      }).toList();
      List<SamajRatna> revdata = listofusers.reversed.toList();
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
      samajfilterData = samajdata;
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
        Future<List<SamajRatna>> items = samajdata;
        List<SamajRatna> filter = new List<SamajRatna>();
        items.then((result) {
          for (var record in result) {
            if (record.Name.toLowerCase()
                    .toString()
                    .contains(searchQueryUser.toLowerCase()) ||
                record.Achivment.toLowerCase()
                    .toString()
                    .contains(searchQueryUser.toLowerCase())) {
              print(record.Name);
              filter.add(record);
            }
          }
          samajfilterData = Future.value(filter);
        });
      } else {
        samajfilterData = samajdata;
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
                      text: "Samaj Ratna",
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
          child: FutureBuilder<List<SamajRatna>>(
            future: samajfilterData,
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
                              .pushNamed("/samajratnadetails", arguments: {
                            "SamajId": data.SamajId,
                            "ImageUrl": data.ImageUrl,
                            "Achivment": data.Achivment,
                            "Story": data.Story,
                            "Name": data.Name,
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
                              subtitle: Column(
                                children: <Widget>[
                                  new Row(
                                    children: <Widget>[
                                      (data.ImageUrl == null ||
                                              data.ImageUrl == "")
                                          ? CircleAvatar(
                                              radius: 30,
                                              child: new Text(
                                                data.Name[0].toUpperCase(),
                                                style: new TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFFF44336)),
                                              ),
                                              backgroundColor:
                                                  Colors.red.shade100,
                                            )
                                          : CircleAvatar(
                                              radius: 50,
                                              backgroundImage: NetworkImage(
                                                  'http://www.michannel.in/demo/nakoda/uploads/samaj/' +
                                                      data.ImageUrl),
                                            ),
                                      SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 3),
                                            child: Text(
                                              data.Name.toUpperCase(),
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16.0,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 3),
                                            child: Text(
                                              data.Achivment.toUpperCase(),
                                              style: TextStyle(
                                                color: Color(0xFF424242),
                                                fontSize: 13.0,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 3),
                                            child: Container(
                                              width: 260,
                                              child: Text(
                                                data.Story,
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
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
