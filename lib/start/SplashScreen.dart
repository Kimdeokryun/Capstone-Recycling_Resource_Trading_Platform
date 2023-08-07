import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'ReadyScreen.dart';


/*
splash 이미지 변경 코드, icon 이미지 변경 코드
flutter pub run flutter_native_splash:remove
flutter pub run flutter_native_splash:create
flutter pub run flutter_launcher_icons:main
*/

class splashscreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<splashscreen> {
  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() {
    FlutterNativeSplash.remove();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top, SystemUiOverlay.bottom]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // 투명색
    ));
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: readypage(),
    );
  }
}
