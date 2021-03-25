// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:nakoda_group/data/rest_ds.dart';
// import 'package:nakoda_group/models/family.dart';
// import 'package:nakoda_group/utils/connectionStatusSingleton.dart';
// import 'package:nakoda_group/utils/internetconnection.dart';
// import 'package:nakoda_group/utils/network_util.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class MyFamilyScreen extends StatefulWidget {
//   @override
//   _MyFamilyScreenState createState() => _MyFamilyScreenState();
// }
//
// class _MyFamilyScreenState extends State<MyFamilyScreen> {
//   NetworkUtil _netUtil = new NetworkUtil();
//   final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey1 =
//       new GlobalKey<RefreshIndicatorState>();
//
//   Future<List<Family>> familydata;
//   Future<List<Family>> familyfilterData;
//
//   TextEditingController _searchQueryUser;
//   bool _isSearchingUser = false;
//   String searchQueryUser = "Search query";
//   String id = "";
//
//   _loadPref() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       id = prefs.getString("MembershipId");
//       familydata = _getUserData(id);
//       familyfilterData = familydata;
//     });
//   }
//
//   Future<List<Family>> _refresh1() async {
//     setState(() {
//       familydata = _getUserData(id);
//       familyfilterData = familydata;
//     });
//   }
//
//   Future<List<Family>> _getUserData(String id) async {
//     return _netUtil.post(RestDatasource.URL_FAMILY_LIST,
//         body: {"MemberShipId": id}).then((dynamic res) {
//       final items = res.cast<Map<String, dynamic>>();
//       List<Family> listofusers = items.map<Family>((json) {
//         return Family.fromJson(json);
//       }).toList();
//       List<Family> revdata = listofusers.reversed.toList();
//       return revdata;
//     });
//   }
//
//   bool isOffline = false;
//   InternetConnection connection = new InternetConnection();
//   StreamSubscription _connectionChangeStream;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     ConnectionStatusSingleton connectionStatus =
//         ConnectionStatusSingleton.getInstance();
//     connectionStatus.initialize();
//     _connectionChangeStream =
//         connectionStatus.connectionChange.listen(connectionChanged);
//     _loadPref();
//     _searchQueryUser = new TextEditingController();
//   }
//
//   void connectionChanged(dynamic hasConnection) {
//     setState(() {
//       isOffline = !hasConnection;
//       //print(isOffline);
//     });
//   }
//
//   Widget _buildSearchField() {
//     return new TextField(
//       controller: _searchQueryUser,
//       autofocus: true,
//       decoration: const InputDecoration(
//         hintText: 'Search...',
//         border: InputBorder.none,
//         hintStyle: const TextStyle(color: Colors.white),
//       ),
//       style: const TextStyle(color: Colors.white, fontSize: 16.0),
//       onChanged: updateSearchQuery,
//     );
//   }
//
//   List<Widget> _buildActions() {
//     if (_isSearchingUser) {
//       return <Widget>[
//         new IconButton(
//           icon: const Icon(Icons.clear),
//           onPressed: () {
//             if (_searchQueryUser == null || _searchQueryUser.text.isEmpty) {
//               Navigator.pop(context);
//               return;
//             }
//             _clearSearchQuery();
//           },
//         ),
//       ];
//     }
//     return <Widget>[
//       new IconButton(
//         icon: const Icon(Icons.search),
//         onPressed: _startSearch,
//       ),
//     ];
//   }
//
//   void _clearSearchQuery() {
//     //print("close search box");
//     setState(() {
//       _searchQueryUser.clear();
//       familyfilterData = familydata;
//       updateSearchQuery("");
//     });
//   }
//
//   void _startSearch() {
//     //print("open search box");
//     ModalRoute.of(context)
//         .addLocalHistoryEntry(new LocalHistoryEntry(onRemove: _stopSearching));
//     setState(() {
//       _isSearchingUser = true;
//     });
//   }
//
//   void _stopSearching() {
//     _clearSearchQuery();
//     setState(() {
//       _isSearchingUser = false;
//     });
//   }
//
//   void updateSearchQuery(String newQuery) {
//     setState(() {
//       searchQueryUser = newQuery;
//       if (_searchQueryUser.toString().length > 0) {
//         //print(searchQuery.toString().length);
//         Future<List<Family>> items = familydata;
//         List<Family> filter = new List<Family>();
//         items.then((result) {
//           for (var record in result) {
//             if (record.FirstName.toLowerCase()
//                     .toString()
//                     .contains(searchQueryUser.toLowerCase()) ||
//                 record.Mobile1.toLowerCase()
//                     .toString()
//                     .contains(searchQueryUser.toLowerCase())) {
//               filter.add(record);
//             }
//           }
//           familyfilterData = Future.value(filter);
//         });
//       } else {
//         familyfilterData = familydata;
//       }
//     });
//     print("search query1 " + newQuery);
//   }
//
//   Widget _divider() {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 0),
//       child: Row(
//         children: <Widget>[
//           Expanded(
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 0),
//               child: Divider(
//                 thickness: 1,
//               ),
//             ),
//           ),
//           Expanded(
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 0),
//               child: Divider(
//                 thickness: 1,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (isOffline) {
//       return connection.nointernetconnection();
//     } else {
//       return Scaffold(
//         appBar: AppBar(
//           title: _isSearchingUser
//               ? _buildSearchField()
//               : RichText(
//                   text: TextSpan(
//                       text: "My Family",
//                       style:
//                           TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                       children: [
//                         TextSpan(
//                           text: "",
//                           style: TextStyle(color: Colors.blue, fontSize: 15),
//                         ),
//                       ]),
//                 ),
//           actions: _buildActions(),
//         ),
//         floatingActionButton: FloatingActionButton.extended(
//           label: Text(
//             'Add New',
//             style: new TextStyle(
//               fontSize: 15,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           icon: Icon(Icons.add),
//           backgroundColor: Color(0xFFF44336),
//           onPressed: () {
//             Navigator.of(context).pushNamed("/addfamily");
//           },
//         ),
//         body: new RefreshIndicator(
//           key: _refreshIndicatorKey1,
//           onRefresh: _refresh1,
//           child: FutureBuilder<List<Family>>(
//             future: familyfilterData,
//             builder: (context, snapshot) {
//               //print(snapshot.data);
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Center(
//                   child: CircularProgressIndicator(),
//                 );
//               } else if (!snapshot.hasData) {
//                 return Center(
//                   child: Text("No Data Available!"),
//                 );
//               }
//               return ListView(
//                 padding: EdgeInsets.only(bottom: 70.0),
//                 children: snapshot.data
//                     .map(
//                       (data) => InkWell(
//                         onTap: () {
//                           Navigator.of(context).pushNamed("/myfamilydetails", arguments: {
//                             "Membershipid": data.MembershipId,
//                             "FirstName": data.FirstName,
//                             "Contact": data.Mobile1,
//                             "Photo": data.Photo,
//                             "MiddleName": data.MiddleName,
//                             "LastGautra": data.LastGautra,
//                             "Education": data.Education,
//                             "SpecialInfo": data.SpecialInfo,
//                             "EmailId": data.EmailId,
//                             "BloodGroup": data.BloodGroup,
//                             "MainMemberId": data.MainMemberId,
//                             "DOB": data.DOB,
//                             "Height": data.Height,
//                             "PovLevel": data.IncomeLevel,
//                             "Relation": data.Relation,
//                             "Mobile2": data.Mobile2,
//                             "Mobile3": data.Mobile3,
//                             "MemberType": data.MemberType,
//                             "ProfessionId": data.ProfessionId,
//                             "NativeId": data.NativeId,
//                             "NanihalNative": data.NanihalNative,
//                             "NanihalBusiness": data.NanihalBusiness,
//                             "NanihalGautra": data.NanihalGautra,
//                             "SasuralGautra": data.SasuralGautra,
//                             "SasuralNative": data.SasuralNative,
//                             "SasuralBusiness": data.SasuralBusiness,
//                             "Gender": data.Gender,
//                             "Married": data.Married,
//                             "AniversaryDate": data.AniversaryDate,
//                             "ResidanceLandmark": data.ResidanceLandmark,
//                             "ResidenaceCityId": data.ResidenaceCityId,
//                             "ResidanceMobile": data.ResidanceMobile,
//                             "ResidanceTelephone": data.ResidanceTelephone,
//                             "ResidancePincode": data.ResidancePincode,
//                             "ResidanceAddress": data.ResidanceAddress,
//                             "OfficeBlock1": data.OfficeBlock1,
//                             "OfficeBlock2": data.OfficeBlock2,
//                             "OfficeBlock3": data.OfficeBlock3,
//                             "OfficeFirmName": data.OfficeFirmName,
//                             "OfficeWebsite": data.OfficeWebsite,
//                             "OfficeEmailId": data.OfficeEmailId,
//                             "OfficeAddress": data.OfficeAddress,
//                             "OfficeLandmark": data.OfficeLandmark,
//                             "OfficeWorkType": data.OfficeWorkType,
//                             "OfficeCompanyName": data.OfficeCompanyName,
//                             "Officedesignation": data.Officedesignation,
//                             "OfficeSince": data.OfficeSince,
//                             "OfficeCityId": data.OfficeCityId,
//                             "OfficeMobile": data.OfficeMobile,
//                             "OfficeTelephone": data.OfficeTelephone,
//                             "OfficePincode": data.OfficePincode,
//                             "NativeOffice": data.NativeOffice,
//                             "NativeLandmark": data.NativeLandmark,
//                             "NativeCityId": data.NativeCityId,
//                             "NativeMobile": data.NativeMobile,
//                             "NativeTelephone": data.NativeTelephone,
//                             "NativePincode": data.NativePincode,
//                             "RecName1": data.RecName1,
//                             "RecName2": data.RecName2,
//                             "TrusteeName": data.TrusteeName,
//                             "FormNumber": data.FormNumber,
//                             "NativeName": data.NativeName,
//                             "rcity": data.rcity,
//                             "rstate": data.rstate,
//                             "ostate": data.ostate,
//                             "ocity": data.ocity,
//                             "nstate": data.nstate,
//                             "ncity": data.ncity,
//                           });
//                         },
//                         child: Column(
//                           children: <Widget>[
//                             Padding(
//                               padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
//                               child: ListTile(
//                                 leading: (data.Photo == null ||
//                                         data.Photo == "")
//                                     ? CircleAvatar(
//                                         radius: 30,
//                                         child: new Text(
//                                           data.FirstName[0].toUpperCase() +
//                                               data.MiddleName[0].toUpperCase(),
//                                           style: new TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               color: Color(0xFFF44336)),
//                                         ),
//                                         backgroundColor: Colors.red.shade100,
//                                       )
//                                     : CircleAvatar(
//                                         radius: 30,
//                                         backgroundImage: NetworkImage(
//                                             RestDatasource.Committee_IMAGE_URL +
//                                                 data.Photo),
//                                       ),
//                                 title: new Text(
//                                   ((data.FirstName == null ||
//                                               data.FirstName == "")
//                                           ? "-"
//                                           : data.FirstName.toUpperCase()) +
//                                       " " +
//                                       ((data.MiddleName == null ||
//                                               data.MiddleName == "")
//                                           ? "-"
//                                           : data.MiddleName.toUpperCase()) +
//                                       " " +
//                                       ((data.LastGautra == null ||
//                                               data.LastGautra == "")
//                                           ? "-"
//                                           : data.LastGautra.toUpperCase()),
//                                   style: new TextStyle(
//                                     fontSize: 15,
//                                   ),
//                                 ),
//                                 subtitle: new Text(
//                                     (data.Mobile1 == null || data.Mobile1 == "")
//                                         ? "-"
//                                         : data.Mobile1),
//                                 trailing: new Text((data.Relation == null ||
//                                         data.Relation == "")
//                                     ? "-"
//                                     : data.Relation),
//                               ),
//                             ),
//                             Divider(
//                               thickness: 2,
//                               indent: 10,
//                               endIndent: 10,
//                             ),
//                           ],
//                         ),
//                       ),
//                     )
//                     .toList(),
//               );
//             },
//           ),
//         ),
//       );
//     }
//   }
// }
