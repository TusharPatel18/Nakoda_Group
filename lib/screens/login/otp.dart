import 'dart:async';
import 'dart:ui';

import 'package:nakoda_group/data/database_helper.dart';
import 'package:nakoda_group/models/user.dart';
import 'package:nakoda_group/utils/connectionStatusSingleton.dart';
import 'package:nakoda_group/utils/flash_helper.dart';
import 'package:nakoda_group/utils/internetconnection.dart';
import 'package:flutter/material.dart';

import '../../auth.dart';
import 'login_screen_presenter.dart';

class OtpVerificationScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new OtpVerificationScreenState();
  }
}

class OtpVerificationScreenState extends State<OtpVerificationScreen>
    implements LoginScreenContract, AuthStateListener {
  BuildContext _ctx;

  bool _isLoading = false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String _otpnumber;
  LoginScreenPresenter _presenter;
  String code = "", mobile = "";
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

  }

  void connectionChanged(dynamic hasConnection) {
    setState(() {
      isOffline = !hasConnection;
      //print(isOffline);
    });
  }

  OtpVerificationScreenState() {
    _presenter = new LoginScreenPresenter(this);
    var authStateProvider = new AuthStateProvider();
    authStateProvider.subscribe(this);
  }

  @override
  onAuthStateChanged(AuthState state) {
    if (state == AuthState.LOGGED_IN)
      Navigator.of(_ctx).pushReplacementNamed("/sponserScreen");
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    final Map arguments = ModalRoute.of(_ctx).settings.arguments as Map;
    if (arguments != null) {
      setState(() {
        code = arguments['code'];
        mobile = arguments['mobile'];
      });
      // FlashHelper.successBar(context, message: code);
    }

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
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "OTP Number",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                  obscureText: false,
                                  keyboardType: TextInputType.number,
                                  onSaved: (val) => _otpnumber = val,
                                  validator: validateOTP,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      fillColor: Color(0xfff3f3f4),
                                      filled: true),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                ),
                new GestureDetector(
                  onTap: () {
                    if (_isLoading == false) {
                      final form = formKey.currentState;
                      if (form.validate()) {
                        setState(() => _isLoading = true);
                        form.save();
                        if (code == _otpnumber) {
                          _presenter.doLogin(mobile);
                        } else {
                          FlashHelper.errorBar(context,
                              message: "OTP not match");
                          setState(() => _isLoading = false);
                        }
                      }
                    }
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
                            'Submit',
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

  @override
  void onLoginError(String errorTxt) {
    FlashHelper.errorBar(context, message: errorTxt);
    setState(() => _isLoading = false);
  }

  String validateOTP(String value) {
    if (value.length < 4)
      return 'OTP must be 4 numbers';
    else
      return null;
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
