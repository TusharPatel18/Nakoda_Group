import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nakoda_group/data/rest_ds.dart';
import 'package:nakoda_group/models/family.dart';
import 'package:nakoda_group/utils/connectionStatusSingleton.dart';
import 'package:nakoda_group/utils/internetconnection.dart';
import 'package:nakoda_group/utils/network_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyProfileScreen extends StatefulWidget {
  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  NetworkUtil _netUtil = new NetworkUtil();
  BuildContext _ctx;
  bool _isdataLoading = true;
  SharedPreferences prefs;
  String id = "";
  Future<List<Family>> familydata;
  String memberid,
      membername,
      contact,
      ProfileImage,
      MiddleName,
      Education,
      EmailId,
      BloodGroup,
      LastGautra,
      DOB;
  String MemberType;
  String MainMemberId;
  String Mobile2;
  String Mobile3;
  String Relation;
  String ProfessionId;
  String NativeId;
  String NanihalGautra, NanihalNative, NanihalBusiness;
  String SasuralGautra,
      SasuralNative,
      SasuralBusiness,
      Gender,
      Married,
      AniversaryDate;
  String ResidanceAddress,
      ResidanceLandmark,
      ResidenaceCityId,
      ResidanceMobile,
      ResidanceTelephone,
      ResidancePincode;
  String OfficeFirmName,
      OfficeWebsite,
      OfficeEmailId,
      OfficeAddress,
      OfficeLandmark,
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

  _loadPref() async {
    prefs = await SharedPreferences.getInstance();
    id = prefs.getString("MembershipId");
    familydata = _getUserData(id);
    _netUtil.post(RestDatasource.URL_USER_DETAILS, body: {
      "mobile": prefs.getString("Mobile1"),
    }).then((dynamic res) async {
      setState(() {
        //Personal Info
        MainMemberId = res[0]["MainMemberId"].toString();
        memberid = res[0]["MembershipId"].toString();
        membername = res[0]["FirstName"];
        FormNumber = res[0]["FormNumber"];

        ProfileImage = res[0]["Photo"];
        MiddleName = res[0]["MiddleName"];
        LastGautra = res[0]["LastGautra"];
        contact = res[0]["Mobile1"];
        EmailId = res[0]["Emaild"] ?? "";
        Education = res[0]["EducationName"] ?? "";
        ProfessionId = res[0]["ProfessionName"] ?? "";
        NativeName = res[0]["NNativeName"] ?? "";
        BloodGroup = res[0]["BloodGroup"] ?? "";
        NanihalGautra = res[0]["NanihalGautra"] ?? "";
        NanihalNative = res[0]["NanihalNative"] ?? "";
        NanihalBusiness = res[0]["NanihalBusiness"] ?? "";
        SasuralGautra = res[0]["SasuralGautra"] ?? "";
        SasuralNative = res[0]["SNativeName"] ?? "";
        SasuralBusiness = res[0]["SasuralBusiness"] ?? "";
        DOB = res[0]["DOB"].toString() ?? "";
        Gender = res[0]["Gender"].toString() ?? "";
        Married = res[0]["Married"].toString() ?? "";
        AniversaryDate = res[0]["AniversaryDate"].toString() ?? "";
        //Personal Info
        //Residance Info
        ResidanceAddress = res[0]["ResidanceBlock1"].toString() ?? "" +
            "," +
            res[0]["ResidanceBlock2"].toString() ?? "" +
            "," +
            res[0]["ResidanceBlock3"].toString() ?? "" +
            "," +
            res[0]["ResidanceAddress"].toString() ?? "";
        ResidanceLandmark = res[0]["ResidanceLandmark"].toString() ?? "";
        rcity = res[0]["rcity"].toString() ?? "";
        rstate = res[0]["rstate"].toString() ?? "";
        ResidanceMobile = res[0]["ResidanceMobile"].toString() ?? "";
        ResidanceTelephone = res[0]["ResidanceTelephone"].toString() ?? "";
        ResidancePincode = res[0]["ResidancePincode"].toString() ?? "";
        //Residance Info
        //Office Info
        OfficeFirmName = res[0]["OfficeFirmName"].toString() ?? "";
        OfficeWebsite = res[0]["OfficeWebsite"].toString() ?? "";
        OfficeEmailId = res[0]["OfficeEmailId"].toString() ?? "";
        OfficeAddress = res[0]["OfficeAddress"].toString() ?? "";
        OfficeLandmark = res[0]["OfficeLandmark"].toString() ?? "";
        ostate = res[0]["ostate"].toString() ?? "";
        ocity = res[0]["ocity"].toString() ?? "";
        OfficeMobile = res[0]["OfficeMobile"].toString() ?? "";
        OfficeTelephone = res[0]["OfficeTelephone"].toString() ?? "";
        OfficePincode = res[0]["OfficePincode"].toString() ?? "";
        //Office Info
        //Native Info
        NativeOffice = res[0]["NativeBlock1"].toString() ?? "" +
            "," +
            res[0]["NativeBlock2"].toString() ?? "" +
            "," +
            res[0]["NativeBlock3"].toString() ?? "" +
            "," +
            res[0]["NativeOffice"].toString() ?? "";
        NativeLandmark = res[0]["NativeLandmark"].toString() ?? "";
        nstate = res[0]["nstate"].toString() ?? "";
        ncity = res[0]["ncity"].toString() ?? "";
        NativeMobile = res[0]["NativeMobile"].toString() ?? "";
        NativeTelephone = res[0]["NativeTelephone"].toString() ?? "";
        NativePincode = res[0]["NativePincode"].toString() ?? "";
        //Native Info
        //Other Info
        RecName1 = res[0]["RecName1"].toString() ?? "";
        RecName2 = res[0]["RecName2"].toString() ?? "";
        TrusteeName = res[0]["TrusteeName"].toString() ?? "";
        //Other Info
        _isdataLoading = false;
      });
    });
  }

  Future<List<Family>> _getUserData(String id) async {
    return _netUtil.post(RestDatasource.URL_FAMILY_LIST,
        body: {"MemberShipId": id}).then((dynamic res) {
      final items = res.cast<Map<String, dynamic>>();
      List<Family> listofusers = items.map<Family>((json) {
        return Family.fromJson(json);
      }).toList();
      List<Family> revdata = listofusers.reversed.toList();
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
    }
    else {
      return Scaffold(
        appBar: AppBar(
          title: Text('My Profile'),
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
                                        child: (ProfileImage == null &&
                                                ProfileImage == "")
                                            ? CircleAvatar(
                                                radius: 65,
                                                child: new Text(
                                                  (membername == null || membername == "")
                                                      ? "-"
                                                      : membername[0].toUpperCase() + MiddleName[0].toUpperCase(),
                                                  style: new TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                    RestDatasource.Committee_IMAGE_URL + ProfileImage),
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
                                        height: 5,
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
                            indent: 10,
                            endIndent: 10,
                          ),
                          new ListTile(
                            title: new Text(
                              (FormNumber == null || FormNumber == "")
                                  ? "-"
                                  : FormNumber.toString(),
                              style: new TextStyle(fontSize: 18),
                            ),
                            subtitle: new Text('Form Number'),
                          ),
                          new ListTile(
                            title: new Text(
                              (membername == null || membername == "")
                                  ? "-"
                                  : (membername.toUpperCase() +
                                      " " +
                                      MiddleName.toUpperCase() +
                                      " " +
                                      LastGautra.toUpperCase()),
                              style: new TextStyle(fontSize: 18),
                            ),
                            subtitle: new Text('Name'),
                          ),
                          new ListTile(
                            title: new Text(
                              (contact == null || contact == "")
                                  ? "-"
                                  : contact.toString(),
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
                              (Education == null || Education == "")
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
                              (NativeName == null || NativeName == "")
                                  ? "-"
                                  : NativeName,
                              style: new TextStyle(fontSize: 18),
                            ),
                            subtitle: new Text('Native Place'),
                          ),
                          new ListTile(
                            title: new Text(
                              (BloodGroup == null || BloodGroup == "")
                                  ? "-"
                                  : BloodGroup,
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
                                  (NativeName == null || NativeName == "")
                                      ? "-"
                                      : NativeName,
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
                                  (SasuralGautra == null || SasuralGautra == "")
                                      ? "-"
                                      : SasuralGautra,
                                  style: new TextStyle(fontSize: 18),
                                ),
                                Text("/"),
                                new Text(
                                  (SasuralNative == "null" || SasuralNative == "")
                                      ? "-"
                                      : SasuralNative,
                                  style: new TextStyle(fontSize: 18),
                                ),
                                Text("/"),
                                new Text(
                                  (SasuralBusiness == null || SasuralBusiness == "")
                                      ? "-"
                                      : SasuralBusiness,
                                  style: new TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                            subtitle: new Text("Sasural Gautra"),
                          ),
                          new ListTile(
                            title: new Text(
                              (DOB == null || DOB == "") ? "-" : DOB,
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
                                  : Married,
                              style: new TextStyle(fontSize: 18),
                            ),
                            subtitle: new Text("Married?"),
                          ),
                          new ListTile(
                            title: (Married == "N")
                                ? Text("-",style: new TextStyle(fontSize: 18),)
                                : Text(
                              (AniversaryDate == null || AniversaryDate == "")
                                  ? "-"
                                  : AniversaryDate,
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
                              style: new TextStyle(fontSize: 20),
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
                                  : ResidanceAddress,
                              style: new TextStyle(fontSize: 18),
                            ),
                            subtitle: new Text('Residence Address'),
                          ),
                          new ListTile(
                            title: new Text(
                              (ResidanceLandmark == null || ResidanceLandmark == "")
                                  ? "-"
                                  : ResidanceLandmark,
                              style: new TextStyle(fontSize: 18),
                            ),
                            subtitle: new Text('Residence Landmark'),
                          ),
                          new ListTile(
                            title: new Text(
                              (rcity == "null" || rcity == "")
                                  ? "-"
                                  : rcity,
                              style: new TextStyle(fontSize: 18),
                            ),
                            subtitle: new Text('Residence City'),
                          ),
                          new ListTile(
                            title: new Text(
                              (rstate == "null" || rstate == "")
                                  ? "-"
                                  : rstate,
                              style: new TextStyle(fontSize: 18),
                            ),
                            subtitle: new Text("Residence State"),
                          ),
                          new ListTile(
                            title: new Text(
                              (ResidancePincode == "null" || ResidancePincode == "")
                                  ? "-"
                                  : ResidancePincode,
                              style: new TextStyle(fontSize: 18),
                            ),
                            subtitle: new Text('Pincode Number'),
                          ),
                          new ListTile(
                            title: new Text(
                              (ResidanceTelephone == "null" || ResidanceTelephone == "")
                                  ? "-"
                                  : ResidanceTelephone,
                              style: new TextStyle(fontSize: 18),
                            ),
                            subtitle: new Text('Residence Telephone'),
                          ),
                          new ListTile(
                            title: new Text(
                              (ResidanceMobile == "null" || ResidanceMobile == "")
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
                              'OFFICE INFORMATION',
                              style: new TextStyle(fontSize: 20),
                            ),
                          ),
                          Divider(
                            thickness: 2,
                            indent: 5,
                            endIndent: 5,
                          ),
                          new ListTile(
                            title: new Text(
                              (OfficeFirmName == null || OfficeFirmName == "")
                                  ? "-"
                                  : OfficeFirmName,
                              style: new TextStyle(fontSize: 18),
                            ),
                            subtitle: new Text('Office Firm Name'),
                          ),
                          new ListTile(
                            title: new Text(
                              (OfficeWebsite == null || OfficeWebsite == "")
                                  ? "-"
                                  : OfficeWebsite,
                              style: new TextStyle(fontSize: 18),
                            ),
                            subtitle: new Text('Office Website'),
                          ),
                          new ListTile(
                            title: new Text(
                              (OfficeEmailId == null || OfficeEmailId == "")
                                  ? "-"
                                  : OfficeEmailId,
                              style: new TextStyle(fontSize: 18),
                            ),
                            subtitle: new Text('Office EmailId'),
                          ),
                          new ListTile(
                            title: new Text(
                              (OfficeAddress == null || OfficeAddress == "")
                                  ? "-"
                                  : OfficeAddress,
                              style: new TextStyle(fontSize: 18),
                            ),
                            subtitle: new Text('Office Address'),
                          ),
                          new ListTile(
                            title: new Text(
                              (OfficeLandmark == null || OfficeLandmark == "")
                                  ? "-"
                                  : OfficeLandmark,
                              style: new TextStyle(fontSize: 18),
                            ),
                            subtitle: new Text('Office Landmark'),
                          ),
                          new ListTile(
                            title: new Text(
                              (ocity == null || ocity == "") ? "-" : ocity,
                              style: new TextStyle(fontSize: 18),
                            ),
                            subtitle: new Text('Office City'),
                          ),
                          new ListTile(
                            title: new Text(
                              (ostate == null || ostate == "") ? "-" : ostate,
                              style: new TextStyle(fontSize: 18),
                            ),
                            subtitle: new Text("Office State"),
                          ),
                          new ListTile(
                            title: new Text(
                              (OfficePincode == null || OfficePincode == "")
                                  ? "-"
                                  : OfficePincode,
                              style: new TextStyle(fontSize: 18),
                            ),
                            subtitle: new Text('Pincode Number'),
                          ),
                          new ListTile(
                            title: new Text(
                              (OfficeTelephone == null || OfficeTelephone == "")
                                  ? "-"
                                  : OfficeTelephone,
                              style: new TextStyle(fontSize: 18),
                            ),
                            subtitle: new Text('Office Telephone'),
                          ),
                          new ListTile(
                            title: new Text(
                              (OfficeMobile == null || OfficeMobile == "")
                                  ? "-"
                                  : OfficeMobile,
                              style: new TextStyle(fontSize: 18),
                            ),
                            subtitle: new Text("Office Mobile"),
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
                              style: new TextStyle(fontSize: 20),
                            ),
                          ),
                          Divider(
                            thickness: 2,
                            indent: 5,
                            endIndent: 5,
                          ),
                          new ListTile(
                            title: new Text(
                              (NativeOffice == "null" || NativeOffice == "")
                                  ? "-"
                                  : NativeOffice,
                              style: new TextStyle(fontSize: 18),
                            ),
                            subtitle: new Text('Native Office'),
                          ),
                          new ListTile(
                            title: new Text(
                              (NativeLandmark == "null" || NativeLandmark == "")
                                  ? "-"
                                  : NativeLandmark,
                              style: new TextStyle(fontSize: 18),
                            ),
                            subtitle: new Text('Native Landmark'),
                          ),
                          new ListTile(
                            title: new Text(
                              (ncity == "null" || ncity == "")
                                  ? "-"
                                  : ncity,
                              style: new TextStyle(fontSize: 18),
                            ),
                            subtitle: new Text('Native City'),
                          ),
                          new ListTile(
                            title: new Text(
                              (nstate == "null" || nstate == "")
                                  ? "-"
                                  : nstate,
                              style: new TextStyle(fontSize: 18),
                            ),
                            subtitle: new Text("Native State"),
                          ),
                          new ListTile(
                            title: new Text(
                              (NativePincode == "null" || NativePincode == "")
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
                              style: new TextStyle(fontSize: 20),
                            ),
                          ),
                          Divider(
                            thickness: 2,
                            indent: 5,
                            endIndent: 5,
                          ),
                          new ListTile(
                            title: new Text(
                              (RecName1 == "null" || RecName1 == "")
                                  ? "-"
                                  : RecName1,
                              style: new TextStyle(fontSize: 18),
                            ),
                            subtitle: new Text('Rec. Name 1'),
                          ),
                          new ListTile(
                            title: new Text(
                              (RecName2 == "null" || RecName2 == "")
                                  ? "-"
                                  : RecName2,
                              style: new TextStyle(fontSize: 18),
                            ),
                            subtitle: new Text('Rec. Name 2'),
                          ),
                          new ListTile(
                            title: new Text(
                              (TrusteeName == "null" || TrusteeName == "")
                                  ? "-"
                                  : TrusteeName,
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
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new ListTile(
                            title: new Text(
                              'FAMILY MEMBERS',
                              style: new TextStyle(fontSize: 20),
                            ),
                          ),
                          Divider(
                            thickness: 2,
                            indent: 5,
                            endIndent: 5,
                          ),
                          FutureBuilder<List<Family>>(
                            future: familydata,
                            builder: (context, snapshot) {
                              //print(snapshot.data);
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (snapshot.hasData == null) {
                                return Center(
                                  child: Text("No Family Member Add!"),
                                );
                              }
                              return ListView(
                                shrinkWrap: true,
                                padding: EdgeInsets.only(bottom: 70.0),
                                children: snapshot.data
                                    .map(
                                      (data) => InkWell(
                                    onTap: () {
                                      Navigator.of(context).pushNamed("/myfamilydetails", arguments: {
                                        "Membershipid": data.MembershipId,
                                        "FirstName": data.FirstName,
                                        "Contact": data.Mobile1,
                                        "Photo": data.Photo,
                                        "MiddleName": data.MiddleName,
                                        "LastGautra": data.LastGautra,
                                        "Education": data.Education,
                                        "Education_id": data.Education_id,
                                        "OtherEducationName": data.OtherEducationName,
                                        "SpecialInfo": data.SpecialInfo,
                                        "EmailId": data.EmailId,
                                        "BloodGroup": data.BloodGroup,
                                        "MainMemberId": data.MainMemberId,
                                        "DOB": data.DOB,
                                        "Height": data.Height,
                                        "PovLevel": data.IncomeLevel,
                                        "Relation": data.Relation,
                                        "Mobile2": data.Mobile2,
                                        "Mobile3": data.Mobile3,
                                        "MemberType": data.MemberType,
                                        "ProfessionId": data.ProfessionId,
                                        "NativeId": data.NativeId,
                                        "NanihalNative": data.NanihalNative,
                                        "NanihalNative_id": data.NanihalNative_id,
                                        "NanihalBusiness": data.NanihalBusiness,
                                        "NanihalGautra": data.NanihalGautra,
                                        "SasuralGautra": data.SasuralGautra,
                                        "SasuralNative": data.SasuralNative,
                                        "SasuralNative_id": data.SasuralNative_id,
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
                                        "OfficeBlock1": data.OfficeBlock1,
                                        "OfficeBlock2": data.OfficeBlock2,
                                        "OfficeBlock3": data.OfficeBlock3,
                                        "OfficeFirmName": data.OfficeFirmName,
                                        "OfficeWebsite": data.OfficeWebsite,
                                        "OfficeEmailId": data.OfficeEmailId,
                                        "OfficeAddress": data.OfficeAddress,
                                        "OfficeLandmark": data.OfficeLandmark,
                                        "OfficeWorkType": data.OfficeWorkType,
                                        "OfficeCompanyName": data.OfficeCompanyName,
                                        "Officedesignation": data.Officedesignation,
                                        "OfficeSince": data.OfficeSince,
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
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                          child: ListTile(
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
                                            trailing: new Text((data.Relation == null ||
                                                data.Relation == "")
                                                ? "-"
                                                : data.Relation),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ).toList(),
                              );
                            },
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            margin: EdgeInsets.fromLTRB(0, 0, 10, 5),
                            child: FloatingActionButton.extended(
                              label: Text(
                                'Add Member',
                                style: new TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              icon: Icon(Icons.add),
                              backgroundColor: Color(0xFFF44336),
                              onPressed: () {
                                Navigator.of(context).pushNamed("/addfamily");
                              },
                            ),
                          ),
                          SizedBox(
                            height: 5,
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
