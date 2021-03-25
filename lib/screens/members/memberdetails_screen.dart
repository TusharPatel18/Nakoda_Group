import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nakoda_group/data/rest_ds.dart';
import 'package:nakoda_group/utils/connectionStatusSingleton.dart';
import 'package:nakoda_group/utils/internetconnection.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class MemberDetailScreen extends StatefulWidget {
  @override
  _MemberDetailScreenState createState() => _MemberDetailScreenState();
}

class _MemberDetailScreenState extends State<MemberDetailScreen> {
  BuildContext _ctx;
  String memberid,
      membername,
      contact,
      ProfileImage,
      MiddleName,
      Education,
      OtherEducationName,
      EmailId,
      BloodGroup,
      LastGautra,
      DOB,_DOB;
  String MemberType;
  String MainMemberId;
  String Mobile2;
  String Mobile3;
  String Relation;
  String ProfessionId,ProfessionName;
  String NativeId;
  String NanihalGautra, NanihalNative, NanihalBusiness;
  String SasuralGautra,
      SasuralNative,
      SasuralBusiness,
      Gender,
      Married,
      AniversaryDate,_AniversaryDate;
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

  _onShare(BuildContext context) async {

    var EDu =  (Education == "OTHER")
                  ? (OtherEducationName == null || OtherEducationName == "")
                       ? "-"
                       : OtherEducationName.toUpperCase()
                  : (Education == null || Education == "")
                       ? "-"
                       : Education.toUpperCase();
    var Emailid = EmailId == "" || EmailId.toString() == "null" ? "-" : EmailId ;
    var profession = ProfessionName == "" || ProfessionName.toString() == "null" ? "-" : ProfessionName ;
    var nnative = NanihalNative == "" || NanihalNative.toString() == "null" ? "-" : NanihalNative ;
    var ngautra = NanihalGautra == "" || NanihalGautra.toString() == "null" ? "-" : NanihalGautra ;
    var nbusinesscity = NanihalBusiness == "" || NanihalBusiness.toString() == "null" ? "-" : NanihalBusiness ;
    var bloodgroup = BloodGroup == "" || BloodGroup.toString() == "null" ? "-" : BloodGroup ;
    var sgautra = SasuralGautra == "" || SasuralGautra.toString() == "null" ? "-" : SasuralGautra ;
    var snative = SasuralNative == "" || SasuralNative.toString() == "null" ? "-" : SasuralNative ;
    var sbusinesscity = SasuralBusiness == "" || SasuralBusiness.toString() == "null" ? "-" : SasuralBusiness ;
    var dob = _DOB == "" || _DOB.toString() == "null" ? "-" : _DOB ;
    var aniversarydate = _AniversaryDate == "" || _AniversaryDate.toString() == "null" ? "-" : _AniversaryDate ;

    var residanceAddress = ResidanceAddress == "" || ResidanceAddress.toString() == "null" ? "" : ResidanceAddress ;
    var residanceLandmark = ResidanceLandmark == "" || ResidanceLandmark.toString() == "null" ? "" : ResidanceLandmark ;
    var Rcity = rcity == "" || rcity.toString() == "null" ? "" : rcity ;
    var Rstate = rstate == "" || rstate.toString() == "null" ? "" : rstate ;
    var rpincode = ResidancePincode == "" || ResidancePincode.toString() == "null" ? "" : ResidancePincode ;
    var residanceTelephone = ResidanceTelephone == "" || ResidanceTelephone.toString() == "null" ? "" : ResidanceTelephone ;
    var residanceMobile = ResidanceMobile == "" || ResidanceMobile.toString() == "null" ? "" : ResidanceMobile ;

    var nativeoffice = NativeOffice == "" || NativeOffice.toString() == "null" ? "" : NativeOffice ;
    var nativeLandmark = NativeLandmark == "" || NativeLandmark.toString() == "null" ? "" : NativeLandmark ;
    var Ncity = ncity == "" || ncity.toString() == "null" ? "" : ncity ;
    var Nstate = nstate == "" || nstate.toString() == "null" ? "" : nstate ;
    var npincode = NativePincode == "" || NativePincode.toString() == "null" ? "" : NativePincode ;
    var nativeTelephone = NativeTelephone == "" || NativeTelephone.toString() == "null" ? "" : NativeTelephone ;
    var nativeMobile = NativeMobile == "" || NativeMobile.toString() == "null" ? "" : NativeMobile ;

     await Share.share("Share Details:\n" "Name: " + membername.toUpperCase() +" "+ MiddleName.toUpperCase() +" "+ LastGautra.toUpperCase() +
        "\n" + "Phone Number: " + contact +
        "\n" + "Email Id: " + Emailid +
        "\n" + "Education: " + EDu +
        "\n" + "profession: " + profession +
        "\n" + "Native Place: " + nnative +
        "\n" + "BloodGroup: " + bloodgroup +
        "\n" + "Nanihal Gautra: " + ngautra.toUpperCase() + " / " + nnative + "/ " + nbusinesscity +
        "\n" + "Sasural Gautra: " + sgautra.toUpperCase() + " / " + snative + " / " + sbusinesscity +
        "\n" + "Date Of Birth: " + dob +
        "\n" + "Gender: " + Gender.toUpperCase() +
        "\n" + "Married: " + Married +
        "\n" + "Aniversary Date: " + aniversarydate + "\n" +

        "\n" + 'RESIDENCE INFORMATION:' +
        "\n" + 'ResidanceAddress: ' + residanceAddress + " " + residanceLandmark + " " + Rcity + " " + Rstate + " " + rpincode +
        "\n" + 'ResidanceTelephone: ' + residanceTelephone +
        "\n" + 'ResidanceMobile: ' + residanceMobile + "\n" +

        "\n" + 'NATIVE INFORMATION:' +
        "\n" + 'Native Office: ' + nativeoffice + " " + nativeLandmark + " " + Ncity + " " + Nstate + " " + npincode +
        "\n" + 'Native Telephone: ' + nativeTelephone +
        "\n" + 'Native Mobile: ' + nativeMobile
    );
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _ctx = context;
      final Map arguments = ModalRoute.of(_ctx).settings.arguments as Map;
      if (arguments != null) {
        memberid = arguments['id'];
        membername = arguments['FirstName'];
        LastGautra = arguments['LastGautra'];
        contact = arguments['Contact'];
        ProfileImage = arguments['Photo'];
        MiddleName = arguments['MiddleName'];
        Education = arguments['Education'];
        OtherEducationName = arguments['OtherEducationName'];
        BloodGroup = arguments['BloodGroup'];
        EmailId = arguments['EmailId'];
        DOB = arguments['DOB'];
        MemberType = arguments['MemberType'];
        MainMemberId = arguments['MainMemberId'];
        Relation = arguments['Relation'];
        Mobile2 = arguments['Mobile2'];
        Mobile3 = arguments['Mobile3'];
        ProfessionId = arguments['ProfessionId'];
        ProfessionName =  arguments['ProfessionName'];
        NativeId = arguments['NativeId'];
        NanihalNative = arguments['NanihalNative'];
        NanihalBusiness = arguments['NanihalBusiness'];
        SasuralGautra = arguments['SasuralGautra'];
        SasuralNative = arguments['SasuralNative'];
        Gender = arguments['Gender'];
        Married = arguments['Married'];
        AniversaryDate = arguments['AniversaryDate'];
        ResidanceLandmark = arguments['ResidanceLandmark'];
        ResidenaceCityId = arguments['ResidenaceCityId'];
        ResidanceMobile = arguments['ResidanceMobile'];
        ResidanceTelephone = arguments['ResidanceTelephone'];
        ResidancePincode = arguments['ResidancePincode'];
        OfficeFirmName = arguments['OfficeFirmName'];
        OfficeWebsite = arguments['OfficeWebsite'];
        OfficeEmailId = arguments['OfficeEmailId'];
        OfficeAddress = arguments['OfficeAddress'];
        OfficeLandmark = arguments['OfficeLandmark'];
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
        ResidanceAddress = arguments['ResidanceAddress'];
        SasuralBusiness = arguments['SasuralBusiness'];
        NanihalGautra = arguments['NanihalGautra'];
        FormNumber = arguments['FormNumber'];
        rcity = arguments['rcity'];
        rstate = arguments['rcity'];
        ostate = arguments['ostate'];
        ocity = arguments['ocity'];
        nstate = arguments['nstate'];
        ncity = arguments['ncity'];

        DateFormat dateFormat = DateFormat("yyyy-MM-dd");
        if(DOB != null){
          DateTime dateTime = dateFormat.parse(DOB);
          String sdate = DateFormat('dd-MM-yyyy').format(dateTime);
          _DOB = sdate;
        }

        if(AniversaryDate != null){
          DateTime dateTime1 = dateFormat.parse(AniversaryDate);
          String adate = DateFormat('dd-MM-yyyy').format(dateTime1);
          _AniversaryDate = adate;
        }

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
          actions: [
            IconButton(
                icon: Image.asset("assets/share.png",color: Colors.white,height: 24,width: 24,),
                onPressed: () async {
                  _onShare(context);
                }),
          ],
        ),
        body: Container(
          child: ListView(
            children: <Widget>[
              Card(
                elevation: 5,
                margin: new EdgeInsets.all(5),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    new Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: <Widget>[
                          new CircleAvatar(
                            child: (ProfileImage == null || ProfileImage == "")
                                ? CircleAvatar(
                                    radius: 65,
                                    child: new Text(
                                      (membername == null || membername == "")
                                          ? "-"
                                          : membername[0].toUpperCase() +
                                              MiddleName[0].toUpperCase(),
                                      style: new TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30,
                                          color: Color(0xFFF44336)),
                                    ),
                                    backgroundColor: Colors.red.shade100,
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
                            height: 10,
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
                        style: new TextStyle(fontSize: 18),
                      ),
                      subtitle: new Text('Name'),
                    ),
                    new ListTile(
                      title: new Text(
                         (contact == null || contact == "") ? "-" : contact,
                        style: new TextStyle(fontSize: 18),
                      ),
                      subtitle: new Text('Phone Number'),
                      trailing: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              icon: Icon(
                                Icons.call,
                                color: Colors.black,
                                size: 24.0,),
                              onPressed: () async {
                                var url = contact ?? "";
                                if (await canLaunch('tel:$url')) {
                                await launch('tel:$url');
                                } else {
                                throw 'Could not launch $url';
                                }
                              }),
                          IconButton(
                                icon: Image.asset("assets/chat.png",height: 24,width: 24,),
                              onPressed: () async {
                                var url = contact ?? "";
                                if (await canLaunch('sms:$url')) {
                                  await launch('sms:$url');
                                } else {
                                  throw 'Could not launch $url';
                                }
                              }),
                          IconButton(
                              icon: Image.asset("assets/whatsapp.png",height: 24,width: 24,),
                              onPressed: () async {
                                var phone = "+91" + contact;
                                var url = "whatsapp://send?phone=$phone";
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'There is no whatsapp installed in your device $url';
                                }
                              }),
                        ],
                      ),
                    ),
                    new ListTile(
                      title: new Text(
                        (EmailId == null || EmailId == "") ? "-" : EmailId,
                        style: new TextStyle(fontSize: 18),
                      ),
                      subtitle: new Text('Email Id'),
                      trailing: IconButton(
                          icon: Image.asset("assets/gmail.png",height: 24,width: 24,),
                          onPressed: () async {
                            final Uri params = Uri(
                              scheme: 'mailto',
                              path: EmailId,
                            );
                            var url = params.toString();
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'This EmailId is Wrong $url';
                            }
                          }),
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
                        (ProfessionName == null || ProfessionName == "")
                            ? "-"
                            : ProfessionName,
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
                            (NanihalGautra.toString() == "null" || NanihalGautra == "")
                                ? "-"
                                : NanihalGautra.toUpperCase(),
                            style: new TextStyle(fontSize: 18),
                          ),
                          Text("/"),
                          new Text(
                            (NanihalNative.toString() == "null" || NanihalNative == "")
                                ? "-"
                                : NanihalNative.toUpperCase(),
                            style: new TextStyle(fontSize: 18),
                          ),
                          Text("/"),
                          new Text(
                            (NanihalBusiness.toString() == "null" || NanihalBusiness == "")
                                ? "-"
                                : NanihalBusiness.toUpperCase(),
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
                            (SasuralGautra == "" || SasuralGautra.toString() == "null")
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
                        (_DOB == null || _DOB == "") ? "-" : _DOB,
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
                      title: (Married == "N")
                          ? Text("-",style: new TextStyle(fontSize: 18),)
                          : Text(
                        (_AniversaryDate == null || _AniversaryDate == "")
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
                        (ResidancePincode == null || ResidancePincode == "")
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
            ],
          ),
        ),
      );
    }
  }
}
