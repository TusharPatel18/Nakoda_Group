import 'dart:async';
import 'dart:ui';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:nakoda_group/data/database_helper.dart';
import 'package:nakoda_group/data/rest_ds.dart';
import 'package:nakoda_group/models/user.dart';
import 'package:nakoda_group/utils/connectionStatusSingleton.dart';
import 'package:nakoda_group/utils/flash_helper.dart';
import 'package:nakoda_group/utils/internetconnection.dart';
import 'package:flutter/material.dart';
import 'package:nakoda_group/utils/network_util.dart';

import '../../auth.dart';
import 'login_screen_presenter.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen>
    implements LoginScreenContract, AuthStateListener {
  BuildContext _ctx;

  bool _isLoading = false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String _phonenumber, Token;
  LoginScreenPresenter _presenter;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  bool isOffline = false;
  InternetConnection connection = new InternetConnection();
  StreamSubscription _connectionChangeStream;

  @override
  initState() {
    super.initState();
    print("setstate called");
    ConnectionStatusSingleton connectionStatus =
        ConnectionStatusSingleton.getInstance();
    connectionStatus.initialize();
    _connectionChangeStream =
        connectionStatus.connectionChange.listen(connectionChanged);
    _firebaseMessaging.getToken().then((String t) {
      assert(t != null);
      setState(() {
        Token = t;
      });
    });
  }

  void connectionChanged(dynamic hasConnection) {
    setState(() {
      isOffline = !hasConnection;
      //print(isOffline);
    });
  }

  LoginScreenState() {
    _presenter = new LoginScreenPresenter(this);
    var authStateProvider = new AuthStateProvider();
    authStateProvider.subscribe(this);
  }

  @override
  onAuthStateChanged(AuthState state) {
    if (state == AuthState.LOGGED_IN)
      Navigator.of(context).pushNamedAndRemoveUntil('/sponserScreen', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    if (isOffline) {
      return connection.nointernetconnection();
    } else {
      return Scaffold(
        appBar: null,
        key: scaffoldKey,
        body: SingleChildScrollView(
          child: new Column(
            children: <Widget>[
              SizedBox(
                height: 100,
              ),
              new Image.asset(
                'images/logo.png',
                width: 160.0,
              ),
              SizedBox(
                height: 30,
              ),
              new Form(
                  key: formKey,
                  child: new Column(
                    children: <Widget>[
                      new Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Mobile Number",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                                obscureText: false,
                                keyboardType: TextInputType.number,
                                onSaved: (val) => _phonenumber = val,
                                validator: validateMobile,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    fillColor: Color(0xfff3f3f4),
                                    filled: true),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
              new GestureDetector(
                onTap: () async {
                  if (_isLoading == false) {
                    final form = formKey.currentState;
                    if (form.validate()) {
                      setState(() => _isLoading = true);
                      form.save();

                      // HttpClient client = new HttpClient();
                      // client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
                      // Map map = {
                      //   "mobile": _phonenumber
                      // };
                      // HttpClientRequest request = await client.postUrl(Uri.parse(RestDatasource.LOGIN_URL));
                      // request.headers.set('content-type', 'application/json');
                      // request.add(utf8.encode(json.encode(map)));
                      //
                      // HttpClientResponse response = await request.close();
                      // String reply = await response.transform(utf8.decoder).join();
                      // FlashHelper.errorBar(context, message:reply);

                      NetworkUtil _netUtil = new NetworkUtil();
                      _netUtil.post(RestDatasource.LOGIN_URL,
                          body: {
                            "mobile": _phonenumber,
                            "inputNotificationTocken": Token,
                          }).then((dynamic res) async {
                        if (res["status"] == "notfound") {
                          FlashHelper.errorBar(context, message: "Mobile Number Not Found");
                          setState(() => _isLoading = false);
                        }
                        else if (res["status"] == "block") {
                          FlashHelper.errorBar(context, message: "Opps! You are blocked by admin.");
                          setState(() => _isLoading = false);
                        }
                        else {
                          formKey.currentState.reset();
                          FlashHelper.successBar(context, message: "OTP sent to your mobile number : "
                              // +res["otp"]
                          );
                          setState(() => _isLoading = false);
                          Navigator.of(context).pushNamed(
                              "/otp", arguments: {
                            "code": res["otp"],
                            "mobile":_phonenumber,
                          });
                        }
                      });
                    }
                  }
                  // Navigator.of(context).pushNamed("/otp");
                },
                child: new Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
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
                    color: Color(0xFFF44336),
                  ),
                  child: _isLoading
                      ? new CircularProgressIndicator(
                          backgroundColor: Colors.white)
                      : Text(
                          'SEND OTP',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  String validateMobile(String value) {
// Indian Mobile number are of 10 digit only
    if (value.length != 10)
      return 'Mobile Number must be of 10 digit';
    else
      return null;
  }

  @override
  void onLoginError(String errorTxt) {
    FlashHelper.errorBar(context, message: errorTxt);
    setState(() => _isLoading = false);
  }

  @override
  void onLoginSuccess(User user) async {
    //_showSnackBar(user.toString());
    setState(() => _isLoading = false);
    var db = new DatabaseHelper();
    await db.saveUser(user);
    var authStateProvider = new AuthStateProvider();
    authStateProvider.notify(AuthState.LOGGED_IN);
  }
}
