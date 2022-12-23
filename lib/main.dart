import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:promed/Screens/Home/home_screen.dart';
import 'package:promed/Screens/Video/video_screen.dart';
import 'package:promed/Screens/Welcome/welcome_screen.dart';
import 'package:promed/constants.dart';
import 'package:flutter/services.dart';
import 'package:promed/model/pushnotification_model.dart';
import 'package:provider/provider.dart';
import 'Screens/TransferFromLibrary/components/body.dart';


Future <void> main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(
      MultiProvider(providers: [
        ChangeNotifierProvider(create: ( context )=> Libraries (),
        ),
      ],
      child: MyApp(),
      )

  );
}
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final FirebaseMessaging _messaging;

  PushNotification?_notificationInfo ;

  void registerNotification() async {
    await Firebase.initializeApp();

    _messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false ,
      sound: true ,
    );

    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      print("User granted the permission");

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        PushNotification notification = PushNotification(
          title: message.notification!.title,
          body: message.notification!.body,
          dataBody: message.data['body'],
          dataTitle: message.data['title']
        );
        setState(() {
          _notificationInfo = notification;
        });

        if(notification != null ){
          showSimpleNotification(
              Text(_notificationInfo!.title!,style: TextStyle(color: Colors.white),),
              leading: Icon(Icons.notifications_active_outlined),
              subtitle: Text(_notificationInfo!.body!,style: TextStyle(color: Colors.white)),
              duration: Duration(seconds: 10),
              background: kPrimaryColor,
          );
        }
        if(notification != null && _notificationInfo!.title == "يوجد تحديث جديد للتطبيق" )
        storage.deleteAll();
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => WelcomeScreen(),
            ),
                (Route<dynamic> route) => false);
      });
    }
    else {
      print("permition declined by user");
    }

  }


  checkForInitialMessage() async{
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if(initialMessage != null){
      PushNotification notification = PushNotification(
          title: initialMessage.notification!.title,
          body: initialMessage.notification!.body,
          dataBody: initialMessage.data['body'],
          dataTitle: initialMessage.data['title']
      );
      setState(() {
        _notificationInfo = notification;
      });
    }
  }

  @override
  void initState(){
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      PushNotification notification = PushNotification(
          title: message.notification!.title,
          body: message.notification!.body,
          dataBody: message.data['body'],
          dataTitle: message.data['title']
      );
      setState(() {
        _notificationInfo = notification;
      });
    });

    registerNotification();
    checkForInitialMessage();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
        child :MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ProMed',
          theme: ThemeData(
            primaryColor: kPrimaryColor,
            scaffoldBackgroundColor: Colors.white,
          ),
          home: FutureBuilder(
            future: isLoggedIn(),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!) {
                  return HomeScreen();
                } else {
                  return WelcomeScreen();
                }
              }
              return Container(
                color: Colors.white,
                child: Center(
                  child: Image.asset('assets/images/Logo.jpg'),
                ),
              ); // noop, this builder is called again when the future completes
            },
          ),
        ));
  }

  Future<bool> isLoggedIn() async {
    return await storage.containsKey(key: 'access');
  }
}
