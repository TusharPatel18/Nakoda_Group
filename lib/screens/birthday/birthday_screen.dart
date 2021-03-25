import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nakoda_group/data/rest_ds.dart';
import 'package:nakoda_group/models/birthday.dart';
import 'package:nakoda_group/utils/connectionStatusSingleton.dart';
import 'package:nakoda_group/utils/internetconnection.dart';
import 'package:nakoda_group/utils/network_util.dart';

class BirthdayScreen extends StatefulWidget {
  @override
  _BirthdayScreenState createState() => _BirthdayScreenState();
}

class _BirthdayScreenState extends State<BirthdayScreen> {
  NetworkUtil _netUtil = new NetworkUtil();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey1 =
      new GlobalKey<RefreshIndicatorState>();
  Future<List<Birthday>> userdata;
  Future<List<Birthday>> userfilterData;
  TextEditingController _searchQueryUser;
  bool _isSearchingUser = false;
  String searchQueryUser = "Search query";
  DateTime date = DateTime.now();

  _loadPref() async {
    setState(() {
      userdata = _getUserData();
      userfilterData = userdata;
    });
  }

  Future<List<Birthday>> _refresh1() async {
    setState(() {
      userdata = _getUserData();
      userfilterData = userdata;
    });
  }

  Future<List<Birthday>> _getUserData() async {
    return _netUtil.post(RestDatasource.GET_BIRTHDAY_URL).then((dynamic res) {
      final items = res.cast<Map<String, dynamic>>();
      List<Birthday> listofusers = items.map<Birthday>((json) {
        return Birthday.fromJson(json);
      }).toList();
      List<Birthday> revdata = listofusers.reversed.toList();
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
      userfilterData = userdata;
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
        Future<List<Birthday>> items = userdata;
        List<Birthday> filter = new List<Birthday>();
        items.then((result) {
          for (var record in result) {
            if (record.FirstName.toLowerCase()
                    .toString()
                    .contains(searchQueryUser.toLowerCase()) ||
                record.Mobile1.toLowerCase()
                    .toString()
                    .contains(searchQueryUser.toLowerCase())) {
              print(record.FirstName);
              filter.add(record);
            }
          }
          userfilterData = Future.value(filter);
        });
      } else {
        userfilterData = userdata;
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
                      text: "Birthday",
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
          child: FutureBuilder<List<Birthday>>(
            future: userfilterData,
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
                      (data) => Card(
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
                                        (data.FirstName == null ||
                                                data.FirstName == "")
                                            ? "-"
                                            : data.FirstName.toUpperCase() +
                                                " " +
                                                data.MiddleName.toUpperCase() +
                                                " " +
                                                data.LastGautra.toUpperCase(),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18.0),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Icon(Icons.cake,
                                              color: Colors.orange, size: 20),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            date.day.toString() +
                                                "/" +
                                                date.month.toString() +
                                                "/" +
                                                date.year.toString(),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15.0),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  _divider(),
                                ],
                              ),
                              subtitle: Column(
                                children: <Widget>[
                                  new Row(
                                    children: <Widget>[
                                      Container(
                                        height: 120,
                                        width: 120,
                                        child: (data.Photo == null ||
                                                data.Photo == "")
                                            ? new Center(
                                                child: new Text(
                                                  (data.FirstName == null ||
                                                          data.FirstName == "")
                                                      ? "No Image"
                                                      : data.FirstName[0],
                                                  style:
                                                      TextStyle(fontSize: 25),
                                                ),
                                              )
                                            : new Image(
                                                image: NetworkImage(
                                                    'http://www.michannel.in/demo/nakoda/uploads/membership/' +
                                                        data.Photo),
                                                fit: BoxFit.fill,
                                              ),
                                      ),
                                      SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 3),
                                            child: Container(
                                              width: 250,
                                              height: 40,
                                              color: Colors.green,
                                              child: FlatButton(
                                                child: Text(
                                                  'Call',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                onPressed: () {},
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 3),
                                            child: Container(
                                              width: 250,
                                              height: 40,
                                              color: Colors.blue,
                                              child: FlatButton(
                                                child: Text(
                                                  'Message',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                onPressed: () {},
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 3),
                                            child: Container(
                                              width: 250,
                                              height: 40,
                                              color: Colors.redAccent,
                                              child: FlatButton(
                                                child: Text(
                                                  'Email',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                onPressed: () {},
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
                    ).toList(),
              );
            },
          ),
        ),
      );
    }
  }
}
