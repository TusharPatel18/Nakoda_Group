import 'dart:async';

import 'package:nakoda_group/data/rest_ds.dart';
import 'package:nakoda_group/utils/network_util.dart';
import 'package:flutter/material.dart';
import 'package:nakoda_group/utils/connectionStatusSingleton.dart';
import 'package:nakoda_group/utils/flash_helper.dart';
import 'package:nakoda_group/utils/internetconnection.dart';

class ForgoOtpVerificationScreen extends StatefulWidget {
  ForgoOtpVerificationScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ForgoOtpVerificationScreenState createState() =>
      _ForgoOtpVerificationScreenState();
}

class _ForgoOtpVerificationScreenState
    extends State<ForgoOtpVerificationScreen> {
  BuildContext _ctx;
  String _otp;
  bool _isLoading = false, _ispageLoading = true;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  bool passwordVisible = true;
  String id = null, otp = null;

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

  Widget _resendotptext() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Not get OTP yet ?',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              setState(() {
                _ispageLoading = true;
              });
              NetworkUtil _netUtil = new NetworkUtil();
              _netUtil.post(RestDatasource.RESEND_OTP_URL, body: {
                "userid": id,
              }).then((dynamic res) async {
                if (res["error"] == true) {
                  FlashHelper.errorBar(context, message: res["message"]);
                  setState(() => _isLoading = false);
                } else {
                  FlashHelper.successBar(context, message: res["message"]);
                  setState(() {
                    otp = res["otp"].toString();
                  });
                  setState(() => _isLoading = false);
                }
                setState(() {
                  _ispageLoading = false;
                });
              });
            },
            child: Text(
              'Resend OTP',
              style: TextStyle(
                  color: Color(0xff022336),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _ctx = context;
      final Map arguments = ModalRoute.of(_ctx).settings.arguments as Map;
      if (arguments != null) {
        id = arguments['id'];
        otp = arguments['otp'];
        _ispageLoading = false;
      }
    });
    if (isOffline) {
      return connection.nointernetconnection();
    } else {
      return Scaffold(
          appBar: AppBar(
            title: new Text("OTP Verification"),
          ),
          key: scaffoldKey,
          body: (_ispageLoading == true)
              ? new Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: new Column(
                  children: <Widget>[
                    new Form(
                      key: formKey,
                      child: new Column(children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        new Image.asset(
                          'images/logo.png',
                          width: 140.0,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        new Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "OTP",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                  obscureText: false,
                                  keyboardType: TextInputType.number,
                                  onSaved: (val) => _otp = val,
                                  validator: validateOTP,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      fillColor: Color(0xfff3f3f4),
                                      filled: true))
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        new GestureDetector(
                          onTap: () {
                            if (_isLoading == false) {
                              final form = formKey.currentState;
                              if (form.validate()) {
                                setState(() => _isLoading = true);
                                form.save();
                                print("ID : " + id);
                                NetworkUtil _netUtil = new NetworkUtil();
                                _netUtil.post(RestDatasource.VERIFY_USER,
                                    body: {
                                      "userid": id,
                                      "otp": _otp
                                    }).then((dynamic res) async {
                                  if (res["error"] == true) {
                                    FlashHelper.errorBar(context,
                                        message: res["message"]);
                                    setState(() => _isLoading = false);
                                  } else {
                                    FlashHelper.successBar(context,
                                        message:
                                            "Your OTP verify Successfully");
                                    setState(() => _isLoading = false);
                                    Navigator.of(context).pushNamed(
                                        "/resetpassword",
                                        arguments: {"id": id});
                                  }
                                  setState(() {
                                    _ispageLoading = false;
                                  });
                                });
                              }
                            }
                          },
                          child: new Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 5),
                            margin: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
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
                              color: Colors.orange,
                            ),
                            child: _isLoading
                                ? new CircularProgressIndicator(
                                    backgroundColor: Colors.white)
                                : Text(
                                    'Submit',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
                          ),
                        ),
                      ]),
                    ),
                    _resendotptext(),
                  ],
                )));
    }
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

  String validateOTP(String value) {
// Indian Mobile number are of 10 digit only
    if (value.length != 5)
      return 'Enter Valid OTP';
    else
      return null;
  }
}
