import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'signup1.dart';
import 'login.dart';

class Welcome extends StatefulWidget {
  @override
  _Welcome createState() => _Welcome();
}

class _Welcome extends State<Welcome> with TickerProviderStateMixin {
  bool isEmpty1 = false;
  bool isEmpty2 = false;
  late ScrollController _scrollController;

  late AnimationController _controller;
  late Animation<double> _animation1;
  late Animation<double> _animation2;
  late Size size;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 500),
        vsync: this,
        value: 0,
        lowerBound: 0,
        upperBound: 1);
    _animation1 = CurvedAnimation(parent: _controller, curve: Curves.linear);
    _controller.forward();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
      value: 0,
    );
    _animation2 = CurvedAnimation(parent: _controller, curve: Curves.linear);
    _controller.forward();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void nextpage(String where) {
    // Navigator.push가 아니라 그냥 화면 전환으로 이어지게.
    if (where == "signup") {
      Get.to(() => signup1());
    } else {
      Get.to(() => login());
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: const IconThemeData(
              color: Colors.black, //change your color here
            ),
          ),
          body: SafeArea(
              child: Container(
                color: Colors.white,
                width: double.infinity,
                height: double.infinity,
                child: Column(children: <Widget>[
                  Container(
                    child: Container(
                      alignment: Alignment(-1.0, -1.0),
                      height: size.height * 0.2,
                      padding: EdgeInsets.only(
                          top: size.height * 0.05, left: size.height * 0.05),
                      child: FadeTransition(
                        opacity: _animation1,
                        child: RichText(
                          text: const TextSpan(children: [
                            TextSpan(
                                text: "eco",
                                style: TextStyle(
                                    color: Colors.black, fontFamily: 'NSB')),
                            TextSpan(
                              text: "cycle",
                              style: TextStyle(
                                  color: Color(0xff47ABFF), fontFamily: 'NSB'),
                            ),
                            TextSpan(
                                text: "은 새활용 자원\n선순환 거래 플랫폼입니다.",
                                style: TextStyle(
                                    color: Colors.black, fontFamily: 'NSB')),
                          ]),
                          textScaleFactor: 1.8,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Container(
                        padding: EdgeInsets.only(left: size.height * 0.05),
                        alignment: Alignment(-1.0, -1.0),
                        height: size.height * 0.2,
                        color: Colors.white,
                        child: SizeTransition(
                          sizeFactor: _animation2,
                          axis: Axis.horizontal,
                          axisAlignment: -1,
                          child: const Text("친환경 혁신으로\n지속 가능한 미래를 경험하세요.",
                              style: TextStyle(fontFamily: 'NSM'),
                              textScaleFactor: 1),
                        )),
                  ),
                  Container(
                    height: size.height * 0.25,
                  ),
                  Container(
                    child: Column(children: [
                      Container(
                        width: size.width * 0.7,
                        height: size.height * 0.07,
                        child: ElevatedButton(
                          onPressed: () async {
                            loginfunc();
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xff47ABFF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          child: const Text(
                            '참여하기',
                            style: TextStyle(
                                color: Colors.white, fontFamily: 'NSB'),
                            textScaleFactor: 1.2,
                          ),
                        ),
                      ),
                    ]),
                  ),
                  Expanded(
                      child: Container(
                      ))
                ]),
              )),
        ));
  }

  // login 방법 선택 dialog
  void loginfunc() {
    Get.bottomSheet(
        Container(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: size.width,
            height: size.height * 0.35,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40)),
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: size.height * 0.02),
                  child: Center(
                    child: Text(
                      "로그인 방법 선택",
                      style: TextStyle(color: Colors.black, fontFamily: "NSB"),
                      textScaleFactor: 1.2,
                    ),
                  ),
                ),
                // 로그인 방법 선택 부분과 거리를 두기 위함.
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.all(size.height * 0.01),
                        // 간편 로그인 창 부분
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            login_google(),
                            login_kakao(),
                          ],
                        ),
                      ),
                      // ecocycle 로그인 및 회원가입 창 부분
                      login_ecocycle(),
                      goto_signup(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        enterBottomSheetDuration: Duration(milliseconds: 500),
        exitBottomSheetDuration: Duration(milliseconds: 500),
        isDismissible: true,
        barrierColor: Colors.black54);
  }

  Widget login_google() {
    return Container(
      margin: EdgeInsets.all(size.width * 0.03),
      child: FloatingActionButton(
        splashColor: Colors.transparent,
        backgroundColor: Colors.white,
        onPressed: () {},
        child: Image.asset(
          'assets/logo/google.png',
          width: 30,
          height: 30,
        ),
      ),
    );
  }

  Widget login_kakao() {
    return Container(
      margin: EdgeInsets.all(size.width * 0.03),
      child: FloatingActionButton(
        splashColor: Colors.transparent,
        backgroundColor: Color(0xfffee500),
        onPressed: () {},
        child: Image.asset(
          'assets/logo/kakao.png',
          width: 30,
          height: 30,
        ),
      ),
    );
  }

  Widget login_ecocycle() {
    return Container(
      margin: EdgeInsets.all(size.height * 0.01),
      width: size.width * 0.8,
      height: size.height * 0.07,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black12, width: 2),
          borderRadius: BorderRadius.circular(30)),
      child: ElevatedButton(
          onPressed: () {
            Get.back();
            nextpage("login");
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
          child: RichText(
              text: const TextSpan(children: [
                TextSpan(
                    text: "eco",
                    style: TextStyle(color: Colors.black, fontFamily: 'NSB')),
                TextSpan(
                  text: "cycle",
                  style: TextStyle(color: Color(0xff47ABFF), fontFamily: 'NSB'),
                ),
                TextSpan(
                    text: "로 로그인 하기",
                    style: TextStyle(color: Colors.black, fontFamily: 'NSB')),
              ]),
              textScaleFactor: 1)),
    );
  }

  Widget goto_signup() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const DefaultTextStyle(
            style: TextStyle(fontFamily: "NSMR"),
            child: Center(
              child: Text(
                "계정이 없으신가요? ",
                style: TextStyle(color: Colors.black45),
                textScaleFactor: 1,
              ),
            ),
          ),
          TextButton(
              onPressed: () {
                Get.back();
                signupfunc();
              },
              child: const Text(
                "회원가입",
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'NSMR',
                    decoration: TextDecoration.underline),
                textScaleFactor: 1,
              )),
        ],
      ),
    );
  }

  void signupfunc() {
    Get.bottomSheet(
        Container(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: size.width,
            height: size.height * 0.35,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40)),
            ),
            child: Column(
              children: [
                signup_title(),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.all(size.height * 0.02),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            signup_google(),
                            signup_kakao(),
                          ],
                        ),
                      ),
                      signup_button(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        enterBottomSheetDuration: Duration(milliseconds: 500),
        exitBottomSheetDuration: Duration(milliseconds: 500),
        isDismissible: true,
        barrierColor: Colors.black54);
  }

  Widget signup_title() {
    return Container(
      margin:
      EdgeInsets.only(top: size.height * 0.02, bottom: size.height * 0.02),
      child: Center(
        child: Text(
          "회원가입 방법 선택",
          style: TextStyle(color: Colors.black, fontFamily: "NSB"),
          textScaleFactor: 1.2,
        ),
      ),
    );
  }

  Widget signup_google() {
    return Container(
      margin: EdgeInsets.all(size.width * 0.03),
      child: FloatingActionButton(
        splashColor: Colors.transparent,
        backgroundColor: Colors.white,
        onPressed: () {},
        child: Image.asset(
          'assets/logo/google.png',
          width: 30,
          height: 30,
        ),
      ),
    );
  }

  Widget signup_kakao() {
    return Container(
      margin: EdgeInsets.all(size.width * 0.03),
      child: FloatingActionButton(
        splashColor: Colors.transparent,
        backgroundColor: Color(0xfffee500),
        onPressed: () {},
        child: Image.asset(
          'assets/logo/kakao.png',
          width: 30,
          height: 30,
        ),
      ),
    );
  }

  Widget signup_button() {
    return Container(
      margin: EdgeInsets.only(top: size.height * 0.02),
      width: size.width * 0.8,
      height: size.height * 0.07,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black12, width: 2),
          borderRadius: BorderRadius.circular(30)),
      child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            nextpage("signup");
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
          child: RichText(
              text: const TextSpan(children: [
                TextSpan(
                    text: "eco",
                    style: TextStyle(color: Colors.black, fontFamily: 'NSB')),
                TextSpan(
                  text: "cycle",
                  style: TextStyle(color: Color(0xff47ABFF), fontFamily: 'NSB'),
                ),
                TextSpan(
                    text: "로 회원가입",
                    style: TextStyle(color: Colors.black, fontFamily: 'NSB')),
              ]),
              textScaleFactor: 1)),
    );
  }
}