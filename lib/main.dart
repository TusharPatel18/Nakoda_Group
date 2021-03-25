import 'dart:async';
import 'dart:io';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:nakoda_group/routes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_fonts/google_fonts.dart';
import 'data/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
  );
  HttpOverrides.global = new MyHttpOverrides();
  runApp(LoginApp());
}
 
class LoginApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return new MaterialApp(
      title: 'Nakoda Group',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        accentColor: Colors.red,
        primaryColor: Colors.red,
        textTheme:GoogleFonts.latoTextTheme(textTheme).copyWith(
          //body1: GoogleFonts.montserrat(textStyle: textTheme.body2),
          // ignore: deprecated_member_use
          subhead: GoogleFonts.firaSans(textStyle: textTheme.body2),
          // ignore: deprecated_member_use
          title: GoogleFonts.firaSans(textStyle: textTheme.body2),
          // ignore: deprecated_member_use
          body2: GoogleFonts.firaSans(textStyle: textTheme.body2),
          // ignore: deprecated_member_use
          body1: GoogleFonts.firaSans(textStyle: textTheme.body2),
        ),
      ),
      routes: routes,
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>  with SingleTickerProviderStateMixin,WidgetsBindingObserver{

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() async {
    var db = new DatabaseHelper();
    var isLoggedIn = await db.isLoggedIn();
    if(isLoggedIn)
      Navigator.of(context).pushNamedAndRemoveUntil('/sponserScreen', (Route<dynamic> route) => false);
    else
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
  }

  AnimationController controller;
  Animation<Offset> offset;

  @override
  void initState() {
    super.initState();
    startTime();
    WidgetsBinding.instance.addObserver(this);
    controller = AnimationController(vsync: this, duration: Duration(seconds: 1));
    offset = Tween<Offset>(begin: Offset.zero, end: Offset(0.0, 1.5)).animate(controller);
    controller.forward();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
//_navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
// _navigateToItemDetail(message);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true)
    );
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      // print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      setState(() {
        print("Push Messaging token: $token");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Center(
              child: SlideTransition(
                position: offset,
                child: Image.asset('images/logo.png',
                  width: 200,
                  height: 200,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}