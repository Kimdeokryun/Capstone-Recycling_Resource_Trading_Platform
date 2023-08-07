import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:ui';

import '../customlibrary/textanimation.dart';
import 'ReadytoBody.dart';

class breakdownUI extends StatefulWidget {
  @override
  _breakdownUI createState() => _breakdownUI();
}

class _breakdownUI extends State<breakdownUI> {
  late Size size;
  bool isloading = true;

  void move(where){
  }

  void getdata() async {
    setState(() {
      isloading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getdata();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery
        .of(context)
        .size;
    const SystemUiOverlayStyle overlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // 투명색
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(overlayStyle);
    });
    return isloading ?  Center(child: BouncingTextAnimation()) : mainbody();
  }

  Widget mainbody() {
    return readytobody();
  }
}
