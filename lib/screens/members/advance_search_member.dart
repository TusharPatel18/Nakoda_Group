import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nakoda_group/data/rest_ds.dart';
import 'package:nakoda_group/models/blood_group_type_list.dart';
import 'package:nakoda_group/models/city_list.dart';
import 'package:nakoda_group/models/gautra_list.dart';
import 'package:nakoda_group/models/gender_Type_List.dart';
import 'package:nakoda_group/models/married_Type_List.dart';
import 'package:nakoda_group/models/member_Type_List.dart';
import 'package:nakoda_group/models/nanihal_native_Place_List.dart';
import 'package:nakoda_group/models/income_level_type_list.dart';
import 'package:nakoda_group/models/profession_List.dart';
import 'package:nakoda_group/models/special_type_list.dart';
import 'package:nakoda_group/utils/connectionStatusSingleton.dart';
import 'package:nakoda_group/utils/flash_helper.dart';
import 'package:nakoda_group/utils/internetconnection.dart';
import 'package:nakoda_group/utils/network_util.dart';

class AdvanceSearchMember extends StatefulWidget {
  @override
  _AdvanceSearchMemberState createState() => _AdvanceSearchMemberState();
}

class _AdvanceSearchMemberState extends State<AdvanceSearchMember> {
  NetworkUtil _netUtil = new NetworkUtil();
  bool _isLoading = false;
  final formKey = new GlobalKey<FormState>();
  bool isOffline = false;
  InternetConnection connection = new InternetConnection();
  StreamSubscription _connectionChangeStream;

  String _Gautra,_NativePlace,_Gender,_MemberType,_Profession,_BloodGroup,_Married,_Residencecity,_Officecity,_Nativecity,_SpecialInfo,_PovertyLevel;

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

  //Poverty Level Type List
  Future<List<IncomeLevelTypeList>> getIncomeLevelTypeList() async {
    List<IncomeLevelTypeList> listOfRateType =
    new List<IncomeLevelTypeList>();
    IncomeLevelTypeList item1 = new IncomeLevelTypeList();
    item1.TypeName = "1 To 2 Lakh";
    listOfRateType.add(item1);
    IncomeLevelTypeList item2 = new IncomeLevelTypeList();
    item2.TypeName = "2 To 5 Lakh";
    listOfRateType.add(item2);
    IncomeLevelTypeList item3 = new IncomeLevelTypeList();
    item3.TypeName = "5 Lakh Above";
    listOfRateType.add(item3);
    IncomeLevelTypeList item4 = new IncomeLevelTypeList();
    item4.TypeName = "10 Lakh Above";
    listOfRateType.add(item4);
    IncomeLevelTypeList item5 = new IncomeLevelTypeList();
    item5.TypeName = "None Of Above";
    listOfRateType.add(item5);
    return listOfRateType.toList();
  }
  //Poverty Level Type List

  //Special Type List
  Future<List<SpecialTypeList>> getSpecialTypeList() async {
    List<SpecialTypeList> listOfRateType = new List<SpecialTypeList>();
    SpecialTypeList item1 = new SpecialTypeList();
    item1.SpecialName = "None";
    listOfRateType.add(item1);
    SpecialTypeList item2 = new SpecialTypeList();
    item2.SpecialName = "Widow";
    listOfRateType.add(item2);
    SpecialTypeList item3 = new SpecialTypeList();
    item3.SpecialName = "Diverse";
    listOfRateType.add(item3);
    return listOfRateType.toList();
  }
  //Special Type List

  //Married Type List
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

  _loadPref() async {
    setState(() {
      gautraListdata = _getGautraListData();
      nativePlaceListdata = _getnativePlaceListData();
      professionListdata = _getprofessionListData();
      ResidencecityListdata = _getCityListData();
      OfficecityListdata = _getCityListData();
      NativecityListdata = _getCityListData();
    });
  }

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
          title: RichText(
            text: TextSpan(
                text: "Filter",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                children: [
                  TextSpan(
                      text: "",
                      style: TextStyle(color: Colors.blue, fontSize: 15),
                  ),
                ]),
          ),
        ),
        body: Column(
          children: [
            Card(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
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
                                            value: _Gautra,
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
                                            value: _NativePlace,
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
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
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
                                            value: _Gender,
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
                                            value: _MemberType,
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
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
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
                                            value: _Profession,
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
                                            value: _BloodGroup,
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
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
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
                                            value: _Married,
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
                                            value: _Residencecity,
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
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
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
                                            value: _Officecity,
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
                                            value: _Nativecity,
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
                    // Container(
                    //   margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    //   child: Column(
                    //     children: <Widget>[
                    //       Row(
                    //         children: <Widget>[
                    //           Flexible(
                    //             child: Row(
                    //               children: <Widget>[
                    //                 Container(
                    //                   child: Text(
                    //                     "Special Info. :",
                    //                     style: TextStyle(
                    //                         fontWeight: FontWeight.bold,
                    //                         fontSize: 13),
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //           SizedBox(
                    //             width: 10,
                    //           ),
                    //           Flexible(
                    //             child: Row(
                    //               children: <Widget>[
                    //                 Container(
                    //                   child: Text(
                    //                     "Income Level :",
                    //                     style: TextStyle(
                    //                         fontWeight: FontWeight.bold,
                    //                         fontSize: 13),
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //       SizedBox(
                    //         height: 5,
                    //       ),
                    //       Row(
                    //         children: <Widget>[
                    //           Flexible(
                    //             child: Column(
                    //               crossAxisAlignment:
                    //               CrossAxisAlignment.start,
                    //               children: <Widget>[
                    //                 FutureBuilder<List<SpecialTypeList>>(
                    //                   future: getSpecialTypeList(),
                    //                   builder: (context, snapshot) {
                    //                     if (!snapshot.hasData)
                    //                       return Center(
                    //                           child: CircularProgressIndicator());
                    //                     return DropdownButtonFormField(
                    //                         isExpanded: true,
                    //                         hint: Text("ALL",
                    //                             style: TextStyle(
                    //                                 fontWeight: FontWeight.w600,
                    //                                 fontSize: 15),
                    //                                 maxLines: 1),
                    //                         style: TextStyle(fontSize: 16),
                    //                         value: _SpecialInfo,
                    //                         items: snapshot.data.map((data) {
                    //                           return new DropdownMenuItem(
                    //                             child: new Text(
                    //                               data.SpecialName,
                    //                               style: TextStyle(
                    //                                 fontSize: 15,
                    //                                 color: Colors.black,
                    //                                 fontWeight: FontWeight.w600,
                    //                               ),
                    //                             ),
                    //                             value: data.SpecialName,
                    //                           );
                    //                         }).toList(),
                    //                         onChanged: (newVal) {
                    //                           setState(() {
                    //                             _SpecialInfo = newVal;
                    //                           });
                    //                         },
                    //                         decoration:
                    //                         InputDecoration(
                    //                             border: InputBorder.none,
                    //                             fillColor: Color(0xfff3f3f4),
                    //                             filled: true),
                    //                     );
                    //                   },
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //           SizedBox(
                    //             width: 10,
                    //           ),
                    //           Expanded(
                    //             child: Column(
                    //               crossAxisAlignment:
                    //               CrossAxisAlignment.start,
                    //               children: <Widget>[
                    //                 FutureBuilder<List<IncomeLevelTypeList>>(
                    //                   future: getIncomeLevelTypeList(),
                    //                   builder: (context, snapshot) {
                    //                     if (!snapshot.hasData)
                    //                       return Center(
                    //                           child: CircularProgressIndicator());
                    //                     return DropdownButtonFormField(
                    //                         isExpanded: true,
                    //                         hint: Text("ALL",
                    //                             style: TextStyle(
                    //                                 fontWeight: FontWeight.w600,
                    //                                 fontSize: 15),
                    //                                 maxLines: 1),
                    //                         style: TextStyle(fontSize: 16),
                    //                         value: _PovertyLevel,
                    //                         items: snapshot.data.map((data) {
                    //                           return new DropdownMenuItem(
                    //                             child: new Text(
                    //                               data.TypeName,
                    //                               style: TextStyle(
                    //                                 fontSize: 15,
                    //                                 color: Colors.black,
                    //                                 fontWeight:
                    //                                 FontWeight.w600,
                    //                               ),
                    //                             ),
                    //                             value: data.TypeName,
                    //                           );
                    //                         }).toList(),
                    //                         onChanged: (newVal) {
                    //                           setState(() {
                    //                             _PovertyLevel = newVal;
                    //                           });
                    //                         },
                    //                         decoration: InputDecoration(
                    //                             border: InputBorder.none,
                    //                             fillColor:
                    //                             Color(0xfff3f3f4),
                    //                             filled: true),
                    //                     );
                    //                   },
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
            Card(
              // margin: new EdgeInsets.fromLTRB(5, 5, 5, 0),
              child: InkWell(
                onTap: (){
                  if (_isLoading == false) {
                    final form = formKey.currentState;
                      setState(() => _isLoading = true);
                      form.save();
                      print(_Gautra);
                      print(_NativePlace.toString());
                      print(_Gender);
                      print(_MemberType);
                      print(_Profession.toString());
                      print(_BloodGroup);
                      print(_Married);
                      print(_Officecity.toString());
                      print(_Nativecity.toString());

                      _netUtil.post(RestDatasource.GET_MEMBER_FILTER, body: {
                        "txtgautra": _Gautra.toString() == null ? "0" : _Gautra.toString(),
                        "txtnative": _NativePlace.toString() == null ? "0" : _NativePlace.toString(),
                         "txtgender": _Gender.toString() == "ALL" ? "0" : _Gender.toString(),
                        "txttype": _MemberType.toString() == "ALL" ? "0" : _MemberType.toString(),
                        "txtprofession": _Profession.toString() == null ? "0" : _Profession.toString(),
                        "txtbloodgroup": _BloodGroup.toString() == "ALL" ? "0" : _BloodGroup.toString(),
                        "txtmar": _Married.toString() == "ALL" ? "0" : _Married.toString(),
                        "txtocity": _Officecity.toString() == null ? "0" : _Officecity.toString(),
                        "txtncity": _Nativecity.toString() == null ? "0" : _Nativecity.toString(),

                        }).then((dynamic res) async {
                        if (res["status"] == "yes") {
                          formKey.currentState.reset();
                          // final items = res.cast<Map<String, dynamic>>();
                          // List<Members> listofusers = items.map<Members>((json) {
                          //   return Members.fromJson(json);
                          // }).toList();
                          // List<Members> revdata = listofusers.reversed.toList();
                          // return revdata;

                          setState(() => _isLoading = false);
                          Navigator.of(context)
                              .pushReplacementNamed('/home');
                        } else {
                          FlashHelper.errorBar(context,
                              message: "Something Went Wrong!...");
                          setState(() => _isLoading = false);
                        }
                      });
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
                  child:_isLoading
                      ? new CircularProgressIndicator(
                      backgroundColor: Colors.white)
                      : Text(
                    'SEARCH',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
