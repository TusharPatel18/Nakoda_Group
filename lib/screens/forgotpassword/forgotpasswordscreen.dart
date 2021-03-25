import 'dart:async';

import 'package:nakoda_group/data/rest_ds.dart';
import 'package:nakoda_group/utils/network_util.dart';
import 'package:flutter/material.dart';
import 'package:nakoda_group/utils/connectionStatusSingleton.dart';
import 'package:nakoda_group/utils/flash_helper.dart';
import 'package:nakoda_group/utils/internetconnection.dart';

class ForgotPasswordScreen extends StatefulWidget {
  ForgotPasswordScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  BuildContext _ctx;
  String _name, _contact, _emailid, _password;
  bool _isLoading = false, _ispageLoading = false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  bool passwordVisible = true;
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
              //Navigator.of(_ctx).pop();
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
    });
    if (isOffline) {
      return connection.nointernetconnection();
    } else {
      return Scaffold(
          appBar: AppBar(
            title: new Text("Forgot Password?"),
          ),
          key: scaffoldKey,
          body: SingleChildScrollView(
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
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Your Mobile Number",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                            obscureText: false,
                            keyboardType: TextInputType.phone,
                            onSaved: (val) => _contact = val,
                            validator: validateMobile,
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
                          NetworkUtil _netUtil = new NetworkUtil();
                          _netUtil.post(RestDatasource.VERIFY_CONTACT, body: {
                            "contact": _contact,
                          }).then((dynamic res) async {
                            if (res["error"] == true) {
                              FlashHelper.errorBar(context,
                                  message: res["message"]);
                              setState(() => _isLoading = false);
                            } else {
                              FlashHelper.successBar(context,
                                  message: res["message"]);
                              setState(() => _isLoading = false);
                              Navigator.of(context).pushNamed(
                                  "/forgototpverification",
                                  arguments: {
                                    "id": res["id"],
                                    "otp": res["otp"]
                                  });
                            }
                            setState(() {
                              _ispageLoading = false;
                            });
                          });
                        }
                      }
                    },
                    child: new Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
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
                        color: Colors.orange,
                      ),
                      child: _isLoading
                          ? new CircularProgressIndicator(
                              backgroundColor: Colors.white)
                          : Text(
                              'Send OTP',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                    ),
                  ),
                ]),
              )
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

  String validateName(String value) {
    if (value.length < 3)
      return 'Name must be more than 2 charater';
    else
      return null;
  }

  String validatePassword(String value) {
    if (value.length <= 4)
      return 'Password must be more than 2 character';
    else
      return null;
  }

  String validateMobile(String value) {
// Indian Mobile number are of 10 digit only
    if (value.length != 10)
      return 'Mobile Number must be of 10 digit';
    else
      return null;
  }
}
