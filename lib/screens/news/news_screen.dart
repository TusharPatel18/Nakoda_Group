import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nakoda_group/data/rest_ds.dart';
import 'package:nakoda_group/models/news.dart';
import 'package:nakoda_group/utils/connectionStatusSingleton.dart';
import 'package:nakoda_group/utils/internetconnection.dart';
import 'package:nakoda_group/utils/network_util.dart';

class NewsListScreen extends StatefulWidget {
  @override
  _NewsListScreenState createState() => _NewsListScreenState();
} 

class _NewsListScreenState extends State<NewsListScreen> {

  NetworkUtil _netUtil = new NetworkUtil();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey1 = new GlobalKey<RefreshIndicatorState>();
  Future<List<News>> newsdata;
  Future<List<News>> newsfilterData;
  TextEditingController _searchQueryUser;
  bool _isSearchingUser = false;
  String searchQueryUser = "Search query";

  _loadPref() async {
    setState(() {
      newsdata = _getUserData("user");
      newsfilterData=newsdata;
    });
  }

  Future<List<News>> _refresh1() async
  {
    setState(() {
      newsdata = _getUserData("user");
      newsfilterData=newsdata;
    });
  }

  Future<List<News>> _getUserData(String usertype) async
  {
    return _netUtil.post(RestDatasource.GET_NEWS_URL,body:{"usertype":usertype}).then((dynamic res) {
      final items = res.cast<Map<String, dynamic>>();
      List<News> listofusers = items.map<News>((json) {
        return News.fromJson(json);
      }).toList();
      List<News> revdata = listofusers.reversed.toList();
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
      newsfilterData=newsdata;
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
        Future<List<News>> items = newsdata;
        List<News> filter = new List<News>();
        items.then((result){
          for(var record in result)
          {
            if(record.Title.toLowerCase().toString().contains(searchQueryUser.toLowerCase()) || record.Type.toLowerCase().toString().contains(searchQueryUser.toLowerCase()))
            {
              print(record.Title);
              filter.add(record);
            }
          }
          newsfilterData=Future.value(filter);
        });
      }
      else
      {
        newsfilterData=newsdata;
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
          title: _isSearchingUser ? _buildSearchField() : RichText(
            text: TextSpan(
                text: "News",
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
          child: FutureBuilder<List<News>>(
            future: newsfilterData,
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
                            "/newsdetails", arguments: {
                          "NewsId": data.NewsId,
                          "Title":data.Title,
                          "Remark":data.Remark,
                          "ImageUrl":data.ImageUrl,
                          "Type":data.Type,
                          "AddedOn":data.AddedOn,
                        });
                      },
                      child: Card(
                        elevation: 5,
                        margin: EdgeInsets.all(5),
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              new Container(
                                alignment: Alignment.topLeft,
                                margin: EdgeInsets.only(top: 8,left: 10),
                                child: new Text((data.Title == null || data.Title == "") ? "-" : data.Title.toUpperCase(),
                                  style: TextStyle(fontSize: 16),),
                              ),
                              Divider(
                                indent: 3,
                                endIndent: 3,
                                thickness: 2,
                              ),
                              (data.ImageUrl != null || data.ImageUrl != "") ?
                              Container(
                                height: MediaQuery.of(context).size.width* 0.60,
                                width: MediaQuery.of(context).size.width* 0.90,
                                child: (data.ImageUrl == null || data.ImageUrl == "")
                                    ?
                                new Center(
                                  child: new Text((data.Title == null || data.Title == "")
                                      ? "No Image" :
                                        data.Title[0],style: TextStyle(fontSize: 25),),)
                                    :
                                new Image(
                                  image: NetworkImage(RestDatasource.NEWS_URL + data.ImageUrl),
                                  fit: BoxFit.fill,
                                ),
                              ) : Container(),
                              Container(
                                margin: EdgeInsets.only(top: 10,left: 10,bottom: 10),
                                alignment: Alignment.topLeft,
                                child: new Text(
                                  data.Type,
                                  style: TextStyle(
                                    fontSize: 15
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10,bottom: 10,right: 10),
                                alignment: Alignment.topLeft,
                                child: new Text(
                                  data.Remark,
//                                  maxLines: 4,
//                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          )
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
//ListTile(
//contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
//leading: new Container(
//child: Image(image: NetworkImage('https://karoninfotech.com/demo/nakoda/uploads/news/' + data.ImageUrl),fit: BoxFit.fill,height: 200,width: 100,),
//),
//title: new Text(data.Title,style: new TextStyle(
//fontSize: 20,
//),),
//subtitle: new Text(data.Remark),
//),