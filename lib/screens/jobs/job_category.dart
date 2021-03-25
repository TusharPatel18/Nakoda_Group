import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nakoda_group/data/rest_ds.dart';
import 'package:nakoda_group/utils/connectionStatusSingleton.dart';
import 'package:nakoda_group/utils/flash_helper.dart';
import 'package:nakoda_group/utils/internetconnection.dart';
import 'package:nakoda_group/utils/network_util.dart';

class JobCategory extends StatefulWidget {
  @override
  _JobCategoryState createState() => _JobCategoryState();
}

class _JobCategoryState extends State<JobCategory> {
  NetworkUtil _netUtil = new NetworkUtil();
  final formKey = new GlobalKey<FormState>();
  bool _isJob = true;
  int _JobRadioValue = 0;
  bool isOffline = false;

  String _qualification,
         _experience,
         _salary;
  String _companyname,
         _title,
         _remark,
         _emailid,
         _phonenumber;

  bool _isLoading = false;
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
    if (isOffline) {
      return connection.nointernetconnection();
    } else {
      return Scaffold(
        appBar: AppBar(
            title: RichText(
              text: TextSpan(
                  text: "Job Category",
                  style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  children: [
                    TextSpan(
                        text: "",
                        style: TextStyle(color: Colors.blue, fontSize: 15))
                  ]),
            ),
        ),
        body: Container(
          child: ListView(
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    Card(
                      elevation: 3,
                      margin: new EdgeInsets.only(top: 5, bottom: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 10, top: 10, right: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Job Type :",
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
                                                  groupValue: _JobRadioValue,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _JobRadioValue = value;
                                                      _isJob = true;
                                                    });
                                                  },
                                                ),
                                                new Text(
                                                  'I Need Job',
                                                  style: new TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 16.0),
                                                ),
                                                new Radio(
                                                  value: 1,
                                                  activeColor: Colors.red,
                                                  groupValue: _JobRadioValue,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _JobRadioValue = value;
                                                      _isJob = false;
                                                    });
                                                  },
                                                ),
                                                new Text(
                                                  'I Have Job',
                                                  style: new TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 16.0),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ]
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          (_isJob)
                          ? Column(
                            children: [
                              // Container(
                              //   width: MediaQuery.of(context).size.width,
                              //   padding: EdgeInsets.fromLTRB(10, 10, 0, 5),
                              //   child: Text(
                              //     "YOUR PERSONAL DETAILS :",
                              //     style: TextStyle(
                              //       color: Colors.grey.shade800,
                              //       fontSize: 14,
                              //       fontWeight: FontWeight.w600,
                              //     ),
                              //   ),
                              // ),
                              // Divider(
                              //   color: Colors.grey,
                              //   endIndent: 10,
                              //   indent: 10,
                              // ),
                              Container(
                                margin: EdgeInsets.only(top: 10,left: 10, right: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Qualification :",
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
                                      onSaved: (val) => _qualification = val,
                                      validator: (value) => (value == null || value == "")
                                          ? 'Enter Qualification'
                                          : null,
                                      style: TextStyle(fontSize: 14),
                                      decoration: InputDecoration(
                                        hintText: "Enter Qualification",
                                        border: InputBorder.none,
                                        fillColor: Color(0xfff3f3f4),
                                        filled: true,
                                      ),
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
                                      "Experience :",
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
                                      onSaved: (val) => _experience = val,
                                      style: TextStyle(fontSize: 14),
                                      decoration: InputDecoration(
                                        hintText: "Enter Experience",
                                        border: InputBorder.none,
                                        fillColor: Color(0xfff3f3f4),
                                        filled: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Expected Salary :",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    TextFormField(
                                      obscureText: false,
                                      keyboardType: TextInputType.number,
                                      onSaved: (val) => _salary = val,
                                      validator: (value) => (value == null || value == "")
                                          ? 'Enter Expected Salary'
                                          : null,
                                      style: TextStyle(fontSize: 14),
                                      decoration: InputDecoration(
                                        hintText: "Enter Expected Salary",
                                        border: InputBorder.none,
                                        fillColor: Color(0xfff3f3f4),
                                        filled: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                          : Column(
                            children: [
                              // Container(
                              //   width: MediaQuery.of(context).size.width,
                              //   padding: EdgeInsets.fromLTRB(10, 10, 0, 5),
                              //   child: Text(
                              //     "Job Requirements :",
                              //     style: TextStyle(
                              //       color: Colors.grey.shade800,
                              //       fontSize: 14,
                              //       fontWeight: FontWeight.w600,
                              //     ),
                              //   ),
                              // ),
                              // Divider(
                              //   color: Colors.grey,
                              //   indent: 10,
                              //   endIndent: 10,
                              // ),
                              Container(
                                margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Company Name :",
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
                                      onSaved: (val) => _companyname = val,
                                      validator: (value) =>
                                      (value == null || value == "")
                                          ? 'Enter Company Name'
                                          : null,
                                      style: TextStyle(fontSize: 14),
                                      decoration: InputDecoration(
                                        hintText: "Enter Company Name",
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
                                      "Title :",
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
                                      onSaved: (val) => _title = val,
                                      validator: (value) =>
                                      (value == null || value == "")
                                          ? 'Enter Title'
                                          : null,
                                      style: TextStyle(fontSize: 14),
                                      decoration: InputDecoration(
                                        hintText: "Enter Title",
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
                                      "Remark :",
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
                                      maxLines: 5,
                                      onSaved: (val) => _remark = val,
                                      validator: (value) =>
                                      (value == null || value == "")
                                          ? 'Enter Remark'
                                          : null,
                                      style: TextStyle(fontSize: 14),
                                      decoration: InputDecoration(
                                        hintText: "Enter Remark",
                                        border: InputBorder.none,
                                        fillColor: Color(0xfff3f3f4),
                                        filled: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Email ID :",
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
                                      onSaved: (val) => _emailid = val,
                                      validator: validateEmail,
                                      style: TextStyle(fontSize: 14),
                                      decoration: InputDecoration(
                                        hintText: "Enter Email Id",
                                        border: InputBorder.none,
                                        fillColor: Color(0xfff3f3f4),
                                        filled: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10, top: 10, right: 10,bottom: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Mobile No. :",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    TextFormField(
                                      obscureText: false,
                                      keyboardType: TextInputType.number,
                                      onSaved: (val) => _phonenumber = val,
                                      style: TextStyle(fontSize: 14),
                                      validator: (value) => value.trim().length != 10
                                          ? 'Mobile Number must be of 10 digit'
                                          : null,
                                      decoration: InputDecoration(
                                        hintText: "Enter Mobile Number",
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
                    Card(
                      elevation: 3,
                      margin: new EdgeInsets.only(top: 5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                      child: new InkWell(
                        onTap: () async {
                          if(_isJob == true) {
                              final form = formKey.currentState;
                              if (form.validate()) {
                                setState(() => _isLoading = true);
                                form.save();
                                print(_qualification.toString());
                                print(_experience.toString());
                                print(_salary.toString());
                                _netUtil.post(RestDatasource.GET_I_NEED_JOB_URL,
                                    body: {
                                  "txtqulification": _qualification.toString() ?? "",
                                  "txtexperience": _experience.toString() ?? "",
                                  "txtexpectedsalary": _salary.toString() ?? "",
                                }).then((dynamic res) async {
                                  print(res);
                                  if (res["status"] == "yes") {
                                    formKey.currentState.reset();
                                    FlashHelper.successBar(context,
                                        message: "Job Application added...");
                                    setState(() => _isLoading = false
                                    );
                                    Navigator.of(context).pushReplacementNamed(
                                        '/home');
                                  } else {
                                    FlashHelper.successBar(context,
                                        message: "Fail! try again later!...");
                                    setState(() => _isLoading = false
                                    );
                                  }
                                });
                              }
                          }
                          else{
                            {
                              final form = formKey.currentState;
                              if (form.validate()) {
                                setState(() => _isLoading = true);
                                form.save();
                                _netUtil.post(RestDatasource.GET_I_HAVE_JOB_URL,
                                    body: {
                                      "txtcompanyname": _companyname.toString() ?? "",
                                      "txtemailid": _emailid.toString() ?? "",
                                      "txttitle": _title.toString() ?? "",
                                      "txtcontactnumber": _phonenumber.toString() ?? "",
                                      "txtremark": _remark ?? "",
                                    }).then((dynamic res) async {
                                  if (res["status"] == "yes") {
                                    formKey.currentState.reset();
                                    FlashHelper.successBar(context,
                                        message: "Job Application added...");
                                    setState(() => _isLoading = false
                                    );
                                    Navigator.of(context).pushReplacementNamed(
                                        '/home');
                                  } else {
                                    FlashHelper.successBar(context,
                                        message: "Fail! try again later!...");
                                    setState(() => _isLoading = false
                                    );
                                  }
                                });
                              }
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
            ],
          ),
        ),
      );
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
}
