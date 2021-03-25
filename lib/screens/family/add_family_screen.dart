import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nakoda_group/data/rest_ds.dart';
import 'package:nakoda_group/models/blood_group_type_list.dart';
import 'package:nakoda_group/models/city_list.dart';
import 'package:nakoda_group/models/education_List.dart';
import 'package:nakoda_group/models/gautra_list.dart';
import 'package:nakoda_group/models/nanihal_native_Place_List.dart';
import 'package:nakoda_group/models/income_level_type_list.dart';
import 'package:nakoda_group/models/relation_type_list.dart';
import 'package:nakoda_group/models/sasural_native_place_List.dart';
import 'package:nakoda_group/models/special_type_list.dart';
import 'package:nakoda_group/models/state_list.dart';
import 'package:nakoda_group/utils/connectionStatusSingleton.dart';
import 'package:nakoda_group/utils/flash_helper.dart';
import 'package:nakoda_group/utils/internetconnection.dart';
import 'package:nakoda_group/utils/network_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddFamilyScreen extends StatefulWidget {
  @override
  _AddFamilyScreen createState() => _AddFamilyScreen();
}

class _AddFamilyScreen extends State<AddFamilyScreen> {
  BuildContext _ctx;
  NetworkUtil _netUtil = new NetworkUtil();
  SharedPreferences prefs;
  bool _isLoading = false;
  final formKey = new GlobalKey<FormState>();

  String _FirstName,
      _MiddleName,
      _LastName,
      _Height,
      _BirthDate,
      _IncomeLevel,
      _FamilyRelation,
      _Education,_EducationName,
      _SpecialInfo,
      _naihalnativeplace,
      _NanihalGautra,
      _NanihalBusinessCity,
      _BloodGroup,
      _MobileNo,
      _SasuralGautra,
      _SasuralNative,
      _SasuralBusinessCity,
      _AnniversaryDate,
      _AnniversaryDate1,
      _FirmName,
      _FirmWebsite,
      _FirmEmailId,
      _FirmBlock,
      _FirmNumber,
      _FirmFloor,
      _FirmAddress,
      _FirmLandmark,
      _OfficeCompanyname,
      _Officedesignation,
      _OfficeSince,
      _FirmMobileNo,
      _FirmTelephoneNo,
      _FirmPincode,
      ostate,
      _ocity;

  int _GenderRadioValue = 0, _MarriedRadioValue = 0, _WorkingRadioValue = 0;

  String AnniversaryDate;

  bool _isMarried = true;
  bool _isWorking = true;
  var focusNode = FocusNode();

  File imageURI;
  bool _isImageUploaded = false;

  TextEditingController FirstName = TextEditingController();
  TextEditingController MiddleName = TextEditingController();
  TextEditingController NanihalGautra = TextEditingController();
  TextEditingController NanihalBusinessCity = TextEditingController();
  TextEditingController MobileNumber = TextEditingController();

  TextEditingController EducationName = TextEditingController();

  var __birthDatetextControlle = TextEditingController();
  var __anniversarytextControlle = TextEditingController();
  var __anniversaryDatetextControlle = TextEditingController();
  var _HEightController = TextEditingController();
  var _SasuralGutraController = TextEditingController();

  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();
  FocusNode focusNode4 = FocusNode();
  FocusNode focusNode5 = FocusNode();
  FocusNode focusNode6 = FocusNode();

  DateTime selectedDate = DateTime.now();
  DateTime selectedAnniversaryDate = DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1950, 1),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        __birthDatetextControlle.text = DateFormat('dd-MM-yyyy').format(picked);
        selectedDate = picked;
      });
  }

  Future<Null> _selectAnniversaryDate(BuildContext context) async {
    prefs = await SharedPreferences.getInstance();
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate:selectedAnniversaryDate,
      firstDate: DateTime(1950, 1),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedAnniversaryDate)
      setState(() {
        __anniversarytextControlle.text =
            DateFormat('dd-MM-yyyy').format(picked);
        selectedAnniversaryDate = picked;
      });
  }

  //Dynamic Data
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

  Future<List<NativePlaceList>> naihalnativePlaceListdata;
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

  Future<List<SasuralNativePlaceList>> sasuralnativePlaceListdata;
  Future<List<SasuralNativePlaceList>> _getsasuralnativePlaceListData() async {
    return _netUtil.post(RestDatasource.URL_NATIVE_PLACE_LIST).then((dynamic res) {
      final items = res.cast<Map<String, dynamic>>();
      List<SasuralNativePlaceList> listofusers = items.map<SasuralNativePlaceList>((json) {
        return SasuralNativePlaceList.fromJson(json);
      }).toList();
      List<SasuralNativePlaceList> revdata = listofusers.toList();
      return revdata;
    });
  }

  Future<List<EducationList>> educationListdata;
  Future<List<EducationList>> _geteducationListData() async {
    return _netUtil.post(RestDatasource.URL_EDUCATION_LIST).then((dynamic res) {
      final items = res.cast<Map<String, dynamic>>();
      List<EducationList> listofusers = items.map<EducationList>((json) {
        return EducationList.fromJson(json);
      }).toList();
      List<EducationList> revdata = listofusers.toList();
      return revdata;
    });
  }

  Future<List<StateList>> stateListdata;
  Future<List<StateList>> _getStateListData() async {
    return _netUtil.post(RestDatasource.URL_STATE_LIST).then((dynamic res) {
      final items = res.cast<Map<String, dynamic>>();
      List<StateList> listofusers = items.map<StateList>((json) {
        return StateList.fromJson(json);
      }).toList();
      List<StateList> revdata = listofusers.toList();
      return revdata;
    });
  }

  Future<List<CityList>> cityListdata;
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
  //Dynamic Data

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

  //Relation Type List
  Future<List<RelationTypeList>> getRelationTypeList() async {
    List<RelationTypeList> listOfRateType = new List<RelationTypeList>();
    RelationTypeList item1 = new RelationTypeList();
    item1.RelationName = "Grand Father";
    listOfRateType.add(item1);
    RelationTypeList item2 = new RelationTypeList();
    item2.RelationName = "Grand Mother";
    listOfRateType.add(item2);
    RelationTypeList item3 = new RelationTypeList();
    item3.RelationName = "Father";
    listOfRateType.add(item3);
    RelationTypeList item4 = new RelationTypeList();
    item4.RelationName = "Mother";
    listOfRateType.add(item4);
    RelationTypeList item5 = new RelationTypeList();
    item5.RelationName = "Husband";
    listOfRateType.add(item5);
    RelationTypeList item6 = new RelationTypeList();
    item6.RelationName = "Wife";
    listOfRateType.add(item6);
    RelationTypeList item7 = new RelationTypeList();
    item7.RelationName = "Son";
    listOfRateType.add(item7);
    RelationTypeList item8 = new RelationTypeList();
    item8.RelationName = "Daughter";
    listOfRateType.add(item8);
    RelationTypeList item9 = new RelationTypeList();
    item9.RelationName = "Brother";
    listOfRateType.add(item9);
    RelationTypeList item10 = new RelationTypeList();
    item10.RelationName = "Sister";
    listOfRateType.add(item10);
    RelationTypeList item11 = new RelationTypeList();
    item11.RelationName = "Grand Son";
    listOfRateType.add(item11);
    RelationTypeList item12 = new RelationTypeList();
    item12.RelationName = "Grand Daughter";
    listOfRateType.add(item12);
    RelationTypeList item13 = new RelationTypeList();
    item13.RelationName = "Daughter In Law";
    listOfRateType.add(item13);
    RelationTypeList item14 = new RelationTypeList();
    item14.RelationName = "Brother In Law";
    listOfRateType.add(item14);
    RelationTypeList item15 = new RelationTypeList();
    item15.RelationName = "Father In Law";
    listOfRateType.add(item15);
    RelationTypeList item16 = new RelationTypeList();
    item16.RelationName = "Mother In Law";
    listOfRateType.add(item16);
    RelationTypeList item17 = new RelationTypeList();
    item17.RelationName = "Sister In Law";
    listOfRateType.add(item17);
    RelationTypeList item18 = new RelationTypeList();
    item18.RelationName = "Brother Son";
    listOfRateType.add(item18);
    RelationTypeList item19 = new RelationTypeList();
    item19.RelationName = "Brother Daughter";
    listOfRateType.add(item19);
    return listOfRateType.toList();
  }
  //Relation Type List

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

  //Blood Group Type List
  Future<List<BloodGroupTypeList>> getBloodGroupTypeList() async {
    List<BloodGroupTypeList> listOfRateType = new List<BloodGroupTypeList>();
    BloodGroupTypeList item1 = new BloodGroupTypeList();
    item1.BloodGroupName = "A+";
    listOfRateType.add(item1);
    BloodGroupTypeList item2 = new BloodGroupTypeList();
    item2.BloodGroupName = "B+";
    listOfRateType.add(item2);
    BloodGroupTypeList item3 = new BloodGroupTypeList();
    item3.BloodGroupName = "O+";
    listOfRateType.add(item3);
    BloodGroupTypeList item4 = new BloodGroupTypeList();
    item4.BloodGroupName = "A-";
    listOfRateType.add(item4);
    BloodGroupTypeList item5 = new BloodGroupTypeList();
    item5.BloodGroupName = "B-";
    listOfRateType.add(item5);
    BloodGroupTypeList item6 = new BloodGroupTypeList();
    item6.BloodGroupName = "O-";
    listOfRateType.add(item6);
    BloodGroupTypeList item7 = new BloodGroupTypeList();
    item7.BloodGroupName = "NOT AVAILABLE";
    listOfRateType.add(item7);
    return listOfRateType.toList();
  }
  //Blood Group Type List

  _loadPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      gautraListdata = _getGautraListData();
      educationListdata = _geteducationListData();
      naihalnativePlaceListdata = _getnativePlaceListData();
      sasuralnativePlaceListdata = _getsasuralnativePlaceListData();
      stateListdata = _getStateListData();
      cityListdata = _getCityListData();

      AnniversaryDate = prefs.getString("AniversaryDate").toString();
      DateFormat dateFormat = DateFormat("yyyy-MM-dd");
      DateTime dateTime = dateFormat.parse(AnniversaryDate);
      String sdate = DateFormat('dd-MM-yyyy').format(dateTime);
      __anniversaryDatetextControlle.text = sdate;
      _AnniversaryDate1 = sdate;
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
    _ctx = context;
    if (isOffline) {
      return connection.nointernetconnection();
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Add Family Member'),
        ),
        body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      Card(
                        elevation: 3.0,
                        margin: new EdgeInsets.only(bottom: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.fromLTRB(10, 10, 15, 5),
                              child: Text(
                                "PERSONAL DETAILS : ",
                                style: TextStyle(
                                  color: Colors.grey.shade800,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Divider(
                              indent: 10,
                              endIndent: 10,
                              color: Colors.grey,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10, right: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Full Name :",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Flexible(
                                        child: TextFormField(
                                          controller: FirstName,
                                          focusNode: focusNode1,
                                             obscureText: false,
                                             keyboardType: TextInputType.text,
                                             onSaved: (val) => _FirstName = val,
                                          validator: (value) => (value == null || value == "")
                                                    ? 'Enter First Name'
                                                    : null,
                                              style: TextStyle(fontSize: 14),
                                              decoration: InputDecoration(
                                              hintText: "First Name",
                                              border: InputBorder.none,
                                              fillColor: Color(0xfff3f3f4),
                                              filled: true,
                                             ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Flexible(
                                        child: TextFormField(
                                          controller: MiddleName,
                                          focusNode: focusNode2,
                                            obscureText: false,
                                            keyboardType: TextInputType.text,
                                            onSaved: (val) => _MiddleName = val,
                                            validator: (value) => (value == null || value == "")
                                                    ? 'Enter Middle Name'
                                                    : null,
                                            style: TextStyle(fontSize: 14),
                                            decoration: InputDecoration(
                                              hintText: "Middle Name",
                                              border: InputBorder.none,
                                              fillColor: Color(0xfff3f3f4),
                                              filled: true,
                                            ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Gautra :",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            FutureBuilder<List<GautraList>>(
                                              future: gautraListdata,
                                              builder: (context, snapshot) {
                                                if (!snapshot.hasData)
                                                  return Center(
                                                      child: CircularProgressIndicator()
                                                      );
                                                return DropdownButtonFormField(
                                                    isExpanded: true,
                                                    hint: Text("Select Gautra",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.w600,
                                                            fontSize: 15),
                                                            maxLines: 1),
                                                    style: TextStyle(fontSize: 16),
                                                    value: _LastName,
                                                    validator: (value) =>
                                                        value == null
                                                            ? 'Select Gautra'
                                                            : null,
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
                                                        _LastName = newVal;
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
                                        child: Row(
                                          children: <Widget>[],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin:
                                  EdgeInsets.only(left: 10, top: 10, right: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Gender :",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13),
                                  ),
                                  Table(
                                    children: [
                                      TableRow(children: [
                                        TableCell(
                                            child: new Row(
                                          children: <Widget>[
                                            new Radio(
                                              value: 0,
                                              activeColor: Colors.red,
                                              groupValue: _GenderRadioValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  _GenderRadioValue = value;
                                                });
                                              },
                                            ),
                                            new Text(
                                              'Male',
                                              style: new TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 16.0),
                                            ),
                                            new Radio(
                                              value: 1,
                                              activeColor: Colors.red,
                                              groupValue: _GenderRadioValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  _GenderRadioValue = value;
                                                });
                                              },
                                            ),
                                            new Text(
                                              'Female',
                                              style: new TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 16.0),
                                            )
                                          ],
                                        ),
                                        ),
                                      ]),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin:
                                  EdgeInsets.only(left: 10, top: 10, right: 10),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Flexible(
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              child: Text(
                                                "DOB :",
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
                                                "Income Level :",
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
                                        child: TextFormField(
                                            controller: __birthDatetextControlle,
                                            focusNode: focusNode6,
                                            readOnly: true,
                                            obscureText: false,
                                            keyboardType: TextInputType.text,
                                            onSaved: (val) => _BirthDate = val,
                                            validator: (value) =>
                                                (value == null || value == "")
                                                    ? 'Select Birth Date'
                                                    : null,
                                            style: TextStyle(fontSize: 15),
                                            onTap: (){
                                              _selectDate(context);
                                            },
                                            decoration: InputDecoration(
                                              hintText: "Select Date",
                                              suffixIcon: IconButton(
                                                  icon: Icon(Icons.date_range,
                                                      color: Colors.grey),
                                                  onPressed: () {

                                                  }),
                                              border: InputBorder.none,
                                              fillColor: Color(0xfff3f3f4),
                                              filled: true,
                                            ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            FutureBuilder<List<IncomeLevelTypeList>>(
                                              future: getIncomeLevelTypeList(),
                                              builder: (context, snapshot) {
                                                if (!snapshot.hasData)
                                                  return Center(
                                                      child: CircularProgressIndicator());
                                                return DropdownButtonFormField(
                                                    isExpanded: true,
                                                    hint: Text(
                                                        "Select Income Level",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.w600,
                                                            fontSize: 15),
                                                        maxLines: 1),
                                                    style: TextStyle(fontSize: 16),
                                                    value: _IncomeLevel,
                                                    validator: (value) => value == null
                                                        ? 'Select Income Level'
                                                        : null,
                                                    items:
                                                        snapshot.data.map((data) {
                                                      return new DropdownMenuItem(
                                                        child: new Text(
                                                          data.TypeName.toString(),
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                        value: data.TypeName.toString(),
                                                      );
                                                    }).toList(),
                                                    onChanged: (newVal) {
                                                      setState(() {
                                                        _IncomeLevel = newVal;
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
                              margin:
                                  EdgeInsets.only(left: 10, top: 10, right: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Relation with main member :",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      FutureBuilder<List<RelationTypeList>>(
                                        future: getRelationTypeList(),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData)
                                            return Center(
                                                child: CircularProgressIndicator());
                                          return DropdownButtonFormField(
                                            isExpanded: true,
                                            hint: Text("Select Relation",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 15),
                                                maxLines: 1),
                                            style: TextStyle(fontSize: 16),
                                            value: _FamilyRelation,
                                            validator: (value) => value == null
                                                ? 'Select Relation'
                                                : null,
                                            items: snapshot.data.map((data) {
                                              return new DropdownMenuItem(
                                                child: new Text(
                                                  data.RelationName,
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                value: data.RelationName,
                                              );
                                            }).toList(),
                                            onChanged: (newVal) {
                                              setState(() {
                                                _FamilyRelation = newVal;
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
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10, top: 10, right: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Education :",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      FutureBuilder<List<EducationList>>(
                                        future: educationListdata,
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData)
                                            return Center(
                                                child: CircularProgressIndicator()
                                            );
                                          return DropdownButtonFormField(
                                            isExpanded: true,
                                            hint: Text("Select Education",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 15),
                                                    maxLines: 1),
                                            style: TextStyle(fontSize: 16),
                                            value: _Education,
                                            validator: (value) => value == null
                                                ? 'Select Education'
                                                : null,
                                            items: snapshot.data.map((data) {
                                              return new DropdownMenuItem(
                                                child: new Text(
                                                  data.EducationName,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black),
                                                ),
                                                value: data.Education_id,
                                              );
                                            }).toList(),
                                            onChanged: (newVal) {
                                              setState(() {
                                                _Education = newVal;
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
                                  SizedBox(
                                    height: 5,
                                    ),
                                      Container(
                                        child: (_Education == "1")
                                          ? Row(
                                        children: <Widget>[
                                          Flexible(
                                            child: TextFormField(
                                              controller: EducationName,
                                              obscureText: false,
                                              keyboardType: TextInputType.text,
                                              onSaved: (val) => _EducationName = val,
                                              style: TextStyle(fontSize: 14),
                                              decoration: InputDecoration(
                                                hintText: "Enter Education",
                                                border: InputBorder.none,
                                                fillColor: Color(0xfff3f3f4),
                                                filled: true,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                          : Container(),
                                      )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10, top: 10, right: 10),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Flexible(
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              child: Text(
                                                "Special Info. :",
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
                                                "Nanihal Gautra :",
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
                                            FutureBuilder<List<SpecialTypeList>>(
                                              future: getSpecialTypeList(),
                                              builder: (context, snapshot) {
                                                if (!snapshot.hasData)
                                                  return Center(
                                                      child:
                                                          CircularProgressIndicator());
                                                return DropdownButtonFormField(
                                                    isExpanded: true,
                                                    hint: Text(
                                                        "Select Special Info.",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 15),
                                                        maxLines: 1),
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                    value: _SpecialInfo,
                                                    items: snapshot.data.map((data) {
                                                      return new DropdownMenuItem(
                                                        child: new Text(
                                                          data.SpecialName,
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        value: data.SpecialName,
                                                      );
                                                    }).toList(),
                                                    onChanged: (newVal) {
                                                      setState(() {
                                                        _SpecialInfo = newVal;
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
                                        child: TextFormField(
                                          controller: NanihalGautra,
                                          focusNode: focusNode3,
                                            obscureText: false,
                                            keyboardType: TextInputType.text,
                                          onSaved: (val) => _NanihalGautra = val,
                                            validator: (value) =>
                                                (value == null || value == "")
                                                    ? 'Enter Nanihal Gautra'
                                                    : null,
                                            style: TextStyle(fontSize: 14),
                                            decoration: InputDecoration(
                                              hintText: "Nanihal Gautra",
                                              border: InputBorder.none,
                                              fillColor: Color(0xfff3f3f4),
                                              filled: true,
                                            ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin:
                                  EdgeInsets.only(left: 10, top: 10, right: 10),
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
                                                "Nanihal Native :",
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
                                                "Nanihal BusinessCity :",
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
                                            FutureBuilder<List<NativePlaceList>>(
                                              future: naihalnativePlaceListdata,
                                              builder: (context, snapshot) {
                                                if (!snapshot.hasData)
                                                  return Center(
                                                      child:
                                                      CircularProgressIndicator());
                                                return DropdownButtonFormField(
                                                    isExpanded: true,
                                                    hint: Text("Nanihal Native",
                                                        style: TextStyle(
                                                            fontWeight:
                                                            FontWeight.w600,
                                                            fontSize: 15),
                                                        maxLines: 1),
                                                    style:
                                                    TextStyle(fontSize: 16),
                                                    value: _naihalnativeplace,
                                                    validator: (value) =>
                                                    value == null
                                                        ? 'Select Nanihal Native'
                                                        : null,
                                                    items:
                                                    snapshot.data.map((data) {
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
                                                        _naihalnativeplace = newVal;
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
                                        child: TextFormField(
                                          controller: NanihalBusinessCity,
                                          focusNode: focusNode4,
                                            obscureText: false,
                                            keyboardType: TextInputType.text,
                                            onSaved: (val) => _NanihalBusinessCity = val,
                                            validator: (value) => (value == null || value == "")
                                                    ? 'Enter Nanihal BusinessCity'
                                                    : null,
                                            style: TextStyle(fontSize: 14),
                                            decoration: InputDecoration(
                                              hintText: "Nanihal BusinessCity",
                                              border: InputBorder.none,
                                              fillColor: Color(0xfff3f3f4),
                                              filled: true,
                                            ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin:
                                  EdgeInsets.only(left: 10, top: 10, right: 10),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
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
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Flexible(
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              child: Text(
                                                "Mobile No :",
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
                                            FutureBuilder<List<BloodGroupTypeList>>(
                                              future: getBloodGroupTypeList(),
                                              builder: (context, snapshot) {
                                                if (!snapshot.hasData)
                                                  return Center(
                                                      child: CircularProgressIndicator(),
                                                  );
                                                return DropdownButtonFormField(
                                                    isExpanded: true,
                                                    hint: Text(
                                                        "Select Blood Group",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
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
                                                            fontWeight: FontWeight.w600,
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
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Flexible(
                                        child: TextFormField(
                                          controller: MobileNumber,
                                          focusNode: focusNode5,
                                            obscureText: false,
                                            keyboardType: TextInputType.phone,
                                          onSaved: (val) => _MobileNo = val,
                                            validator: (value) => value.trim().length != 10
                                                ? 'Mobile Number must be of 10 digit'
                                                : null,
                                            style: TextStyle(fontSize: 14),
                                            decoration: InputDecoration(
                                              hintText: "Mobile No",
                                              border: InputBorder.none,
                                              fillColor: Color(0xfff3f3f4),
                                              filled: true,
                                            ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10, top: 10, right: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Married :",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13),
                                  ),
                                  Table(
                                    children: [
                                      TableRow(
                                          children: [
                                           TableCell(
                                             child: new Row(
                                              children: <Widget>[
                                                new Radio(
                                                value: 0,
                                                activeColor: Colors.red,
                                                groupValue: _MarriedRadioValue,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _MarriedRadioValue = value;
                                                    _isMarried = true;
                                                  });
                                                },
                                              ),
                                              new Text(
                                                'Yes',
                                                style: new TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 16.0),
                                              ),
                                                (_FamilyRelation == "Wife" || _FamilyRelation == "Husband")
                                                    ? new Container() :
                                              new Radio(
                                                value: 1,
                                                activeColor: Colors.red,
                                                groupValue: _MarriedRadioValue,
                                                onChanged: (value) {
                                                  setState(() {
                                                         _MarriedRadioValue = value;
                                                         _isMarried = false;
                                                  });
                                                },
                                              ),
                                                (_FamilyRelation == "Wife" || _FamilyRelation == "Husband")
                                                    ? new Container() :
                                                new Text(
                                                'No',
                                                style: new TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 16.0),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ]),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            (_isMarried)
                             ? Container(
                                child: {"Grand Mother","Mother","Husband","Wife","Brother In Law", "Daughter In Law","Father In Law","Mother In Law","Sister In Law"}.contains(_FamilyRelation)
                                    ? Column(
                                       children: <Widget>[
                                       Container(
                                         margin: EdgeInsets.only(left: 10, top: 10, right: 10),
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
                                                        "Anniversary Date :",
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
                                                  children: <Widget>[],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: <Widget>[
                                              //anniversarydate
                                              Flexible(
                                                child: TextFormField(
                                                  controller:
                                                  (_FamilyRelation == "Wife" || _FamilyRelation == "Husband")
                                                      ? __anniversaryDatetextControlle
                                                      : __anniversarytextControlle,
                                                  readOnly: true,
                                                  obscureText: false,
                                                  keyboardType: TextInputType.text,
                                                  onSaved: (val) =>
                                                  (_FamilyRelation == "Wife" || _FamilyRelation == "Husband")
                                                      ? _AnniversaryDate1 = val
                                                      :_AnniversaryDate = val,
                                                  style: TextStyle(fontSize: 15),
                                                  onTap: (){
                                                    _selectAnniversaryDate(context);
                                                  },
                                                  decoration: InputDecoration(
                                                    hintText: "Select Date",
                                                    suffixIcon: IconButton(
                                                        icon: Icon(Icons.date_range,
                                                            color: Colors.grey),
                                                        onPressed: () {}),
                                                    border: InputBorder.none,
                                                    fillColor: Color(0xfff3f3f4),
                                                    filled: true,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Flexible(
                                                child: Row(
                                                  children: <Widget>[],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                                    : Column(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: 10, top: 10, right: 10),
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
                                                        "Sasural Gautra :",
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
                                                        "Sasural Native :",
                                                        style: TextStyle(
                                                            fontWeight:
                                                            FontWeight.bold,
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
                                                child: TextFormField(
                                                  controller: _SasuralGutraController,
                                                  obscureText: false,
                                                  keyboardType: TextInputType.text,
                                                  onSaved: (val) => _SasuralGautra = val,
                                                  style: TextStyle(fontSize: 14),
                                                  decoration: InputDecoration(
                                                    hintText: "Sasural Gautra",
                                                    border: InputBorder.none,
                                                    fillColor: Color(0xfff3f3f4),
                                                    filled: true,
                                                  ),
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
                                                    FutureBuilder<List<SasuralNativePlaceList>>(
                                                      future: sasuralnativePlaceListdata,
                                                      builder: (context, snapshot) {
                                                        if (!snapshot.hasData)
                                                          return Center(
                                                            child:
                                                            CircularProgressIndicator(),
                                                          );
                                                        return DropdownButtonFormField(
                                                          isExpanded: true,
                                                          hint: Text("Sasural Native",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                  FontWeight.w600,
                                                                  fontSize: 15),
                                                              maxLines: 1),
                                                          style:
                                                          TextStyle(fontSize: 16),
                                                          value: _SasuralNative,
                                                          items: snapshot.data.map((data) {
                                                            return new DropdownMenuItem(
                                                              child: new Text(data.SasuralNativeName,
                                                                style: TextStyle(
                                                                    fontSize: 16,
                                                                    color:
                                                                    Colors.black),
                                                              ),
                                                              value: data.SasuralNativeId,
                                                            );
                                                          }).toList(),
                                                          onChanged: (newVal) {
                                                            setState(() {
                                                              _SasuralNative = newVal;
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
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: 10, top: 10, right: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Flexible(
                                                child: Row(
                                                  children: <Widget>[
                                                    Container(
                                                      child: Text(
                                                        "Sasural BusinessCity :",
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
                                                        "Anniversary Date :",
                                                        style: TextStyle(
                                                            fontWeight:
                                                            FontWeight.bold,
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
                                                child: TextFormField(
                                                  obscureText: false,
                                                  keyboardType: TextInputType.text,
                                                  onSaved: (val) => _SasuralBusinessCity = val,
                                                  style: TextStyle(fontSize: 14),
                                                  decoration: InputDecoration(
                                                    hintText:
                                                    "Sasural BusinessCity",
                                                    border: InputBorder.none,
                                                    fillColor: Color(0xfff3f3f4),
                                                    filled: true,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              //anniversarydate
                                              Flexible(
                                                child: TextFormField(
                                                  controller:
                                                  (_FamilyRelation == "Wife")
                                                      ?__anniversaryDatetextControlle
                                                      : __anniversarytextControlle,
                                                  readOnly: true,
                                                  obscureText: false,
                                                  keyboardType: TextInputType.text,
                                                  onSaved: (val) =>
                                                  (_FamilyRelation == "Wife")
                                                      ? _AnniversaryDate1 = val
                                                      :_AnniversaryDate = val,
                                                  style: TextStyle(fontSize: 15),
                                                  onTap: (){
                                                    _selectAnniversaryDate(context);
                                                  },
                                                  decoration: InputDecoration(
                                                    hintText: "Select Date",
                                                    suffixIcon: IconButton(
                                                        icon: Icon(Icons.date_range,
                                                            color: Colors.grey),
                                                        onPressed: () {
                                                          // _selectAnniversaryDate(context);
                                                        }),
                                                    border: InputBorder.none,
                                                    fillColor: Color(0xfff3f3f4),
                                                    filled: true,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                                     )
                             : Container(
                              child:Column(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: 10, top: 10, right: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Flexible(
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                    child: Text(
                                                      "Height :",
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
                                                children: <Widget>[],
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
                                              child: TextFormField(
                                                controller: _HEightController,
                                                obscureText: false,
                                                keyboardType: TextInputType.text,
                                                onSaved: (val) => _Height = val,
                                                validator: (value) => (value == null || value == "")
                                                    ? 'Enter Your Height'
                                                    : null,
                                                style: TextStyle(fontSize: 14),
                                                decoration: InputDecoration(
                                                  hintText: "Enter Height",
                                                  border: InputBorder.none,
                                                  fillColor: Color(0xfff3f3f4),
                                                  filled: true,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Flexible(
                                              child: Row(
                                                children: <Widget>[],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: 10, top: 10, right: 10, bottom: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Upload your photo :",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey),
                                                borderRadius: BorderRadius.all(Radius.circular(5),
                                                ),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(15.0),
                                              child: Text("Choose Photo"),
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: <Widget>[
                                            SizedBox(
                                              width: 10,
                                            ),
                                            // ignore: deprecated_member_use
                                            RaisedButton(
                                              onPressed: () {
                                                showImageDialog();
                                              },
                                              child: const Text(
                                                'Upload',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              color: Colors.blue.shade700,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: _isImageUploaded,
                                    child: Center(
                                      child: new Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: (imageURI != null)
                                            ? Image.file(
                                                imageURI,
                                                height: 200,
                                                fit: BoxFit.cover,
                                              )
                                            : Container(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                           ],
                         ),
                       ),
                      Card(
                        elevation: 3.0,
                        margin: new EdgeInsets.only(top: 5, bottom: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin:
                              EdgeInsets.only(left: 10, top: 10, right: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Working Type :",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13),
                                  ),
                                  Table(
                                    children: [
                                      TableRow(
                                          children: [
                                            TableCell(
                                              child: new Row(
                                                children: <Widget>[
                                                  new Radio(
                                                    value: 0,
                                                    activeColor: Colors.red,
                                                    groupValue: _WorkingRadioValue,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _WorkingRadioValue = value;
                                                        _isWorking = true;
                                                      });
                                                    },
                                                  ),
                                                  new Text(
                                                    'Business',
                                                    style: new TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 16.0),
                                                  ),
                                                  new Radio(
                                                    value: 1,
                                                    activeColor: Colors.red,
                                                    groupValue: _WorkingRadioValue,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _WorkingRadioValue = value;
                                                        _isWorking = false;
                                                      });
                                                    },
                                                  ),
                                                  new Text(
                                                    'Job-Service',
                                                    style: new TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 16.0),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ]),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            (_isWorking)
                                ? Column(
                              children: [
                                Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.fromLTRB(10, 10, 0, 5),
                                child: Text(
                                  "YOUR BUSINESS DETAILS : ",
                                  style: TextStyle(
                                    color: Colors.grey.shade800,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Divider(
                                color: Colors.grey,
                                endIndent: 10,
                                indent: 10,
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10, right: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Firm Name :",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    TextFormField(
                                      obscureText: false,
                                      keyboardType: TextInputType.text,
                                      onSaved: (val) => _FirmName = val,
                                      style: TextStyle(fontSize: 14),
                                      decoration: InputDecoration(
                                        hintText: "Firm Name",
                                        border: InputBorder.none,
                                        fillColor: Color(0xfff3f3f4),
                                        filled: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin:
                                EdgeInsets.only(left: 10, top: 10, right: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Firm Website :",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    TextFormField(
                                      obscureText: false,
                                      keyboardType: TextInputType.text,
                                      onSaved: (val) => _FirmWebsite = val,
                                      style: TextStyle(fontSize: 14),
                                      decoration: InputDecoration(
                                        hintText: "Firm Website",
                                        border: InputBorder.none,
                                        fillColor: Color(0xfff3f3f4),
                                        filled: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin:
                                EdgeInsets.only(left: 10, top: 10, right: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Firm Email Id :",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    TextFormField(
                                      obscureText: false,
                                      keyboardType: TextInputType.emailAddress,
                                      onSaved: (val) => _FirmEmailId = val,
                                      // validator: validateEmail,
                                      style: TextStyle(fontSize: 14),
                                      decoration: InputDecoration(
                                        hintText: "Firm Email Id",
                                        border: InputBorder.none,
                                        fillColor: Color(0xfff3f3f4),
                                        filled: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin:
                                EdgeInsets.only(left: 10, top: 10, right: 10),
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
                                                  "Block :",
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
                                                  "Number :",
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
                                                  "Floor :",
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
                                          child: TextFormField(
                                              obscureText: false,
                                              keyboardType: TextInputType.text,
                                              onSaved: (val) => _FirmBlock = val,
                                              style: TextStyle(fontSize: 14),
                                              decoration: InputDecoration(
                                                hintText: "Block",
                                                border: InputBorder.none,
                                                fillColor: Color(0xfff3f3f4),
                                                filled: true,
                                              ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          child: TextFormField(
                                              obscureText: false,
                                              keyboardType: TextInputType.number,
                                              onSaved: (val) => _FirmNumber = val,
                                              style: TextStyle(fontSize: 14),
                                              decoration: InputDecoration(
                                                hintText: "Number",
                                                border: InputBorder.none,
                                                fillColor: Color(0xfff3f3f4),
                                                filled: true,
                                              ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          child: TextFormField(
                                            obscureText: false,
                                            keyboardType: TextInputType.number,
                                            onSaved: (val) => _FirmFloor = val,
                                            style: TextStyle(fontSize: 14),
                                            decoration: InputDecoration(
                                              hintText: "Floor",
                                              border: InputBorder.none,
                                              fillColor: Color(0xfff3f3f4),
                                              filled: true,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin:
                                EdgeInsets.only(left: 10, top: 10, right: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Address :",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    TextFormField(
                                      obscureText: false,
                                      keyboardType: TextInputType.multiline,
                                      maxLines: 4,
                                      onSaved: (val) => _FirmAddress = val,
                                      style: TextStyle(fontSize: 14),
                                      decoration: InputDecoration(
                                        hintText: "Address",
                                        border: InputBorder.none,
                                        fillColor: Color(0xfff3f3f4),
                                        filled: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin:
                                EdgeInsets.only(left: 10, top: 10, right: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Landmark :",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    TextFormField(
                                      obscureText: false,
                                      keyboardType: TextInputType.text,
                                      onSaved: (val) => _FirmLandmark = val,
                                      style: TextStyle(fontSize: 14),
                                      decoration: InputDecoration(
                                        hintText: "Landmark",
                                        border: InputBorder.none,
                                        fillColor: Color(0xfff3f3f4),
                                        filled: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin:
                                EdgeInsets.only(left: 10, top: 10, right: 10),
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
                                                  "State :",
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
                                                  "City :",
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
                                              FutureBuilder<List<StateList>>(
                                                future: stateListdata,
                                                builder: (context, snapshot) {
                                                  if (!snapshot.hasData)
                                                    return Center(
                                                        child: CircularProgressIndicator());
                                                  return DropdownButtonFormField(
                                                      isExpanded: true,
                                                      hint: Text("Select State",
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight.w600,
                                                              fontSize: 15),
                                                          maxLines: 1),
                                                      style:
                                                      TextStyle(fontSize: 16),
                                                      value: ostate,
                                                      items: snapshot.data.map((data) {
                                                        return new DropdownMenuItem(
                                                          child: new Text(
                                                            data.StateName,
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                color:
                                                                Colors.black),
                                                          ),
                                                          value: data.StateName,
                                                        );
                                                      }).toList(),
                                                      onChanged: (newVal) {
                                                        setState(() {
                                                          ostate = newVal;
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
                                              FutureBuilder<List<CityList>>(
                                                future: cityListdata,
                                                builder: (context, snapshot) {
                                                  if (!snapshot.hasData)
                                                    return Center(
                                                        child: CircularProgressIndicator(),
                                                    );
                                                  return DropdownButtonFormField(
                                                      isExpanded: true,
                                                      hint: Text("Select City",
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight.w600,
                                                              fontSize: 15),
                                                          maxLines: 1),
                                                      style: TextStyle(fontSize: 16),
                                                      value: _ocity,
                                                      items: snapshot.data.map((data) {
                                                        return new DropdownMenuItem(
                                                          child: new Text(
                                                            data.CityName,
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                color:
                                                                Colors.black),
                                                          ),
                                                          value: data.CityId,
                                                        );
                                                      }).toList(),
                                                      onChanged:( newVal) {
                                                        setState(() {
                                                          _ocity = newVal;
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
                              Container(
                                margin:
                                EdgeInsets.only(left: 10, top: 10, right: 10),
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
                                                  "Mobile No :",
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
                                                  "Telephone No :",
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
                                          child: TextFormField(
                                              obscureText: false,
                                              keyboardType: TextInputType.phone,
                                              onSaved: (val) => _FirmMobileNo = val,
                                              style: TextStyle(fontSize: 14),
                                              decoration: InputDecoration(
                                                hintText: "Mobile No",
                                                border: InputBorder.none,
                                                fillColor: Color(0xfff3f3f4),
                                                filled: true,
                                              ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          child: TextFormField(
                                              obscureText: false,
                                              keyboardType: TextInputType.phone,
                                              onSaved: (val) => _FirmTelephoneNo = val,
                                              style: TextStyle(fontSize: 14),
                                              decoration: InputDecoration(
                                                hintText: "Telephone No",
                                                border: InputBorder.none,
                                                fillColor: Color(0xfff3f3f4),
                                                filled: true,
                                              ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: 10, top: 10, right: 10, bottom: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Pincode :",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    TextFormField(
                                      obscureText: false,
                                      keyboardType: TextInputType.phone,
                                      onSaved: (val) => _FirmPincode = val,
                                      style: TextStyle(fontSize: 14),
                                      decoration: InputDecoration(
                                        hintText: "Pincode",
                                        border: InputBorder.none,
                                        fillColor: Color(0xfff3f3f4),
                                        filled: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],)
                                : Column(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.fromLTRB(10, 10, 0, 5),
                                    child: Text(
                                      "YOUR JOB-SERVICE DETAILS : ",
                                      style: TextStyle(
                                        color: Colors.grey.shade800,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    color: Colors.grey,
                                    indent: 10,
                                    endIndent: 10,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "OfficeCompany Name :",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        TextFormField(
                                          obscureText: false,
                                          keyboardType: TextInputType.text,
                                          onSaved: (val) => _OfficeCompanyname = val,
                                          style: TextStyle(fontSize: 14),
                                          decoration: InputDecoration(
                                            hintText: "Company Name",
                                            border: InputBorder.none,
                                            fillColor: Color(0xfff3f3f4),
                                            filled: true,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin:
                                    EdgeInsets.only(left: 10, top: 10, right: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "Office designation :",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        TextFormField(
                                          obscureText: false,
                                          keyboardType: TextInputType.text,
                                          onSaved: (val) => _Officedesignation = val,
                                          style: TextStyle(fontSize: 14),
                                          decoration: InputDecoration(
                                            hintText: "Office designation",
                                            border: InputBorder.none,
                                            fillColor: Color(0xfff3f3f4),
                                            filled: true,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin:
                                    EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "Office Since :",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        TextFormField(
                                          obscureText: false,
                                          keyboardType: TextInputType.text,
                                          onSaved: (val) => _OfficeSince = val,
                                          validator: validateEmail,
                                          style: TextStyle(fontSize: 14),
                                          decoration: InputDecoration(
                                            hintText: "Office Since",
                                            border: InputBorder.none,
                                            fillColor: Color(0xfff3f3f4),
                                            filled: true,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                            ),
                          ],
                        ),
                      ),
                     ],
                  ),
                ),
                Card(
                  elevation: 3.0,
                  margin: new EdgeInsets.only(top: 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                  child: new InkWell(
                    onTap: () async {
                      if (_isLoading == false) {
                        if (FirstName.text == "") {
                          FocusScope.of(context).requestFocus(focusNode1);
                        } else if (MiddleName.text == "") {
                          FocusScope.of(context).requestFocus(focusNode2);
                        } else if (NanihalGautra.text == "") {
                          FocusScope.of(context).requestFocus(focusNode3);
                        } else if (NanihalBusinessCity.text == "") {
                          FocusScope.of(context).requestFocus(focusNode4);
                        } else if (MobileNumber.text == "") {
                          FocusScope.of(context).requestFocus(focusNode5);
                        } else if (__birthDatetextControlle.text == "")
                        {
                          FocusScope.of(context).requestFocus(focusNode6);
                        }
                        final form = formKey.currentState;
                        if (form.validate()) {
                          setState(() => _isLoading = true);
                          form.save();

                          String base64Image = "";
                          if (imageURI != null) {
                            base64Image = base64Encode(imageURI.readAsBytesSync());
                            print(base64Image);
                          }

                          prefs = await SharedPreferences.getInstance();
                          _netUtil.post(RestDatasource.URL_ADD_FAMILY, body: {
                            //Personal Info
                            "membershipId": prefs.getString("MembershipId"),
                            "txtfirstname": _FirstName.toString() ?? "",
                            "txtmiddlename": _MiddleName.toString() ?? "",
                            "txtlastname": _LastName ?? "",
                            "txtgender": _GenderRadioValue == 0 ? "male" : "female",
                            "txtdob": _BirthDate ?? "",
                            "txtpovlevel": _IncomeLevel ?? "",
                            "txtrelation": _FamilyRelation ?? "",
                            "txteducation": _Education.toString() == null ? "" : _Education.toString(),
                            "txtothereducation": (_Education == "1")
                                 ? _EducationName == null || _EducationName == "" ? "" : _EducationName
                                 : "",
                            "txtspecialinfo": _SpecialInfo ?? "",
                            "txtnanihalgautra": _NanihalGautra ?? "",
                            "txtnanihallnative": _naihalnativeplace.toString() == null ? "" : _naihalnativeplace.toString(),
                            "txtnanihalbusiness": _NanihalBusinessCity ?? "",
                            "txtbloodgroup": _BloodGroup ?? "",
                            "txtcontact": _MobileNo.toString() ?? "",
                            "txtmarried": _MarriedRadioValue == 0 ? "Y" : "N",
                            "txtsauralgautra": _SasuralGautra == null ? "-" : _SasuralGautra,
                            "txtsauralnative": _SasuralNative.toString() == null ? "" : _SasuralNative.toString(),
                            "txtsasuralbusiness": _SasuralBusinessCity == null ? "" : _SasuralBusinessCity,
                            "txtani": (_FamilyRelation == "Wife" || _FamilyRelation == "Husband")
                                ? _AnniversaryDate1 == null ? "" : _AnniversaryDate1
                                : _AnniversaryDate == null ? "" : _AnniversaryDate,
                            "txtheight": _Height.toString() == null ? "" : _Height.toString(),
                            "txtimage": (base64Image.toString() != null) ? base64Image.toString() : "",
                            //Personal Info

                            //Office Info
                            "txtoblockworktype": _WorkingRadioValue == 0 ? "business" : "Job-Service",

                            "txtofficefirmname": _FirmName.toString() == null ? "" : _FirmName.toString(),
                            "txtofficewebsite": _FirmWebsite.toString() == null ? "" : _FirmWebsite.toString(),
                            "txtofficeemail": _FirmEmailId.toString() == null ? "" : _FirmEmailId.toString(),
                            "txtoblock1": _FirmBlock.toString() == null ? "" : _FirmBlock.toString(),
                            "txtoblock2": _FirmNumber.toString() == null ? "" : _FirmNumber.toString(),
                            "txtoblock3": _FirmFloor.toString() == null ? "" : _FirmFloor.toString(),
                            "txtofficeaddress": _FirmAddress.toString() == null ? "" : _FirmAddress.toString(),
                            "txtofficelandmark": _FirmLandmark.toString() == null ? "" : _FirmLandmark.toString(),
                            "txtocity": _ocity.toString() ?? "",
                            "txtofficemobile": _FirmMobileNo.toString()  == null ? "" : _FirmMobileNo.toString(),
                            "txtofficecontact": _FirmTelephoneNo.toString() == null ? "" : _FirmTelephoneNo.toString(),
                            "txtofficepincode": _FirmPincode.toString()  == null ? "" : _FirmPincode.toString(),

                            "txtoblockcompname": _OfficeCompanyname.toString() == null ? "" : _OfficeCompanyname.toString(),
                            "txtoblockdesignation": _Officedesignation.toString() == null ? "" : _Officedesignation.toString(),
                            "txtoblocksince": _OfficeSince.toString() == null ? "" : _OfficeSince.toString(),
                            //Office Info
                          }).then((dynamic res) async {
                            if (res["status"] == "yes") {
                              formKey.currentState.reset();
                              FlashHelper.successBar(context,
                                  message: "Family Member Successsfully added...");
                              setState(() => _isLoading = false
                              );
                              Navigator.of(context).pushReplacementNamed('/home');
                            } else {
                              FlashHelper.successBar(context,
                                  message: "Fail! try again later!...");
                              setState(() => _isLoading = false
                              );
                            }
                          });
                        }
                      }
                    },
                    child: new Container(
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.grey.shade200,
                              offset: Offset(2, 4),
                              blurRadius: 5,
                              spreadRadius: 2)
                        ],
                        color: Colors.red,
                      ),
                      child: _isLoading
                          ? new CircularProgressIndicator(
                              backgroundColor: Colors.white
                                )
                          : Text(
                              'SUBMIT',
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                    ),
                  ),
                ),
               ],
            ),
          ),
      );
    }
  }

  Future getImageFromCamera() async {
    // ignore: deprecated_member_use
    var image = await ImagePicker.pickImage(source: ImageSource.camera, imageQuality: 30);
    setState(() {
      if (image != null) {
        imageURI = image;
        _isImageUploaded = true;
      }
    });
    Navigator.pop(context);
  }

  Future getImageFromGallery() async {
    // ignore: deprecated_member_use
    var image = await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 30);
    setState(() {
      if (image != null) {
        imageURI = image;
        _isImageUploaded = true;
      }
    });
    Navigator.pop(context);
  }

  void showImageDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  backgroundColor: Colors.white,
                  child: Container(
                    height: 200,
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(20, 20, 0, 0),
                          child: Text("Choose...",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22, color: Colors.black),),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: (){
                            getImageFromCamera();
                          },
                          child: Container(
                            height: 30,
                            margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                            child: new Row(
                              children: <Widget>[
                                Icon(
                                  Icons.camera_alt,
                                  color: Colors.black,
                                  size: 24.0,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  child: Text("Camera",style: TextStyle(fontSize: 18, color: Colors.black),),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: (){
                            getImageFromGallery();
                          },
                          child: Container(
                            height: 30,
                            margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                            child: new Row(
                              children: <Widget>[
                                Icon(
                                  Icons.image,
                                  color: Colors.black,
                                  size: 24.0,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  child: Text("Gallery",style: TextStyle(fontSize: 18, color: Colors.black),),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                          // ignore: deprecated_member_use
                          child: FlatButton(
                            color: Colors.transparent,
                            child: Text('Cancel',style: TextStyle(fontSize: 18, color: Colors.black),),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
        });
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }
}
