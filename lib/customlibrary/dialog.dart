import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

import '../start/explainpage.dart';
import '../start/login.dart';
import '../start/welcome.dart';

class Servererror extends GetxController {
  void showErrorDialog(BuildContext context){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
              child: Text("서버 오류", style: TextStyle(fontFamily: "HanB"))),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: Text(
                  "이용에 불편을 드려 죄송합니다.", style: TextStyle(fontFamily: "HanM"), textScaleFactor: 1,))
            ],
          ),
          actions: [
            Center(
              child: TextButton(
                child: Text("확인", style: TextStyle(
                    fontFamily: "NSB", color: Color(0xff47ABFF))),
                onPressed: () {
                  Navigator.pop(context);
                  exit(0);
                },
              ),
            )
          ],
        );
      },
    );
  }
}

class Connecterror extends GetxController {
  void showErrorDialog(BuildContext context){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
              child: Text("인터넷 연결", style: TextStyle(fontFamily: "HanB"))),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: Text(
                  "인터넷 연결을 확인 해주세요.", style: TextStyle(fontFamily: "HanM"), textScaleFactor: 1,))
            ],
          ),
          actions: [
            Center(
              child: TextButton(
                child: Text("확인", style: TextStyle(
                    fontFamily: "NSB", color: Color(0xff47ABFF))),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            )
          ],
        );
      },
    );
  }
}

class Othererror extends GetxController {
  String _title;
  String _content;
  Othererror(this._title, this._content);

  void showErrorDialog(BuildContext context){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
              child: Text(_title, style: TextStyle(fontFamily: "HanB"))),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: Text(
                  _content, style: TextStyle(fontFamily: "HanM"), textScaleFactor: 1,))
            ],
          ),
          actions: [
            Center(
              child: TextButton(
                child: Text("확인", style: TextStyle(
                    fontFamily: "NSB", color: Color(0xff47ABFF))),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            )
          ],
        );
      },
    );
  }
}

class Inusererror extends GetxController {
  void showErrorDialog(BuildContext context){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content:  Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: Text("이미 가입된 계정이 있습니다.", style: TextStyle(fontFamily: "HanM")))
            ],
          ),
          actions: [
            Center(
              child: TextButton(
                child: Text("로그인하기", style: TextStyle(fontFamily: "NSB", color: Color(0xff47ABFF))),
                onPressed: (){
                  Navigator.pop(context);
                  Get.offAll(()=> explain());
                  Get.to(() => Welcome());
                  Get.to(() => login());
                },
              ),
            )
          ],
        );
      },
    );
  }
}

class Incorrrecterror extends GetxController {
  void showErrorDialog(BuildContext context){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content:  Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: Text("인증번호가 틀립니다", style: TextStyle(fontFamily: "HanM")))
            ],
          ),
          actions: [
            Center(
              child: TextButton(
                child: Text("확인", style: TextStyle(fontFamily: "NSB", color: Color(0xff47ABFF))),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
            )
          ],
        );
      },
    );
  }
}