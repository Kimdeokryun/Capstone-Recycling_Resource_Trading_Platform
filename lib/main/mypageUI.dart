import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:ui';
import '../customlibrary/textanimation.dart';
import '../user/User_Storage.dart';
import 'editmypage.dart';
import 'mainpage.dart';

class mypageUI extends StatefulWidget {
  @override
  _mypageUI createState() => _mypageUI();
}

class _mypageUI extends State<mypageUI> {
  late Size size;
  late ScrollController _scrollController;
  bool isloading = true;

  late Map<String, dynamic> _userdata;
  late Map<String, dynamic> _transdata;
  late String _usernick;
  late int _trannum;

  void move(where) {
    if(where == "editpage"){
      Get.to(()=>editmy(), arguments: _usernick, transition: Transition.rightToLeft,
          duration: Duration(milliseconds: 500));
    }
  }

  void getdata() async {
    _userdata = (await getUserData())!;
    _transdata = (await getTransData())!;
    _trannum = _transdata['sales'] + _transdata['buy'];
    _trannum = 13;
    _usernick = _userdata['nickname'];
    setState(() {
      isloading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    getdata();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    const SystemUiOverlayStyle overlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // 투명색
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(overlayStyle);
    });

    return isloading ? Center(child: BouncingTextAnimation()) : mainbody();
  }

  Widget mainbody() {
    return SafeArea(
        child: Container(
            color: Colors.white,
            width: double.infinity,
            child: Column(children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        mypage(),
                        mybreakdown(),
                        admob(),
                        mylike(),
                        mypurchase(),
                        coupons(),
                        notice(),
                        event(),
                        helpcenter(),
                        setting(),
                        provision(),
                        appversion(),
                        rights()
                      ]),
                ),
              ),
            ])));
  }

  Widget mypage() {
    return Container(
      width: size.width,
      height: size.height * 0.1,

      child: GestureDetector(
        onTap: () {
          move("editpage");
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.only(left: size.width * 0.1),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      textAlign: TextAlign.end,
                      text: TextSpan(children: [
                        TextSpan(
                            text: "환경운동가\n",
                            style: TextStyle(
                                color: Color(0xff47ABFF),
                                fontFamily: 'HanM',
                                fontSize: size.width * 0.05)),
                        TextSpan(
                          text: "$_usernick님",
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'HanM',
                              fontSize: size.width * 0.05),
                        ),
                      ]),
                    ),
                  ),
                )),
            Expanded(
              flex: 1,
              child: Icon(
                Icons.chevron_right,
                color: Color(0xff47ABFF),
                size: size.width * 0.13,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget mybreakdown() {
    return Container(
      width: size.width,
      height: size.height * 0.08,
      child: GestureDetector(
        onTap: () {},
        child: Center(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: [
              TextSpan(
                  text: "eco",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'HanM',
                      fontSize: size.width * 0.04)),
              TextSpan(
                text: "cycle",
                style: TextStyle(
                    color: Color(0xff47ABFF),
                    fontFamily: 'HanM',
                    fontSize: size.width * 0.04),
              ),
              TextSpan(
                text: "을 총 $_trannum번 참여해주셨어요!",
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'HanM',
                    fontSize: size.width * 0.04),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget admob() {
    return Container(
      width: size.width,
      height: size.height * 0.08,
      decoration: BoxDecoration(color: Colors.black12, border: Border(top: BorderSide(
          color: Colors.black12, width: size.height * 0.005),bottom: BorderSide(
          color: Colors.black12, width: size.height * 0.005))),
      child: Center(
        child: Text(
          "AD",
          style: TextStyle(
              color: Colors.black,
              fontSize: size.width * 0.04,
              fontFamily: "HanM"),
        ),
      ),
    );
  }

  Widget mylike() {
    return Container(
      width: size.width,
      height: size.height * 0.08,
      child: GestureDetector(
        onTap: () {},
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Icon(CupertinoIcons.heart),
            ),
            Expanded(
              flex: 2,
              child: Text("관심 목록",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: size.width * 0.03,
                      fontFamily: "HanM")),
            ),
            Expanded(
              flex: 1,
              child: Icon(
                Icons.chevron_right,
                color: Color(0xff47ABFF),
                size: size.width * 0.1,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget mypurchase() {
    return Container(
      width: size.width,
      height: size.height * 0.08,
      child: GestureDetector(
        onTap: () {},
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Icon(CupertinoIcons.bag),
            ),
            Expanded(
              flex: 2,
              child: Text("구매 목록",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: size.width * 0.03,
                      fontFamily: "HanM")),
            ),
            Expanded(
              flex: 1,
              child: Icon(
                Icons.chevron_right,
                color: Color(0xff47ABFF),
                size: size.width * 0.1,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget coupons() {
    return Container(
      width: size.width,
      height: size.height * 0.085,
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: Colors.black12, width: size.height * 0.005))),
      child: GestureDetector(
        onTap: () {},
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Icon(CupertinoIcons.ticket),
            ),
            Expanded(
              flex: 2,
              child: Text("쿠폰함",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: size.width * 0.03,
                      fontFamily: "HanM")),
            ),
            Expanded(
              flex: 1,
              child: Icon(
                Icons.chevron_right,
                color: Color(0xff47ABFF),
                size: size.width * 0.1,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget notice() {
    return Container(
      width: size.width,
      height: size.height * 0.08,
      child: GestureDetector(
        onTap: () {},
        child: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: EdgeInsets.only(left: size.width * 0.1),
            child: Text("공지사항",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: size.width * 0.03,
                    fontFamily: "HanM")),
          ),
        ),
      ),
    );
  }

  Widget event() {
    return Container(
      width: size.width,
      height: size.height * 0.08,
      child: GestureDetector(
        onTap: () {},
        child: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: EdgeInsets.only(left: size.width * 0.1),
            child: Text("이벤트",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: size.width * 0.03,
                    fontFamily: "HanM")),
          ),
        ),
      ),
    );
  }

  Widget helpcenter() {
    return Container(
      width: size.width,
      height: size.height * 0.08,
      child: GestureDetector(
        onTap: () {},
        child: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: EdgeInsets.only(left: size.width * 0.1),
            child: Text("고객센터",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: size.width * 0.03,
                    fontFamily: "HanM")),
          ),
        ),
      ),
    );
  }

  Widget setting() {
    return Container(
      width: size.width,
      height: size.height * 0.08,
      child: GestureDetector(
        onTap: () {},
        child: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: EdgeInsets.only(left: size.width * 0.1),
            child: Text("환경설정",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: size.width * 0.03,
                    fontFamily: "HanM")),
          ),
        ),
      ),
    );
  }

  Widget provision() {
    return Container(
      width: size.width,
      height: size.height * 0.08,
      child: GestureDetector(
        onTap: () {},
        child: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: EdgeInsets.only(left: size.width * 0.1),
            child: Text("약관 및 정책",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: size.width * 0.03,
                    fontFamily: "HanM")),
          ),
        ),
      ),
    );
  }

  Widget appversion() {
    return Container(
      width: size.width,
      height: size.height * 0.08,
      child: GestureDetector(
        onTap: () {},
        child: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: EdgeInsets.only(left: size.width * 0.1),
            child: Text("앱 버전 1.0.0",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: size.width * 0.03,
                    fontFamily: "HanM")),
          ),
        ),
      ),
    );
  }

  Widget rights() {
    return Container(
      width: size.width,
      height: size.height * 0.15,
      color: Colors.black12,
      child: GestureDetector(
        onTap: () {},
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.only(bottom: size.height * 0.01),
            child: Text("Copyright ecocycle, All Rights Reserved",
                style: TextStyle(
                    color: Colors.black38,
                    fontSize: size.width * 0.02,
                    fontFamily: "HanR")),
          ),
        ),
      ),
    );
  }
}
