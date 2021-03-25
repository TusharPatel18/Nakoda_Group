import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nakoda_group/data/rest_ds.dart';
import 'package:nakoda_group/models/blood_group_type_list.dart';
import 'package:nakoda_group/models/city_list.dart';
import 'package:nakoda_group/models/filter_member.dart';
import 'package:nakoda_group/models/gautra_list.dart';
import 'package:nakoda_group/models/gender_Type_List.dart';
import 'package:nakoda_group/models/married_Type_List.dart';
import 'package:nakoda_group/models/member.dart';
import 'package:nakoda_group/models/member_Type_List.dart';
import 'package:nakoda_group/models/nanihal_native_Place_List.dart';
import 'package:nakoda_group/models/profession_List.dart';
import 'package:nakoda_group/utils/connectionStatusSingleton.dart';
import 'package:nakoda_group/utils/internetconnection.dart';
import 'package:nakoda_group/utils/network_util.dart';
import 'package:url_launcher/url_launcher.dart';

class MemberListScreen extends StatefulWidget {
  @override
  _MemberListScreenState createState() => _MemberListScreenState();
}

class _MemberListScreenState extends State<MemberListScreen> {
  NetworkUtil _netUtil = new NetworkUtil();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey1 =
      new GlobalKey<RefreshIndicatorState>();
  Future<List<Members>> userdata;
  Future<List<Members>> userfilterData;

  Future<List<FilterMembers>> filterdata;
  Future<List<FilterMembers>> _getFilterrData() async {
    return _netUtil.post(RestDatasource.GET_MEMBER_FILTER,
        body: {
          "txtgautra": (_Gautra == "") ? "0" : _Gautra,
          "txtnative":(_NativePlace == "") ? "0" : _NativePlace,
          "txtgender": (_Gender == "" || _Gender == "ALL") ? "0" : _Gender,
          "txttype": (_MemberType == "" || _MemberType == "ALL") ? "0" : _MemberType,
          "txtprofession": (_Profession == null || _Profession == "") ? "0" : _Profession,
          "txtbloodgroup": (_BloodGroup == "" || _BloodGroup == "ALL") ? "0" : _BloodGroup,
          "txtmar": (_Married == "" || _Married == "ALL") ? "0" : _Married,
          "txtocity": (_Officecity == "") ? "0" : _Officecity,
          "txtncity": (_Nativecity == "") ? "0" : _Nativecity,
          "txtrlandmark": "",
          "txtolandmark": "",
          "txtnlandmark": "",
          "txtspecialinfo": "",
          "txtpovlevel": "",
        }).then((dynamic res) {
          print(res);
      final items = res.cast<Map<String, dynamic>>();
      List<FilterMembers> listofusers = items.map<FilterMembers>((json) {
        return FilterMembers.fromJson(json);
      }).toList();
      List<FilterMembers> revdata = listofusers.reversed.toList();
      return revdata;
    });
  }

  _FilterData(){
    setState(() {
      filterdata =  _getFilterrData();
      _isLoad = true;
    });
  }


  TextEditingController _searchQueryUser;
  bool _isSearchingUser = false;
  String searchQueryUser = "Search query";

  _loadPref() async {
    setState(() {
      userdata = _getUserData("user");
      userfilterData = userdata;
      gautraListdata = _getGautraListData();
      nativePlaceListdata = _getnativePlaceListData();
      professionListdata = _getprofessionListData();
      ResidencecityListdata = _getCityListData();
      OfficecityListdata = _getCityListData();
      NativecityListdata = _getCityListData();
    });
  }

  Future<List<Members>> _refresh1() async {
    setState(() {
      userdata = _getUserData("user");
      userfilterData = userdata;
    });
  }

  Future<List<Members>> _getUserData(String usertype) async {
    return _netUtil.post(RestDatasource.URL_MEMBER_LIST,
        body: {"usertype": usertype}).then((dynamic res) {
      final items = res.cast<Map<String, dynamic>>();
      List<Members> listofusers = items.map<Members>((json) {
        return Members.fromJson(json);
      }).toList();
      List<Members> revdata = listofusers.reversed.toList();
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
        Future<List<Members>> items = userdata;
        List<Members> filter = new List<Members>();
        items.then((result) {
          for (var record in result) {
            if (record.FirstName.toLowerCase()
                    .toString()
                    .contains(searchQueryUser.toLowerCase()) ||
                record.MiddleName.toLowerCase()
                    .toString()
                    .contains(searchQueryUser.toLowerCase()) ||
                record.LastGautra.toLowerCase()
                    .toString()
                    .contains(searchQueryUser.toLowerCase()) ||
                record.Mobile1.toLowerCase()
                    .toString()
                    .contains(searchQueryUser.toLowerCase())) {
              filter.add(record);
            }
          }
          userfilterData = Future.value(filter);
        });
      } else {
        userfilterData = userdata;
      }
    });
  }

  bool _isLoad = false;
  final formKey = new GlobalKey<FormState>();
  String Gautra,
      NativePlace,
      Gender,
      MemberType,
      Profession,
      BloodGroup,
      Married,
      Residencecity,
      Officecity,
      Nativecity;
  String _Gautra = "",
         _NativePlace = "",
         _Gender = "",
         _MemberType = "",
         _Profession = "",
         _BloodGroup = "",
         _Married = "",
         _Residencecity = "",
         _Officecity = "",
         _Nativecity = "";

  Future<List<GautraList>> gautraListdata;
  Future<List<GautraList>> _getGautraListData() async {
    return _netUtil.post(RestDatasource.URL_GAUTRA_LIST).then((dynamic res) {
      final items = res.cast<Map<String, dynamic>>();
      List<GautraList> listofusers = items.map<GautraList>((json) {
        return GautraList.fromJson(json);
      }).toList();
      List<GautraList> revdata = listofusers.toList();
      return revdata;
    });
  }

  Future<List<NativePlaceList>> nativePlaceListdata;
  Future<List<NativePlaceList>> _getnativePlaceListData() async {
    return _netUtil.post(RestDatasource.URL_NATIVE_PLACE_LIST).then((dynamic res) {
      final items = res.cast<Map<String, dynamic>>();
      List<NativePlaceList> listofusers = items.map<NativePlaceList>((json) {
        return NativePlaceList.fromJson(json);
      }).toList();
      List<NativePlaceList> revdata = listofusers.toList();
      return revdata;
    });
  }

  Future<List<ProfessionList>> professionListdata;
  Future<List<ProfessionList>> _getprofessionListData() async {
    return _netUtil.post(RestDatasource.URL_PROFESSION_LIST).then((dynamic res) {
      final items = res.cast<Map<String, dynamic>>();
      List<ProfessionList> listofusers = items.map<ProfessionList>((json) {
        return ProfessionList.fromJson(json);
      }).toList();
      List<ProfessionList> revdata = listofusers.toList();
      return revdata;
    });
  }

  Future<List<CityList>> ResidencecityListdata;
  Future<List<CityList>> OfficecityListdata;
  Future<List<CityList>> NativecityListdata;
  Future<List<CityList>> _getCityListData() async {
    return _netUtil.post(RestDatasource.URL_CITY_LIST).then((dynamic res) {
      final items = res.cast<Map<String, dynamic>>();
      List<CityList> listofusers = items.map<CityList>((json) {
        return CityList.fromJson(json);
      }).toList();
      List<CityList> revdata = listofusers.toList();
      return revdata;
    });
  }

  Future<List<MarriedTypeList>> getMarriedTypeList() async {
    List<MarriedTypeList> listOfRateType = new List<MarriedTypeList>();
    MarriedTypeList item1 = new MarriedTypeList();
    item1.MarriedType = "ALL";
    listOfRateType.add(item1);
    MarriedTypeList item2 = new MarriedTypeList();
    item2.MarriedType = "YES";
    listOfRateType.add(item2);
    MarriedTypeList item3 = new MarriedTypeList();
    item3.MarriedType = "NO";
    listOfRateType.add(item3);
    return listOfRateType.toList();
  }
  //Married Type List

  //Gender Type List
  Future<List<GenderTypeList>> getGenderTypeList() async {
    List<GenderTypeList> listOfRateType = new List<GenderTypeList>();
    GenderTypeList item1 = new GenderTypeList();
    item1.GenderType = "ALL";
    listOfRateType.add(item1);
    GenderTypeList item2 = new GenderTypeList();
    item2.GenderType = "MALE";
    listOfRateType.add(item2);
    GenderTypeList item3 = new GenderTypeList();
    item3.GenderType = "FEMALE";
    listOfRateType.add(item3);
    return listOfRateType.toList();
  }
  //Gender Type List

  //Member Type List
  Future<List<MemberTypeList>> getMemberTypeList() async {
    List<MemberTypeList> listOfRateType = new List<MemberTypeList>();
    MemberTypeList item1 = new MemberTypeList();
    item1.MemberType = "ALL";
    listOfRateType.add(item1);
    MemberTypeList item2 = new MemberTypeList();
    item2.MemberType = "MAIN";
    listOfRateType.add(item2);
    MemberTypeList item3 = new MemberTypeList();
    item3.MemberType = "SUB MEMBERS";
    listOfRateType.add(item3);
    return listOfRateType.toList();
  }
  //Member Type List

  //Blood Group Type List
  Future<List<BloodGroupTypeList>> getBloodGroupTypeList() async {
    List<BloodGroupTypeList> listOfRateType = new List<BloodGroupTypeList>();
    BloodGroupTypeList item1 = new BloodGroupTypeList();
    item1.BloodGroupName = "ALL";
    listOfRateType.add(item1);
    BloodGroupTypeList item2 = new BloodGroupTypeList();
    item2.BloodGroupName = "A+";
    listOfRateType.add(item2);
    BloodGroupTypeList item3 = new BloodGroupTypeList();
    item3.BloodGroupName = "B+";
    listOfRateType.add(item3);
    BloodGroupTypeList item4 = new BloodGroupTypeList();
    item4.BloodGroupName = "O+";
    listOfRateType.add(item4);
    BloodGroupTypeList item5 = new BloodGroupTypeList();
    item5.BloodGroupName = "A-";
    listOfRateType.add(item5);
    BloodGroupTypeList item6 = new BloodGroupTypeList();
    item6.BloodGroupName = "B-";
    listOfRateType.add(item6);
    BloodGroupTypeList item7 = new BloodGroupTypeList();
    item7.BloodGroupName = "O-";
    listOfRateType.add(item7);
    return listOfRateType.toList();
  }
  //Blood Group Type List

  @override
  Widget build(BuildContext context) {
    if (isOffline) {
      return connection.nointernetconnection();
    } else {
      if(_isLoad == true)
      {
        return Scaffold(
          appBar: AppBar(
              title:  RichText(
                text: TextSpan(
                    text: "Filter Members",
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    children: [
                      TextSpan(
                          text: "",
                          style: TextStyle(color: Colors.blue, fontSize: 15))
                    ]),
              ),
          ),
          body: FutureBuilder<List<FilterMembers>>(
            future: filterdata,
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
                padding: EdgeInsets.only(bottom: 70.0, top: 10),
                children: snapshot.data.map(
                      (data) => InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed("/memberdetails", arguments: {
                        "id": data.MembershipId,
                        "FirstName": data.FirstName,
                        "Contact": data.Mobile1,
                        "Photo": data.Photo,
                        "MiddleName": data.MiddleName,
                        "LastGautra": data.LastGautra,
                        "Education": data.Education,
                        "OtherEducationName": data.OtherEducationName,
                        "EmailId": data.EmailId,
                        "BloodGroup": data.BloodGroup,
                        "MainMemberId": data.MainMemberId,
                        "DOB": data.DOB,
                        "Relation": data.Relation,
                        "Mobile2": data.Mobile2,
                        "Mobile3": data.Mobile3,
                        "MemberType": data.MemberType,
                        "ProfessionId": data.ProfessionId,
                        "NativeId": data.NativeId,
                        "NanihalNative": data.NativeName,
                        "NanihalBusiness": data.NanihalBusiness,
                        "NanihalGautra": data.NanihalGautra,
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
                        "TrusteeName": data.TrusteeName,
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
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: (data.Photo == null ||
                              data.Photo == "")
                              ? CircleAvatar(
                            radius: 30,
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
                            radius: 30,
                            backgroundImage: NetworkImage(
                                RestDatasource.Committee_IMAGE_URL +
                                    data.Photo),
                          ),
                          title: new Text(
                            ((data.FirstName == null ||
                                data.FirstName == "")
                                ? "-"
                                : data.FirstName.toUpperCase()) +
                                " " +
                                ((data.MiddleName == null ||
                                    data.MiddleName == "")
                                    ? "-"
                                    : data.MiddleName.toUpperCase()) +
                                " " +
                                ((data.LastGautra == null ||
                                    data.LastGautra == "")
                                    ? "-"
                                    : data.LastGautra.toUpperCase()),
                            style: new TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          subtitle: new Text(
                              (data.Mobile1 == null || data.Mobile1 == "")
                                  ? "-"
                                  : data.Mobile1),
                        ),
                        Divider(
                          thickness: 2,
                          indent: 20,
                          endIndent: 20,
                        )
                      ],
                    ),
                  ),
                ).toList(),
              );
            },
          ),
        );
      }
      else{
        return Scaffold(
          appBar: AppBar(
              title: _isSearchingUser
                  ? _buildSearchField()
                  : RichText(
                text: TextSpan(
                    text: "Members",
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
                  icon: Icon(Icons.bar_chart,color: Colors.white,),
                  onPressed: (){
                    showBottomSheet();
                    // Navigator.of(context).pushNamed("/advancesearchmembers");
                  },
                ),
              ]
          ),
          body: new RefreshIndicator(
            key: _refreshIndicatorKey1,
            onRefresh: _refresh1,
            child: FutureBuilder<List<Members>>(
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
                  padding: EdgeInsets.only(bottom: 70.0, top: 10),
                  children: snapshot.data.map(
                        (data) => InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed("/memberdetails", arguments: {
                          "id": data.MembershipId,
                          "FirstName": data.FirstName,
                          "Contact": data.Mobile1,
                          "Photo": data.Photo,
                          "MiddleName": data.MiddleName,
                          "LastGautra": data.LastGautra,
                          "Education": data.Education,
                          "OtherEducationName": data.OtherEducationName,
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
                          "TrusteeName": data.TrusteeName,
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
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            leading: (data.Photo == null ||
                                data.Photo == "")
                                ? CircleAvatar(
                              radius: 30,
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
                              radius: 30,
                              backgroundImage: NetworkImage(
                                  RestDatasource.Committee_IMAGE_URL +
                                      data.Photo),
                            ),
                            title: new Text(
                              ((data.FirstName == null ||
                                  data.FirstName == "")
                                  ? "-"
                                  : data.FirstName.toUpperCase()) +
                                  " " +
                                  ((data.MiddleName == null ||
                                      data.MiddleName == "")
                                      ? "-"
                                      : data.MiddleName.toUpperCase()) +
                                  " " +
                                  ((data.LastGautra == null ||
                                      data.LastGautra == "")
                                      ? "-"
                                      : data.LastGautra.toUpperCase()),
                              style: new TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            subtitle: new Text(
                                (data.Mobile1 == null || data.Mobile1 == "")
                                    ? "-"
                                    : data.Mobile1),
                            trailing: IconButton(icon: Icon(
                              Icons.call,
                              color: Colors.black,
                              size: 24.0,
                            ), onPressed: () async {
                              var url = data.Mobile1 ?? "";
                              if (await canLaunch('tel:$url')) {
                              await launch('tel:$url');
                              } else {
                              throw 'Could not launch $url';
                              }
                            })
                          ),
                          Divider(
                            thickness: 2,
                            indent: 20,
                            endIndent: 20,
                          )
                        ],
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
  void showBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Text(
                      'Filter Members :',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30, right: 30),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.close,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Column(
                children: [
                  Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.fromLTRB(15, 10, 15, 0),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Flexible(
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          child: Text(
                                            "Gautra :",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Flexible(
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          child: Text(
                                            "Native :",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: <Widget>[
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        FutureBuilder<List<GautraList>>(
                                          future: gautraListdata,
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData)
                                              return Center(
                                                  child:
                                                  CircularProgressIndicator());
                                            return DropdownButtonFormField(
                                              isExpanded: true,
                                              hint: Text("ALL",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 15),
                                                  maxLines: 1),
                                              style: TextStyle(fontSize: 16),
                                              value: Gautra,
                                              items: snapshot.data.map((data) {
                                                return new DropdownMenuItem(
                                                  child: new Text(
                                                    data.GautraName,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color:
                                                        Colors.black),
                                                  ),
                                                  value: data.GautraName,
                                                );
                                              }).toList(),
                                              onChanged: (newVal) {
                                                setState(() {
                                                  _Gautra = newVal;
                                                });
                                              },
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  fillColor:
                                                  Color(0xfff3f3f4),
                                                  filled: true),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        FutureBuilder<List<NativePlaceList>>(
                                          future: nativePlaceListdata,
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData)
                                              return Center(
                                                  child: CircularProgressIndicator());
                                            return DropdownButtonFormField(
                                              isExpanded: true,
                                              hint: Text("ALL",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 15),
                                                  maxLines: 1),
                                              style: TextStyle(fontSize: 16),
                                              value: NativePlace,
                                              items: snapshot.data.map((data) {
                                                return new DropdownMenuItem(
                                                  child: new Text(
                                                    data.NativeName,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color:
                                                        Colors.black),
                                                  ),
                                                  value: data.NativeId,
                                                );
                                              }).toList(),
                                              onChanged: (newVal) {
                                                setState(() {
                                                  _NativePlace = newVal;
                                                });
                                              },
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  fillColor: Color(0xfff3f3f4),
                                                  filled: true),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(15, 10, 15, 0),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Flexible(
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          child: Text(
                                            "Gender :",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Flexible(
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          child: Text(
                                            "Member Type :",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: <Widget>[
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        FutureBuilder<List<GenderTypeList>>(
                                          future: getGenderTypeList(),
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData)
                                              return Center(
                                                  child: CircularProgressIndicator());
                                            return DropdownButtonFormField(
                                              isExpanded: true,
                                              hint: Text("ALL",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 15),
                                                  maxLines: 1),
                                              style: TextStyle(fontSize: 16),
                                              value: Gender,
                                              items: snapshot.data.map((data) {
                                                return new DropdownMenuItem(
                                                  child: new Text(
                                                    data.GenderType,
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  value: data.GenderType,
                                                );
                                              }).toList(),
                                              onChanged: (newVal) {
                                                setState(() {
                                                  _Gender = newVal;
                                                });
                                              },
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  fillColor: Color(0xfff3f3f4),
                                                  filled: true),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        FutureBuilder<List<MemberTypeList>>(
                                          future: getMemberTypeList(),
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData)
                                              return Center(
                                                  child: CircularProgressIndicator());
                                            return DropdownButtonFormField(
                                              isExpanded: true,
                                              hint: Text("ALL",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 15),
                                                  maxLines: 1),
                                              style: TextStyle(fontSize: 16),
                                              value: MemberType,
                                              items: snapshot.data.map((data) {
                                                return new DropdownMenuItem(
                                                  child: new Text(
                                                    data.MemberType,
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  value: data.MemberType,
                                                );
                                              }).toList(),
                                              onChanged: (newVal) {
                                                setState(() {
                                                  _MemberType = newVal;
                                                });
                                              },
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  fillColor: Color(0xfff3f3f4),
                                                  filled: true),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(15, 10, 15, 0),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Flexible(
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          child: Text(
                                            "Profession :",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Flexible(
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          child: Text(
                                            "Blood Group :",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: <Widget>[
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        FutureBuilder<List<ProfessionList>>(
                                          future: professionListdata,
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData)
                                              return Center(
                                                  child: CircularProgressIndicator());
                                            return DropdownButtonFormField(
                                              isExpanded: true,
                                              hint: Text("ALL",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 15),
                                                  maxLines: 1),
                                              style:
                                              TextStyle(fontSize: 16),
                                              value: Profession,
                                              items: snapshot.data.map((data) {
                                                return new DropdownMenuItem(
                                                  child: new Text(
                                                    data.ProfessionName,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black),
                                                  ),
                                                  value: data.ProfessionId,
                                                );
                                              }).toList(),
                                              onChanged: (newVal) {
                                                setState(() {
                                                  _Profession = newVal;
                                                });
                                              },
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  fillColor: Color(0xfff3f3f4),
                                                  filled: true),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        FutureBuilder<List<BloodGroupTypeList>>(
                                          future: getBloodGroupTypeList(),
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData)
                                              return Center(
                                                  child: CircularProgressIndicator());
                                            return DropdownButtonFormField(
                                              isExpanded: true,
                                              hint: Text("ALL",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 15),
                                                  maxLines: 1),
                                              style: TextStyle(fontSize: 16),
                                              value: BloodGroup,
                                              items: snapshot.data.map((data) {
                                                return new DropdownMenuItem(
                                                  child: new Text(
                                                    data.BloodGroupName,
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black,
                                                      fontWeight:
                                                      FontWeight.w600,
                                                    ),
                                                  ),
                                                  value: data.BloodGroupName,
                                                );
                                              }).toList(),
                                              onChanged: (newVal) {
                                                setState(() {
                                                  _BloodGroup = newVal;
                                                });
                                              },
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  fillColor: Color(0xfff3f3f4),
                                                  filled: true),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(15, 10, 15, 0),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Flexible(
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          child: Text(
                                            "Married ?",
                                            style: TextStyle(
                                                fontWeight:
                                                FontWeight.bold,
                                                fontSize: 13),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Flexible(
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          child: Text(
                                            "Residance City :",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: <Widget>[
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        FutureBuilder<List<MarriedTypeList>>(
                                          future: getMarriedTypeList(),
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData)
                                              return Center(
                                                  child: CircularProgressIndicator());
                                            return DropdownButtonFormField(
                                              isExpanded: true,
                                              hint: Text("ALL",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 15),
                                                  maxLines: 1),
                                              style: TextStyle(fontSize: 16),
                                              value: Married,
                                              items: snapshot.data.map((data) {
                                                return new DropdownMenuItem(
                                                  child: new Text(
                                                    data.MarriedType,
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  value: data.MarriedType,
                                                );
                                              }).toList(),
                                              onChanged: (newVal) {
                                                setState(() {
                                                  _Married = newVal;
                                                });
                                              },
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  fillColor: Color(0xfff3f3f4),
                                                  filled: true),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        FutureBuilder<List<CityList>>(
                                          future: ResidencecityListdata,
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData)
                                              return Center(
                                                  child: CircularProgressIndicator());
                                            return DropdownButtonFormField(
                                              isExpanded: true,
                                              hint: Text("ALL",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 15),
                                                  maxLines: 1),
                                              style: TextStyle(fontSize: 16),
                                              value: Residencecity,
                                              items: snapshot.data.map((data) {
                                                return new DropdownMenuItem(
                                                  child: new Text(
                                                    data.CityName,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black),
                                                  ),
                                                  value: data.CityId,
                                                );
                                              }).toList(),
                                              onChanged: (newVal) {
                                                setState(() {
                                                  _Residencecity = newVal;
                                                });
                                              },
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  fillColor: Color(0xfff3f3f4),
                                                  filled: true),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(15, 10, 15, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Flexible(
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          child: Text(
                                            "Office City :",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Flexible(
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          child: Text(
                                            "Native City :",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: <Widget>[
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        FutureBuilder<List<CityList>>(
                                          future: OfficecityListdata,
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData)
                                              return Center(
                                                  child: CircularProgressIndicator());
                                            return DropdownButtonFormField(
                                              isExpanded: true,
                                              hint: Text("ALL",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 15),
                                                  maxLines: 1),
                                              style: TextStyle(fontSize: 16),
                                              value: Officecity,
                                              items: snapshot.data.map((data) {
                                                return new DropdownMenuItem(
                                                  child: new Text(
                                                    data.CityName,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black),
                                                  ),
                                                  value: data.CityId,
                                                );
                                              }).toList(),
                                              onChanged: (newVal) {
                                                setState(() {
                                                  _Officecity = newVal;
                                                });
                                              },
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  fillColor: Color(0xfff3f3f4),
                                                  filled: true),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        FutureBuilder<List<CityList>>(
                                          future: NativecityListdata,
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData)
                                              return Center(
                                                  child: CircularProgressIndicator());
                                            return DropdownButtonFormField(
                                              isExpanded: true,
                                              hint: Text("ALL",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 15),
                                                  maxLines: 1),
                                              style: TextStyle(fontSize: 16),
                                              value: Nativecity,
                                              items: snapshot.data.map((data) {
                                                return new DropdownMenuItem(
                                                  child: new Text(
                                                    data.CityName,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black),
                                                  ),
                                                  value: data.CityId,
                                                );
                                              }).toList(),
                                              onChanged: (newVal) {
                                                setState(() {
                                                  _Nativecity = newVal;
                                                });
                                              },
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  fillColor:
                                                  Color(0xfff3f3f4),
                                                  filled: true),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: InkWell(
                      onTap: (){
                        if (_isLoad == false) {
                          final form = formKey.currentState;
                          form.save();
                          _FilterData();
                          Navigator.pop(context);
                        }
                      },
                      child: new Container(
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5),
                          ),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.grey.shade200,
                                offset: Offset(2, 4),
                                blurRadius: 5,
                                spreadRadius: 2)
                          ],
                          color: Colors.red,
                        ),
                        child: Text(
                          'SEARCH',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
