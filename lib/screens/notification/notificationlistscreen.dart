import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nakoda_group/data/rest_ds.dart';
import 'package:nakoda_group/models/notification.dart';
import 'package:nakoda_group/utils/connectionStatusSingleton.dart';
import 'package:nakoda_group/utils/internetconnection.dart';
import 'package:nakoda_group/utils/network_util.dart';

class NotificationListScreen extends StatefulWidget {
  @override
  _NotificationListScreenState createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
 
  NetworkUtil _netUtil = new NetworkUtil();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey1 = new GlobalKey<RefreshIndicatorState>();
  Future<List<Notifications>> notificationsdata;
  Future<List<Notifications>> notificationsfilterData;
  TextEditingController _searchQueryUser;
  bool _isSearchingUser = false;
  String searchQueryUser = "Search query";

  _loadPref() async {
    setState(() {
      notificationsdata = _getUserData("user");
      notificationsfilterData=notificationsdata;
    });
  }

  Future<List<Notifications>> _refresh1() async
  {
    setState(() {
      notificationsdata = _getUserData("user");
      notificationsfilterData=notificationsdata;
    });
  }

  Future<List<Notifications>> _getUserData(String usertype) async
  {
    return _netUtil.post(RestDatasource.GET_NOTIFICATION_URL,body:{"usertype":usertype}).then((dynamic res) {
      final items = res.cast<Map<String, dynamic>>();
      List<Notifications> listofusers = items.map<Notifications>((json) {
        return Notifications.fromJson(json);
      }).toList();
      List<Notifications> revdata = listofusers.reversed.toList();
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
      notificationsfilterData=notificationsdata;
      updateSearchQuery("");
    });
  }

  void _startSearch() {
    //print("open search box");
    ModalRoute
        .of(context)
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
      if(_searchQueryUser.toString().length>0)
      {
        //print(searchQuery.toString().length);
        Future<List<Notifications>> items = notificationsdata;
        List<Notifications> filter = new List<Notifications>();
        items.then((result){
          for(var record in result)
          {
            if(record.Title.toLowerCase().toString().contains(searchQueryUser.toLowerCase()) || record.Message.toLowerCase().toString().contains(searchQueryUser.toLowerCase()))
            {
              print(record.Title);
              filter.add(record);
            }
          }
          notificationsfilterData=Future.value(filter);
        });
      }
      else
      {
        notificationsfilterData=notificationsdata;
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
    String p="";
    if (isOffline) {
      return connection.nointernetconnection();
    } else {
      return Scaffold(
        appBar: AppBar(
          title: _isSearchingUser ? _buildSearchField() : RichText(
            text: TextSpan(
                text: "Notification",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                children: [
                  TextSpan(text: "",
                      style: TextStyle(color: Colors.blue, fontSize: 15))
                ]),
          ),
          actions: _buildActions(),
        ),
        body: new RefreshIndicator(
          key: _refreshIndicatorKey1,
          onRefresh: _refresh1,
          child: FutureBuilder<List<Notifications>>(
            future: notificationsfilterData,
            builder: (context, snapshot) {
              //print(snapshot.data);
              if (snapshot.connectionState ==
                  ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              else if (!snapshot.hasData) {
                return Center(
                  child: Text("No Data Available!"),
                );
              }
              return ListView(
                padding: EdgeInsets.only(bottom: 70.0),
                children:
                snapshot.data
                    .map((data) =>
                    InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              "/notificationdetail", arguments: {
                            "NotificationId":data.NotificationId,
                            "Title":data.Title,
                            "Message":data.Message,
                            "AddedOn":data.AddedOn,
                            "ImageUrl":data.ImageUrl,
                          });
                        },

                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
//
                          leading:CircleAvatar(
                            radius: 30,
                            child: new Text(data.Title[0].toUpperCase(),style: new TextStyle(
                              fontWeight: FontWeight.bold,
                            ),),
                          ),
                          title: new Text(data.Title,style: new TextStyle(
                            fontSize: 20,
                          ),),
                          subtitle: new Text(data.Message),
                        )
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
