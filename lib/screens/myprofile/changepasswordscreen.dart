import 'dart:async';

import 'package:nakoda_group/data/rest_ds.dart';
import 'package:nakoda_group/utils/network_util.dart';
import 'package:flutter/material.dart';
import 'package:nakoda_group/utils/connectionStatusSingleton.dart';
import 'package:nakoda_group/utils/flash_helper.dart';
import 'package:nakoda_group/utils/internetconnection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordScreen extends StatefulWidget {
  ChangePasswordScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  BuildContext _ctx;
  String _oldpassword, _newpassword, _confirmpassword;
  bool _isLoading = false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  bool oldpasswordVisible = false,
      newpasswordVisible = false,
      confirmpasswordVisible = false;
  bool isOffline = false;
  String loggedinname = "", loggedinid = "";
  InternetConnection connection = new InternetConnection();
  StreamSubscription _connectionChangeStream;
  @override
  initState() {
    super.initState();
    _loadPref();
    ConnectionStatusSingleton connectionStatus =
        ConnectionStatusSingleton.getInstance();
    connectionStatus.initialize();
    _connectionChangeStream =
        connectionStatus.connectionChange.listen(connectionChanged);
  }

  _loadPref() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loggedinname = prefs.getString("Name") ?? '';
      loggedinid = prefs.getString("UserId") ?? '';
    });
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
            title: new Text("Change Password"),
          ),
          key: scaffoldKey,
          body: SingleChildScrollView(
              child: new Column(
            children: <Widget>[
              new Form(
                key: formKey,
                child: new Column(children: <Widget>[
                  new Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Old Password",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                            obscureText: oldpasswordVisible,
                            keyboardType: TextInputType.text,
                            onSaved: (val) => _oldpassword = val,
                            validator: validatePassword,
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    // Based on passwordVisible state choose the icon
                                    oldpasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Color(0xff022336),
                                  ),
                                  onPressed: () {
                                    // Update the state i.e. toogle the state of passwordVisible variable
                                    setState(() {
                                      oldpasswordVisible = !oldpasswordVisible;
                                    });
                                  },
                                ),
                                border: InputBorder.none,
                                fillColor: Color(0xfff3f3f4),
                                filled: true))
                      ],
                    ),
                  ),
                  new Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "New Password",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                            obscureText: newpasswordVisible,
                            keyboardType: TextInputType.text,
                            onSaved: (val) => _newpassword = val,
                            validator: validatePassword,
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    // Based on passwordVisible state choose the icon
                                    newpasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Color(0xff022336),
                                  ),
                                  onPressed: () {
                                    // Update the state i.e. toogle the state of passwordVisible variable
                                    setState(() {
                                      newpasswordVisible = !newpasswordVisible;
                                    });
                                  },
                                ),
                                border: InputBorder.none,
                                fillColor: Color(0xfff3f3f4),
                                filled: true))
                      ],
                    ),
                  ),
                  new Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Confirm Password",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                            obscureText: confirmpasswordVisible,
                            keyboardType: TextInputType.text,
                            onSaved: (val) => _confirmpassword = val,
                            validator: validatePassword,
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    // Based on passwordVisible state choose the icon
                                    confirmpasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Color(0xff022336),
                                  ),
                                  onPressed: () {
                                    // Update the state i.e. toogle the state of passwordVisible variable
                                    setState(() {
                                      confirmpasswordVisible =
                                          !confirmpasswordVisible;
                                    });
                                  },
                                ),
                                border: InputBorder.none,
                                fillColor: Color(0xfff3f3f4),
                                filled: true))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  new GestureDetector(
                    onTap: () {
                      if (_isLoading == false) {
                        final form = formKey.currentState;
                        if (form.validate()) {
                          setState(() => _isLoading = true);
                          form.save();
                          NetworkUtil _netUtil = new NetworkUtil();
                          if (loggedinid != "" || loggedinid != null) {
                            if (_confirmpassword != _newpassword) {
                              FlashHelper.errorBar(context,
                                  message:
                                      "Confirm and New password not match");
                              setState(() => _isLoading = false);
                            } else {
                              _netUtil.post(RestDatasource.URL_CHANGE_PASSWORD,
                                  body: {
                                    "userid": loggedinid,
                                    "oldpassword": _oldpassword,
                                    "newpassword": _newpassword,
                                  }).then((dynamic res) async {
                                if (res["error"] == true) {
                                  FlashHelper.errorBar(context,
                                      message: res["message"]);
                                  setState(() => _isLoading = false);
                                } else {
                                  formKey.currentState.reset();
                                  FlashHelper.successBar(context,
                                      message: res["message"]);
                                  setState(() => _isLoading = false);
                                  //Navigator.of(context).pushNamed("/otpverification",arguments: {"id":res["id"],"otp":res["otp"]});
                                }
                              });
                            }
                          }
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
                              'Submit',
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

  String validatePassword(String value) {
    if (value.length <= 4)
      return 'Password must be more than 2 character';
    else
      return null;
  }
}
