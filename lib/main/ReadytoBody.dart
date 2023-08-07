import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:ui';

class readytobody extends StatefulWidget {
  @override
  _readytobody createState() => _readytobody();
}

class _readytobody extends State<readytobody> {
  late Size size;

  @override
  void initState() {
    super.initState();
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

    return mainbody();
  }

  Widget mainbody() {
    return Container(
      width: size.width,
      height: size.height,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(height: size.height*0.2,),
          Container(
            child: Image.asset('assets/image/ready_ecocycle.png'),
          ),
          Container(
            child: Text("서비스 준비중 입니다.", style: TextStyle(fontFamily: "HanM", fontSize: size.width*0.04),),
          ),
          Container(
            padding: EdgeInsets.only(top: size.height*0.05),
            child: Text("보다 나은 서비스를 위해 컨텐츠를 준비하고 있습니다.\n"
                "빠른 시일 내에 찾아뵙겠습니다.", style: TextStyle(fontFamily: "HanR", color: Colors.black38,fontSize: size.width*0.03),textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }
}
