import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nakoda_group/data/rest_ds.dart';
import 'package:nakoda_group/models/committe.dart';
import 'package:nakoda_group/utils/connectionStatusSingleton.dart';
import 'package:nakoda_group/utils/internetconnection.dart';
import 'package:nakoda_group/utils/network_util.dart';

class CommitteeListScreen extends StatefulWidget {
  @override
  _CommitteeListScreenState createState() => _CommitteeListScreenState();
}

class _CommitteeListScreenState extends State<CommitteeListScreen> {
  NetworkUtil _netUtil = new NetworkUtil();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey1 =
      new GlobalKey<RefreshIndicatorState>();
  Future<List<Committe>> committedata;
  Future<List<Committe>> committefilterData;
  TextEditingController _searchQueryUser;
  bool _isSearchingUser = false;
  String searchQueryUser = "Search query";

  _loadPref() async {
    setState(() {
      committedata = _getUserData("user");
      committefilterData = committedata;
    });
  }

  Future<List<Committe>> _refresh1() async {
    setState(() {
      committedata = _getUserData("user");
      committefilterData = committedata;
    });
  }

  Future<List<Committe>> _getUserData(String usertype) async {
    return _netUtil.post(RestDatasource.URL_COMMITTE_LIST,
        body: {"usertype": usertype}).then((dynamic res) {
      final items = res.cast<Map<String, dynamic>>();
      List<Committe> listofusers = items.map<Committe>((json) {
        return Committe.fromJson(json);
      }).toList();
      List<Committe> revdata = listofusers.reversed.toList();
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
      committefilterData = committedata;
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
        Future<List<Committe>> items = committedata;
        List<Committe> filter = new List<Committe>();
        items.then((result) {
          for (var record in result) {
            if (record.FirstName.toLowerCase()
                    .toString()
                    .contains(searchQueryUser.toLowerCase()) ||
                record.Dname.toLowerCase()
                    .toString()
                    .contains(searchQueryUser.toLowerCase())) {
              print(record.FirstName);
              filter.add(record);
            }
          }
          committefilterData = Future.value(filter);
        });
      } else {
        committefilterData = committedata;
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
                      text: "Committee",
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
          child: FutureBuilder<List<Committe>>(
            future: committefilterData,
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
              return GridView.count(
                crossAxisCount: 2,
                children: snapshot.data
                    .map((data) =>
                    InkWell(
                      onTap: (){
                        Navigator.of(context).pushNamed("/memberdetails", arguments: {
                          "id": data.MembershipId,
                          "FirstName": data.FirstName,
                          "Contact": data.Mobile1,
                          "Photo": data.Photo,
                          "MiddleName": data.MiddleName,
                          "LastGautra": data.LastGautra,
                          "Education": data.Education,
                          "EmailId": data.EmailId,
                          "BloodGroup": data.BloodGroup,
                          "MainMemberId": data.MainMemberId,
                          "DOB": data.DOB,
                          "Relation": data.Relation,
                          "Mobile2": data.Mobile2,
                          "Mobile3": data.Mobile3,
                          "MemberType": data.MemberType,
                          "ProfessionId": data.ProfessionId,
                          "ProfessionName": data.ProfessionName,
                          "NativeId": data.NativeId,
                          "NanihalGautra": data.NanihalGautra,
                          "NanihalNative": data.NativeName,
                          "NanihalBusiness": data.NanihalBusiness,
                          "SasuralGautra": data.SasuralGautra,
                          "SasuralNative": data.SasuralNative,
                          "SasuralBusiness": data.SasuralBusiness,
                          "Gender": data.Gender,
                          "Married": data.Married,
                          "AniversaryDate": data.AniversaryDate,
                          "ResidanceLandmark": data.ResidanceLandmark,
                          "ResidenaceCityId": data.ResidenaceCityId,
                          "ResidanceMobile": data.ResidanceMobile,
                          "ResidanceTelephone": data.ResidanceTelephone,
                          "ResidancePincode": data.ResidancePincode,
                          "ResidanceAddress": data.ResidanceAddress,
                          "OfficeFirmName": data.OfficeFirmName,
                          "OfficeWebsite": data.OfficeWebsite,
                          "OfficeEmailId": data.OfficeEmailId,
                          "OfficeAddress": data.OfficeAddress,
                          "OfficeLandmark": data.OfficeLandmark,
                          "OfficeCityId": data.OfficeCityId,
                          "OfficeMobile": data.OfficeMobile,
                          "OfficeTelephone": data.OfficeTelephone,
                          "OfficePincode": data.OfficePincode,
                          "NativeOffice": data.NativeOffice,
                          "NativeLandmark": data.NativeLandmark,
                          "NativeCityId": data.NativeCityId,
                          "NativeMobile": data.NativeMobile,
                          "NativeTelephone": data.NativeTelephone,
                          "NativePincode": data.NativePincode,
                          "RecName1": data.RecName1,
                          "RecName2": data.RecName2,
                          "FormNumber": data.FormNumber,
                          "NativeName": data.NativeName,
                          "rcity": data.rcity,
                          "rstate": data.rstate,
                          "ostate": data.ostate,
                          "ocity": data.ocity,
                          "nstate": data.nstate,
                          "ncity": data.ncity,
                        });
                      },
                      child: Card(
                          elevation: 5,
                          margin: EdgeInsets.all(5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              (data.Photo == null || data.Photo == "")
                                  ? CircleAvatar(
                                      radius: 50,
                                      child: new Text(
                                        data.FirstName[0].toUpperCase() +
                                            data.MiddleName[0].toUpperCase(),
                                        style: new TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFF44336)),
                                      ),
                                      backgroundColor: Colors.red.shade100,
                                    )
                                  : CircleAvatar(
                                      radius: 50,
                                      backgroundImage: NetworkImage(
                                          RestDatasource.Committee_IMAGE_URL +
                                              data.Photo),
                                    ),
                              new SizedBox(
                                height: 15,
                              ),
                              new Text((data.FirstName == null || data.FirstName == "")
                                    ? "-"
                                    : data.FirstName.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: new TextStyle(fontSize: 17),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                (data.Dname == null || data.Dname == "")
                                    ? "( - )"
                                    : "(" + data.Dname.toUpperCase() + ")",
                                style: new TextStyle(fontSize: 15),
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
