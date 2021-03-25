import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nakoda_group/data/rest_ds.dart';
import 'package:nakoda_group/utils/connectionStatusSingleton.dart';
import 'package:nakoda_group/utils/flash_helper.dart';
import 'package:nakoda_group/utils/internetconnection.dart';
import 'package:nakoda_group/utils/network_util.dart';

class FamilyDetailScreen extends StatefulWidget {
  @override
  _FamilyDetailScreenState createState() => _FamilyDetailScreenState();
}

class _FamilyDetailScreenState extends State<FamilyDetailScreen> {
  NetworkUtil _netUtil = new NetworkUtil();
  BuildContext _ctx;
  bool _isdataLoading = true;
  final formKey = new GlobalKey<FormState>();
  // bool _isLoadingDelete = false;
  String _Reason;
  String Membershipid,
      membername,
      contact,
      Photo,
      MiddleName,
      Education,
      Education_id,
      OtherEducationName,
      SpecialInfo,
      EmailId,
      BloodGroup,
      LastGautra,
      DOB,_DOB,
      PovLevel;
  String MemberType;
  String MainMemberId;
  String Mobile2;
  String Mobile3;
  String Relation;
  String ProfessionId;
  String NativeId;
  String NanihalGautra, NanihalNative, NanihalNative_id, NanihalBusiness;
  String SasuralGautra,
      SasuralNative,
      SasuralNative_id,
      SasuralBusiness,
      Height,
      Gender,
      Married,
      AniversaryDate,
      _AniversaryDate;
  String ResidanceAddress,
      ResidanceLandmark,
      ResidenaceCityId,
      ResidanceMobile,
      ResidanceTelephone,
      ResidancePincode;
  String OfficeBlock1, OfficeBlock2, OfficeBlock3;
  String OfficeFirmName,
      OfficeWebsite,
      OfficeEmailId,
      OfficeAddress,
      OfficeLandmark,
      OfficeWorkType,
      OfficeCompanyName,
      Officedesignation,
      OfficeSince,
      OfficeCityId,
      OfficeMobile,
      OfficeTelephone,
      OfficePincode;
  String NativeOffice,
      NativeLandmark,
      NativeCityId,
      NativeMobile,
      NativeTelephone,
      NativePincode,
      NativeName;
  String RecName1, RecName2, TrusteeName;
  String FormNumber;
  String rcity, rstate, ostate, ocity, nstate, ncity;

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
  }

  void connectionChanged(dynamic hasConnection) {
    setState(() {
      isOffline = !hasConnection;
      //print(isOffline);
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _ctx = context;
      final Map arguments = ModalRoute.of(_ctx).settings.arguments as Map;
      if (arguments != null) {
        Membershipid = arguments['Membershipid'];
        membername = arguments['FirstName'];
        LastGautra = arguments['LastGautra'];
        contact = arguments['Contact'];
        Photo = arguments['Photo'];
        MiddleName = arguments['MiddleName'];
        Education = arguments['Education'];
        Education_id = arguments['Education_id'];
        OtherEducationName = arguments['OtherEducationName'];
        SpecialInfo = arguments['SpecialInfo'];
        BloodGroup = arguments['BloodGroup'];
        EmailId = arguments['EmailId'];
        DOB = arguments['DOB'];
        PovLevel = arguments['PovLevel'];
        MemberType = arguments['MemberType'];
        MainMemberId = arguments['MainMemberId'];
        Relation = arguments['Relation'];
        Mobile2 = arguments['Mobile2'];
        Mobile3 = arguments['Mobile3'];
        ProfessionId = arguments['ProfessionId'];
        NativeId = arguments['NativeId'];
        NanihalNative = arguments['NanihalNative'];
        NanihalNative_id = arguments['NanihalNative_id'];
        NanihalBusiness = arguments['NanihalBusiness'];
        NanihalGautra = arguments['NanihalGautra'];
        SasuralGautra = arguments['SasuralGautra'];
        SasuralNative = arguments['SasuralNative'];
        SasuralNative_id = arguments['SasuralNative_id'];
        SasuralBusiness = arguments['SasuralBusiness'];
        Height = arguments['Height'];
        Gender = arguments['Gender'];
        Married = arguments['Married'];
        AniversaryDate = arguments['AniversaryDate'];

        ResidanceLandmark = arguments['ResidanceLandmark'];
        ResidenaceCityId = arguments['ResidenaceCityId'];
        ResidanceMobile = arguments['ResidanceMobile'];
        ResidanceTelephone = arguments['ResidanceTelephone'];
        ResidancePincode = arguments['ResidancePincode'];
        ResidanceAddress = arguments['ResidanceAddress'];

        OfficeBlock1 = arguments['OfficeBlock1'];
        OfficeBlock2 = arguments['OfficeBlock2'];
        OfficeBlock3 = arguments['OfficeBlock3'];
        OfficeFirmName = arguments['OfficeFirmName'];
        OfficeWebsite = arguments['OfficeWebsite'];
        OfficeEmailId = arguments['OfficeEmailId'];
        OfficeAddress = arguments['OfficeAddress'];
        OfficeLandmark = arguments['OfficeLandmark'];
        OfficeWorkType = arguments['OfficeWorkType'];
        OfficeCompanyName = arguments['OfficeCompanyName'];
        Officedesignation = arguments['Officedesignation'];
        OfficeSince = arguments['OfficeSince'];
        OfficeCityId = arguments['OfficeCityId'];
        OfficeMobile = arguments['OfficeMobile'];
        OfficeTelephone = arguments['OfficeTelephone'];
        OfficePincode = arguments['OfficePincode'];

        NativeOffice = arguments['NativeOffice'];
        NativeLandmark = arguments['NativeLandmark'];
        NativeCityId = arguments['NativeCityId'];
        NativeMobile = arguments['NativeMobile'];
        NativeTelephone = arguments['NativeTelephone'];
        NativePincode = arguments['NativePincode'];

        RecName1 = arguments['RecName1'];
        RecName2 = arguments['RecName2'];
        TrusteeName = arguments['TrusteeName'];
        FormNumber = arguments['FormNumber'];
        NativeName = arguments['NativeName'];

        rcity = arguments['rcity'];
        rstate = arguments['rstate'];
        ostate = arguments['ostate'];
        ocity = arguments['ocity'];
        nstate = arguments['nstate'];
        ncity = arguments['ncity'];

        DateFormat dateFormat = DateFormat("yyyy-MM-dd");
        DateTime dateTime = dateFormat.parse(DOB);
        String sdate = DateFormat('dd-MM-yyyy').format(dateTime);
        _DOB = sdate;

        if (AniversaryDate != null)
        {
          DateTime dateTime1 = dateFormat.parse(AniversaryDate);
          String adate = DateFormat('dd-MM-yyyy').format(dateTime1);
          _AniversaryDate = adate;
        }

        _isdataLoading = false;
      }
    });
    if (isOffline) {
      return connection.nointernetconnection();
    } else {
      return Scaffold(
        appBar: AppBar(
            title: Text(
          ((membername == null || membername == "")
                  ? "-"
                  : membername.toUpperCase()) +
              " " +
              ((MiddleName == null || MiddleName == "")
                  ? "-"
                  : MiddleName.toUpperCase()) +
              " " +
              ((LastGautra == null || LastGautra == "")
                  ? "-"
                  : LastGautra.toUpperCase()),
          style: TextStyle(fontSize: 17),
          ),
        ),
        body: (_isdataLoading)
            ? new Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                child: ListView(
                  children: <Widget>[
                    new Center(
                      child: new Column(
                        children: <Widget>[
                          Card(
                            semanticContainer: true,
                            elevation: 5,
                            margin: new EdgeInsets.all(5),
                            child: new Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 10,
                                ),
                                new Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    children: <Widget>[
                                      new CircleAvatar(
                                        child: (Photo == null || Photo == "")
                                            ? CircleAvatar(
                                                radius: 65,
                                                child: new Text(
                                                  (membername == null || membername == "")
                                                      ? "-"
                                                      : membername[0].toUpperCase() + MiddleName[0].toUpperCase(),
                                                  style: new TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 30,
                                                      color: Color(0xFFF44336),
                                                  ),
                                                ),
                                                backgroundColor:
                                                    Colors.red.shade100,
                                              )
                                            : CircleAvatar(
                                                radius: 95,
                                                backgroundImage: NetworkImage(
                                                    RestDatasource.Committee_IMAGE_URL + Photo),
                                        ),
                                        radius: 70,
                                        backgroundColor: Color(0xFFF44336),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        (membername == null || membername == "")
                                            ? "-"
                                            : (membername.toUpperCase() +
                                                " " +
                                                MiddleName.toUpperCase() +
                                                " " +
                                                LastGautra.toUpperCase()),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w100),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      elevation: 5,
                      margin: new EdgeInsets.all(5),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new ListTile(
                            title: new Text(
                              'PERSONAL DETAILS',
                              style: new TextStyle(fontSize: 18),
                            ),
                          ),
                          Divider(
                            thickness: 2,
                            indent: 5,
                            endIndent: 5,
                          ),
                          new ListTile(
                            title: new Text(
                              (FormNumber == null || FormNumber == "")
                                  ? "-"
                                  : FormNumber,
                              style: new TextStyle(fontSize: 18),
                            ),
                            subtitle: new Text('Form Number'),
                          ),
                          new ListTile(
                            title: new Text(
                              (membername == null || membername == "")
                                  ? "-"
                                  : membername.toUpperCase() +
                                      " " +
                                      MiddleName.toUpperCase() +
                                      " " +
                                      LastGautra.toUpperCase(),
                              style: new TextStyle(fontSize: 18),
                            ),
                            subtitle: new Text('Name'),
                          ),
                          new ListTile(
                            title: new Text(
                              contact,
                              style: new TextStyle(fontSize: 18),
                            ),
                            subtitle: new Text('Phone Number'),
                          ),
                          new ListTile(
                            title: new Text(
                              (EmailId == null || EmailId == "")
                                  ? "-"
                                  : EmailId,
                              style: new TextStyle(fontSize: 18),
                            ),
                            subtitle: new Text('Email Id'),
                          ),
                          new ListTile(
                            title: new Text(
                            (Education == "OTHER")
                                ? (OtherEducationName == null || OtherEducationName == "")
                                        ? "-"
                                        : OtherEducationName.toUpperCase()
                                : (Education == null || Education == "")
                                    ? "-"
                                    : Education.toUpperCase(),
                              style: new TextStyle(fontSize: 18),
                            ),
                            subtitle: new Text("Education"),
                          ),
                          new ListTile(
                            title: new Text(
                              (ProfessionId == null || ProfessionId == "")
                                  ? "-"
                                  : ProfessionId,
                              style: new TextStyle(fontSize: 18),
                            ),
                            subtitle: new Text('Profession'),
                          ),
                          new ListTile(
                            title: new Text(
                              (NanihalNative == null || NanihalNative == "")
                                  ? "-"
                                  : NanihalNative.toUpperCase(),
                              style: new TextStyle(fontSize: 18),
                            ),
                            subtitle: new Text('Native Place'),
                          ),
                          new ListTile(
                            title: new Text(
                              (BloodGroup == null || BloodGroup == "")
                                  ? "-"
                                  : BloodGroup.toUpperCase(),
                              style: new TextStyle(fontSize: 18),
                            ),
                            subtitle: new Text("Blood Group"),
                          ),
                          new ListTile(
                            title: Row(
                              children: [
                                new Text(
                                  (NanihalGautra == null || NanihalGautra == "")
                                      ? "-"
                                      : NanihalGautra.toUpperCase(),
                                  style: new TextStyle(fontSize: 18),
                                ),
                                Text("/"),
                                new Text(
                                  (NanihalNative == null || NanihalNative == "")
                                      ? "-"
                                      : NanihalNative,
                                  style: new TextStyle(fontSize: 18),
                                ),
                                Text("/"),
                                new Text(
                                  (NanihalBusiness == null || NanihalBusiness == "")
                                      ? "-"
                                      : NanihalBusiness,
                                  style: new TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                            subtitle: new Text("Nanihal Gautra"),
                          ),
                          new ListTile(
                            title: Row(
                              children: [
                                new Text(
                                  (SasuralGautra.toString() == "null" || SasuralGautra == "")
                                      ? "-"
                                      : SasuralGautra.toUpperCase(),
                                  style: new TextStyle(fontSize: 18),
                                ),
                                Text("/"),
                                new Text(
                                  (SasuralNative.toString() == "null" || SasuralNative == "")
                                      ? "-"
                                      : SasuralNative.toUpperCase(),
                                  style: new TextStyle(fontSize: 18),
                                ),
                                Text("/"),
                                new Text(
                                  (SasuralBusiness.toString() == "null" || SasuralBusiness == "")
                                      ? "-"
                                      : SasuralBusiness.toUpperCase(),
                                  style: new TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                            subtitle: new Text("Sasural Gautra"),
                          ),
                          new ListTile(
                            title: new Text(
                              (_DOB == null || _DOB == "")
                                  ? "-"
                                  : _DOB,
                              style: new TextStyle(fontSize: 18),
                            ),
                            subtitle: new Text("Date Of Birth"),
                          ),
                          new ListTile(
                            title: new Text(
                              (Gender == null || Gender == "")
                                  ? "-"
                                  : Gender.toUpperCase(),
                              style: new TextStyle(fontSize: 18),
                            ),
                            subtitle: new Text("Gender"),
                          ),
                          new ListTile(
                            title: new Text(
                              (Married == null || Married == "")
                                  ? "-"
                                  : Married.toUpperCase(),
                              style: new TextStyle(fontSize: 18),
                            ),
                            subtitle: new Text("Married?"),
                          ),
                          new ListTile(
                            title: Text(
                              (Married == "N")
                                ? "-"
                                : (_AniversaryDate == null || _AniversaryDate == "")
                                  ? "-"
                                  : _AniversaryDate,
                              style: new TextStyle(fontSize: 18),
                            ),
                            subtitle: new Text("Aniversary Date"),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      elevation: 5,
                      margin: new EdgeInsets.all(5),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new ListTile(
                            title: new Text(
                              'RESIDENCE INFORMATION',
                              style: new TextStyle(fontSize: 18),
                            ),
                          ),
                          Divider(
                            thickness: 2,
                            indent: 5,
                            endIndent: 5,
                          ),
                          new ListTile(
                            title: new Text(
                              (ResidanceAddress == null || ResidanceAddress == "")
                                  ? "-"
                                  : ResidanceAddress.toUpperCase(),
                              style: new TextStyle(fontSize: 18),
                            ),
                            subtitle: new Text('Residence Address'),
                          ),
                          new ListTile(
                            title: new Text(
                              (ResidanceLandmark == null || ResidanceLandmark == "")
                                  ? "-"
                                  : ResidanceLandmark.toUpperCase(),
                              style: new TextStyle(fontSize: 18),
                            ),
                            subtitle: new Text('Residence Landmark'),
                          ),
                          new ListTile(
                            title: new Text(
                              (rcity == null || rcity == "")
                                  ? "-"
                                  : rcity.toUpperCase(),
                              style: new TextStyle(fontSize: 18),
                            ),
                            subtitle: new Text('Residence City'),
                          ),
                          new ListTile(
                            title: new Text(
                              (rstate == null || rstate == "")
                                  ? "-"
                                  : rstate.toUpperCase(),
                              style: new TextStyle(fontSize: 18),
                            ),
                            subtitle: new Text("Residence State"),
                          ),
                          new ListTile(
                            title: new Text(
                              (ResidancePincode == null ||
                                      ResidancePincode == "")
                                  ? "-"
                                  : ResidancePincode,
                              style: new TextStyle(fontSize: 18),
                            ),
                            subtitle: new Text('Pincode Number'),
                          ),
                          new ListTile(
                            title: new Text(
                              (ResidanceTelephone == null || ResidanceTelephone == "")
                                  ? "-"
                                  : ResidanceTelephone,
                              style: new TextStyle(fontSize: 18),
                            ),
                            subtitle: new Text('Residence Telephone'),
                          ),
                          new ListTile(
                            title: new Text(
                              (ResidanceMobile == null || ResidanceMobile == "")
                                  ? "-"
                                  : ResidanceMobile,
                              style: new TextStyle(fontSize: 18),
                            ),
                            subtitle: new Text("Residence Mobile"),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      elevation: 5,
                      margin: new EdgeInsets.all(5),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new ListTile(
                            title: new Text(
                              'NATIVE INFORMATION',
                              style: new TextStyle(fontSize: 18),
                            ),
                          ),
                          Divider(
                            thickness: 2,
                            indent: 5,
                            endIndent: 5,
                          ),
                          new ListTile(
                            title: new Text(
                              (NativeOffice == null || NativeOffice == "")
                                  ? "-"
                                  : NativeOffice.toUpperCase(),
                              style: new TextStyle(fontSize: 18),
                            ),
                            subtitle: new Text('Native Office'),
                          ),
                          new ListTile(
                            title: new Text(
                              (NativeLandmark == null || NativeLandmark == "")
                                  ? "-"
                                  : NativeLandmark.toUpperCase(),
                              style: new TextStyle(fontSize: 18),
                            ),
                            subtitle: new Text('Native Landmark'),
                          ),
                          new ListTile(
                            title: new Text(
                              (ncity == null || ncity == "")
                                  ? "-"
                                  : ncity.toUpperCase(),
                              style: new TextStyle(fontSize: 18),
                            ),
                            subtitle: new Text('Native City'),
                          ),
                          new ListTile(
                            title: new Text(
                              (nstate == null || nstate == "")
                                  ? "-"
                                  : nstate.toUpperCase(),
                              style: new TextStyle(fontSize: 18),
                            ),
                            subtitle: new Text("Native State"),
                          ),
                          new ListTile(
                            title: new Text(
                              (NativePincode == null || NativePincode == "")
                                  ? "-"
                                  : NativePincode,
                              style: new TextStyle(fontSize: 18),
                            ),
                            subtitle: new Text('Pincode Number'),
                          ),
                          new ListTile(
                            title: new Text(
                              (NativeTelephone == null || NativeTelephone == "")
                                  ? "-"
                                  : NativeTelephone,
                              style: new TextStyle(fontSize: 18),
                            ),
                            subtitle: new Text('Native Telephone'),
                          ),
                          new ListTile(
                            title: new Text(
                              (NativeMobile == null || NativeMobile == "")
                                  ? "-"
                                  : NativeMobile,
                              style: new TextStyle(fontSize: 18),
                            ),
                            subtitle: new Text("Native Mobile"),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      elevation: 5,
                      margin: new EdgeInsets.all(5),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new ListTile(
                            title: new Text(
                              'OTHER INFORMATION',
                              style: new TextStyle(fontSize: 18),
                            ),
                          ),
                          Divider(
                            thickness: 2,
                            indent: 5,
                            endIndent: 5,
                          ),
                          new ListTile(
                            title: new Text(
                              (RecName1 == null || RecName1 == "")
                                  ? "-"
                                  : RecName1.toUpperCase(),
                              style: new TextStyle(fontSize: 18),
                            ),
                            subtitle: new Text('Rec. Name 1'),
                          ),
                          new ListTile(
                            title: new Text(
                              (RecName2 == null || RecName2 == "")
                                  ? "-"
                                  : RecName2.toUpperCase(),
                              style: new TextStyle(fontSize: 18),
                            ),
                            subtitle: new Text('Rec. Name 2'),
                          ),
                          new ListTile(
                            title: new Text(
                              (TrusteeName == null || TrusteeName == "")
                                  ? "-"
                                  : TrusteeName.toUpperCase(),
                              style: new TextStyle(fontSize: 18),
                            ),
                            subtitle: new Text('Trustee Name'),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      elevation: 5,
                      margin: new EdgeInsets.all(5),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return StatefulBuilder(
                                          builder: (BuildContext context, StateSetter setState) {
                                            return Dialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              backgroundColor: Colors.white,
                                              child: Container(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: <Widget>[
                                                    Center(
                                                      child: Container(
                                                        margin: EdgeInsets.fromLTRB(20, 15, 20, 0),
                                                        child: Text(
                                                          "Are You Sure Want To Edit This Member?",
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              color: Colors.black),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 15,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          flex: 1,
                                                          child: InkWell(
                                                            onTap:(){
                                                              Navigator.of(context).popAndPushNamed("/editfamily", arguments: {
                                                                "Membershipid": Membershipid,
                                                                "membername": membername,
                                                                "LastGautra": LastGautra,
                                                                "contact": contact,
                                                                "Photo": Photo,
                                                                "MiddleName": MiddleName,
                                                                "Education": Education,
                                                                "Education_id": Education_id,
                                                                "OtherEducationName": OtherEducationName,
                                                                "SpecialInfo": SpecialInfo,
                                                                "BloodGroup": BloodGroup,
                                                                "EmailId": EmailId,
                                                                "DOB": DOB,
                                                                "PovLevel": PovLevel,
                                                                "MemberType": MemberType,
                                                                "MainMemberId": MainMemberId,
                                                                "Relation": Relation,
                                                                "Mobile2": Mobile2,
                                                                "Mobile3": Mobile3,
                                                                "ProfessionId": ProfessionId,
                                                                "NativeId": NativeId,
                                                                "NanihalNative": NanihalNative,
                                                                "NanihalNative_id": NanihalNative_id,
                                                                "NanihalBusiness": NanihalBusiness,
                                                                "SasuralGautra": SasuralGautra,
                                                                "SasuralNative": SasuralNative,
                                                                "SasuralNative_id": SasuralNative_id,
                                                                "Gender": Gender,
                                                                "Height": Height,
                                                                "Married": Married,
                                                                "AniversaryDate": AniversaryDate,
                                                                "ResidanceLandmark": ResidanceLandmark,
                                                                "ResidenaceCityId": ResidenaceCityId,
                                                                "ResidanceMobile": ResidanceMobile,
                                                                "ResidanceTelephone": ResidanceTelephone,
                                                                "ResidancePincode": ResidancePincode,
                                                                "OfficeBlock1": OfficeBlock1,
                                                                "OfficeBlock2": OfficeBlock2,
                                                                "OfficeBlock3": OfficeBlock3,
                                                                "OfficeFirmName": OfficeFirmName,
                                                                "OfficeWebsite": OfficeWebsite,
                                                                "OfficeEmailId": OfficeEmailId,
                                                                "OfficeAddress": OfficeAddress,
                                                                "OfficeLandmark": OfficeLandmark,
                                                                "OfficeWorkType": OfficeWorkType,
                                                                "OfficeCityId": OfficeCityId,
                                                                "OfficeMobile": OfficeMobile,
                                                                "OfficeTelephone": OfficeTelephone,
                                                                "OfficePincode": OfficePincode,
                                                                "OfficeCompanyName": OfficeCompanyName,
                                                                "Officedesignation": Officedesignation,
                                                                "OfficeSince": OfficeSince,
                                                                "NativeOffice": NativeOffice,
                                                                "NativeLandmark": NativeLandmark,
                                                                "NativeCityId": NativeCityId,
                                                                "NativeMobile": NativeMobile,
                                                                "NativeTelephone": NativeTelephone,
                                                                "NativePincode": NativePincode,
                                                                "RecName1": RecName1,
                                                                "RecName2": RecName2,
                                                                "TrusteeName": TrusteeName,
                                                                "ResidanceAddress": ResidanceAddress,
                                                                "SasuralBusiness": SasuralBusiness,
                                                                "NanihalGautra": NanihalGautra,
                                                                "FormNumber": FormNumber,
                                                                "rcity": rcity,
                                                                "rstate": rstate,
                                                                "ostate": ostate,
                                                                "ocity": ocity,
                                                                "nstate": nstate,
                                                                "ncity": ncity,
                                                              });
                                                            },
                                                            child: new Container(
                                                              padding: EdgeInsets.symmetric(
                                                                  vertical: 15, horizontal: 15),
                                                              margin: EdgeInsets.symmetric(
                                                                  horizontal: 15, vertical: 15),
                                                              alignment: Alignment.center,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                  BorderRadius.all(Radius.circular(5)),
                                                                  boxShadow: <BoxShadow>[
                                                                    BoxShadow(
                                                                        color: Colors.grey.shade200,
                                                                        offset: Offset(2, 4),
                                                                        blurRadius: 5,
                                                                        spreadRadius: 2)
                                                                  ],
                                                                  color: Colors.red),
                                                              child: Text(
                                                                'EDIT',
                                                                style: TextStyle(
                                                                    fontSize: 18,
                                                                    color: Colors.white),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: InkWell(
                                                            onTap: (){
                                                              Navigator.pop(context);
                                                            },
                                                            child: new Container(
                                                              padding: EdgeInsets.symmetric(
                                                                  vertical: 15,horizontal: 15),
                                                              margin: EdgeInsets.symmetric(
                                                                  horizontal: 15, vertical: 15),
                                                              alignment: Alignment.center,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                  BorderRadius.all(Radius.circular(5)),
                                                                  boxShadow: <BoxShadow>[
                                                                    BoxShadow(
                                                                        color: Colors.grey.shade200,
                                                                        offset: Offset(2, 4),
                                                                        blurRadius: 5,
                                                                        spreadRadius: 2)
                                                                  ],
                                                                  color: Colors.red),
                                                              child: Text(
                                                                'CANCEL',
                                                                style: TextStyle(
                                                                    fontSize: 18,
                                                                    color: Colors.white),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          });
                                    });
                              },
                              child: new Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 5),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                          color: Colors.grey.shade200,
                                          offset: Offset(2, 4),
                                          blurRadius: 5,
                                          spreadRadius: 2)
                                    ],
                                    color: Colors.red),
                                child: Text(
                                  'EDIT',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return StatefulBuilder(
                                          builder: (BuildContext context, StateSetter setState) {
                                            return Dialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              backgroundColor: Colors.white,
                                              child: Container(
                                                child: Form(
                                                  key: formKey,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: <Widget>[
                                                      Center(
                                                        child: Container(
                                                          margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                                                          child: Text(
                                                            "Why Are You Delete This?",
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.black),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                      Container(
                                                        margin:
                                                        EdgeInsets.only(left: 15, top: 10, right: 15),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: <Widget>[
                                                            Text(
                                                              "Reason :",
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
                                                              onSaved:(val) => _Reason = val,
                                                              style: TextStyle(fontSize: 14),
                                                              validator: (value) =>
                                                              (value == null || value == "")
                                                                  ? 'Enter Reason'
                                                                  : null,
                                                              decoration: InputDecoration(
                                                                hintText: "Enter Reason",
                                                                border: InputBorder.none,
                                                                fillColor: Color(0xfff3f3f4),
                                                                filled: true,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Expanded(
                                                            flex: 1,
                                                            child: InkWell(
                                                              onTap:(){
                                                                      Navigator.pop(context);
                                                                  },
                                                              child: new Container(
                                                                padding: EdgeInsets.symmetric(
                                                                    vertical: 15, horizontal: 15),
                                                                margin: EdgeInsets.symmetric(
                                                                    horizontal: 15, vertical: 15),
                                                                alignment: Alignment.center,
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                    BorderRadius.all(Radius.circular(5)),
                                                                    boxShadow: <BoxShadow>[
                                                                      BoxShadow(
                                                                          color: Colors.grey.shade200,
                                                                          offset: Offset(2, 4),
                                                                          blurRadius: 5,
                                                                          spreadRadius: 2)
                                                                    ],
                                                                    color: Colors.red),
                                                                child: Text(
                                                                  'CANCEL',
                                                                  style: TextStyle(
                                                                      fontSize: 18,
                                                                      color: Colors.white),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 1,
                                                            child: InkWell(
                                                              onTap: (){
                                                                      final form = formKey.currentState;
                                                                      if (form.validate()) {
                                                                        form.save();
                                                                        _netUtil.post(RestDatasource.URL_DELETE_FAMILY, body: {
                                                                              "MemershipId": Membershipid,
                                                                              "MainMemershipId": MainMemberId,
                                                                              "txtreason": _Reason ?? "",
                                                                        }).then((dynamic res) async {
                                                                          if (res["status"] == "yes") {
                                                                            formKey.currentState.reset();
                                                                            FlashHelper.successBar(context,
                                                                                message: "Application Submitted Successfully For Deleting Family Member....!");
                                                                            Navigator.of(_ctx).pushReplacementNamed("/home");
                                                                          } else {
                                                                            FlashHelper.errorBar(context,
                                                                                message: "Fail! try again later!...");
                                                                          }
                                                                        });
                                                                      }
                                                              },
                                                              child: new Container(
                                                                padding: EdgeInsets.symmetric(
                                                                    vertical: 15,horizontal: 15),
                                                                margin: EdgeInsets.symmetric(
                                                                    horizontal: 15, vertical: 15),
                                                                alignment: Alignment.center,
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                    BorderRadius.all(Radius.circular(5)),
                                                                    boxShadow: <BoxShadow>[
                                                                      BoxShadow(
                                                                          color: Colors.grey.shade200,
                                                                          offset: Offset(2, 4),
                                                                          blurRadius: 5,
                                                                          spreadRadius: 2)
                                                                    ],
                                                                    color: Colors.red),
                                                                child: Text(
                                                                  'DELETE',
                                                                  style: TextStyle(
                                                                      fontSize: 18,
                                                                      color: Colors.white),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          });
                                    });
                              },
                              child: new Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 5),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                          color: Colors.grey.shade200,
                                          offset: Offset(2, 4),
                                          blurRadius: 5,
                                          spreadRadius: 2)
                                    ],
                                    color: Colors.red),
                                child: Text(
                                  'DELETE',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      );
    }
  }
}
