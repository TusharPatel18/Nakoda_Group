import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nakoda_group/data/rest_ds.dart';
import 'package:nakoda_group/models/job.dart';
import 'package:nakoda_group/utils/connectionStatusSingleton.dart';
import 'package:nakoda_group/utils/internetconnection.dart';
import 'package:nakoda_group/utils/network_util.dart';

class JobsListScreen extends StatefulWidget {
  @override
  _JobsListScreenState createState() => _JobsListScreenState();
}

class _JobsListScreenState extends State<JobsListScreen> {
  NetworkUtil _netUtil = new NetworkUtil();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey1 =
      new GlobalKey<RefreshIndicatorState>();
  Future<List<Job>> jobdata;
  Future<List<Job>> jobfilterData;
  TextEditingController _searchQueryUser;
  bool _isSearchingUser = false;
  String searchQueryUser = "Search query";

  _loadPref() async {
    setState(() {
      jobdata = _getUserData("user");
      jobfilterData = jobdata;
    });
  }

  Future<List<Job>> _refresh1() async {
    setState(() {
      jobdata = _getUserData("user");
      jobfilterData = jobdata;
    });
  }

  Future<List<Job>> _getUserData(String usertype) async {
    return _netUtil.post(RestDatasource.GET_JOBS_URL,
        body: {"Job": usertype}).then((dynamic res) {
      final items = res.cast<Map<String, dynamic>>();
      List<Job> listofusers = items.map<Job>((json) {
        return Job.fromJson(json);
      }).toList();
      List<Job> revdata = listofusers.reversed.toList();
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
      jobfilterData = jobdata;
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
        Future<List<Job>> items = jobdata;
        List<Job> filter = new List<Job>();
        items.then((result) {
          for (var record in result) {
            if (record.CompanyName.toLowerCase()
                    .toString()
                    .contains(searchQueryUser.toLowerCase()) ||
                record.Title.toLowerCase()
                    .toString()
                    .contains(searchQueryUser.toLowerCase())) {
              print(record.CompanyName);
              filter.add(record);
            }
          }
          jobfilterData = Future.value(filter);
        });
      } else {
        jobfilterData = jobdata;
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
    // String p = "";
    if (isOffline) {
      return connection.nointernetconnection();
    } else {
      return Scaffold(
        appBar: AppBar(
          title: _isSearchingUser
              ? _buildSearchField()
              : RichText(
                  text: TextSpan(
                      text: "Jobs",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      children: [
                        TextSpan(
                            text: "",
                            style: TextStyle(color: Colors.blue, fontSize: 15))
                      ]),
                ),
          actions: [
            ..._buildActions(),
            IconButton(
              icon: Icon(Icons.add,color: Colors.white,),
              onPressed: (){
                Navigator.of(context).pushNamed("/jobcategory");
              },
            ),
          ]
        ),
        body: new RefreshIndicator(
          key: _refreshIndicatorKey1,
          onRefresh: _refresh1,
          child: FutureBuilder<List<Job>>(
            future: jobfilterData,
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
                children: snapshot.data.map(
                      (data) => InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed("/jobdetails", arguments: {
                            "JobId": data.JobId,
                            "Title": data.Title,
                            "CompanyName": data.CompanyName,
                            "Remark": data.Remark,
                            "ContactNumber": data.ContactNumber,
                            "EmailId": data.EmailId,
                          });
                        },
                        child: Card(
                          elevation: 5,
                          margin: EdgeInsets.all(5),
                          child: Column(
                            children: <Widget>[
                              new Container(
                                alignment: Alignment.topLeft,
                                margin: EdgeInsets.only(top: 10, left: 10),
                                child: new Text(
                                  (data.CompanyName == null || data.CompanyName == "")
                                      ? "-"
                                      : data.CompanyName.toUpperCase(),
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              Divider(
                                thickness: 2,
                                indent: 10,
                                endIndent: 10,
                              ),
                              new Container(
                                alignment: Alignment.topLeft,
                                margin: EdgeInsets.only(top: 5,left: 10),
                                child: new Text(
                                  (data.Title == null || data.Title == "")
                                      ? "-"
                                      : "Post: " + data.Title.toUpperCase(),
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              new Container(
                                alignment: Alignment.topLeft,
                                margin: EdgeInsets.all(10),
                                child: Text(
                                  data.Remark,
                                  style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 13),
                                ),
                              ),
                            ],
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
