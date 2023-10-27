import 'dart:convert';

import 'package:ecocycle/start/welcome.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../customlibrary/dialog.dart';
import '../state/Systembar.dart';
import '../user/User_Storage.dart';
import '../server/http_post.dart';
import '../main/mainpage.dart';
import 'package:get/get.dart';
import 'dart:io';

class readypage extends StatefulWidget {
  @override
  _readypage createState() => _readypage();
}

class _readypage extends State<readypage> {
  late dynamic userInfo; // storage에 있는 유저 정보를 저장
  late int next;

  late String Condition;

  Future<void> _getcondition() async {
    print("서버연결 시도");

    bool connect = await check_connect();
    if (connect == false) {
      Connecterror().showErrorDialog(context);
    }
    else {
      Condition = await getcondition(); //서버 연동 이후에 적용.'
      //Condition = "true";    // 임시 조치.
      if (Condition == "false") {
        Othererror("최신 버전 업데이트", "최신버전 앱으로 업데이트를 해주세요").showErrorDialog(context);
      }
      else if (Condition == "true"){
        await clearFolder();
        _asyncMethod();
      }
      else{
        Servererror().showErrorDialog(context);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    NavColorChange().white();
    StatusColorChange().transparent();
    _getcondition();
  }

  void _asyncMethod() async {
    // read 함수로 key값에 맞는 정보를 불러오고 데이터타입은 String 타입
    // 데이터가 없을때는 null을 반환
    print(storage);
    userInfo = await storage.read(key: 'login');
    // user의 정보가 있다면 로그인 후 들어가는 첫 페이지로 넘어가게 합니다.
    if (userInfo != null) {
      if(await post_login(1, jsonDecode(userInfo)["username"], jsonDecode(userInfo)["password"]))
      {
        print("토큰 갱신 완료");
        next = 1;
      }
      else
      {
        next = 0;
      }

    } else {
      print('로그인이 필요합니다');
      next = 2;
    }
    nextpage(next);
  }

  Future<void> clearFolder() async {
    Directory tempDir = await getTemporaryDirectory();
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
    await storage.delete(key: 'salepage');
    //await storage.delete(key: 'login');
    //await storage.delete(key: 'token');
    //await storage.delete(key: 'userdata');
    //await storage.delete(key: 'address');
    //await storage.delete(key: 'transnum');
  }

  void nextpage(int next) {
    if (next == 1) {
      Get.offAll(() => mainpage(),
          transition: Transition.native,
          duration: const Duration(milliseconds: 500), arguments: [2]);
    }
    else if (next == 2){
      Get.offAll(() => Welcome(),
          transition: Transition.native,
          duration: const Duration(milliseconds: 500));
    }
    else
    {
      Othererror("로그인 실패", "로그인이 실패하였습니다.").showErrorDialog(context);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: RichText(
          text: const TextSpan(children: [
            TextSpan(
                text: "eco",
                style: TextStyle(
                    color: Colors.black, fontFamily: 'HanB')),
            TextSpan(
              text: "cycle",
              style: TextStyle(
                  color: Color(0xff47ABFF), fontFamily: 'HanB'),
            ),
          ]),
          textScaleFactor: 2,
        ),
      ),
    );
  }
}
