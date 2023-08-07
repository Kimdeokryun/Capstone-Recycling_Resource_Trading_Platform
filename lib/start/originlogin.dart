import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'signup1.dart';
import 'dart:async';
import 'dart:io';

class login extends StatefulWidget {
  @override
  _login createState() => _login();
}

class _login extends State<login> {
  bool isEmpty1 = false;
  bool isEmpty2 = false;
  bool pwv = false;
  late ScrollController _scrollController;
  late StreamSubscription<bool> keyboardSubscription;
  late Size size1;

  FocusNode idfield = FocusNode();
  FocusNode pwfield = FocusNode();

  void nextpage(String where) {
    if (where == "signup") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => signup1()),
      );
    }
  }

  void onTapFunc(size) async {
    size1 = size;
    _scrollController.animateTo(size.height * 0.2,
        duration: const Duration(microseconds: 500), curve: Curves.linear);
  }

  void close() {
    _scrollController.animateTo(-size1.height * 0.2,
        duration: const Duration(microseconds: 500), curve: Curves.linear);
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      if (!visible) {
        close();
      }
    });
  }

  @override
  void dispose() {
    idfield.dispose();
    pwfield.dispose();
    _scrollController.dispose();
    keyboardSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
            ),
            body: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.vertical,
                physics: const NeverScrollableScrollPhysics (),
              child: WillPopScope(
                onWillPop: () async {
                  exit(0);
                },
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: size.width,
                    minHeight: size.height,
                  ),
                  child: Container(
                    color: Colors.white,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: size.width * 0.8,
                            height: size.height * 0.15,
                            child: const Text("지구를 보다\n깨끗하게 만들어 주세요.",
                                style: TextStyle(
                                    color: Colors.black, fontFamily: "NSB"),
                                textScaleFactor: 1.5),
                          ),
                          Container(
                            margin: EdgeInsets.all(size.height * 0.01),
                            width: size.width * 0.8,
                            height: size.height * 0.3,
                            child: Column(children: <Widget>[
                              Container(
                                  child: Row(
                                children: [
                                  Container(
                                    child: const Text("먼저 로그인이 필요해요 :)",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: "NSM"),
                                        textScaleFactor: 1),
                                  )
                                ],
                              )),
                              Container(
                                child: Center(
                                  child: TextField(
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    focusNode: idfield,
                                    onTap: () {
                                      setState(() {
                                        onTapFunc(size);
                                      });
                                    },
                                    onChanged: (value) {
                                      print(value.length);
                                      setState(() {
                                        isEmpty1 =
                                            value.length != 0 ? true : false;
                                      });
                                    },
                                    decoration: const InputDecoration(
                                        labelText: "휴대폰번호 or 이메일",
                                        hintText: "(-을 제외하고 입력해주세요.)"),
                                  ),
                                ),
                              ),
                              Container(
                                child: Center(
                                  child: TextField(
                                    keyboardType: TextInputType.visiblePassword,
                                    focusNode: pwfield,
                                    onTap: () {
                                      setState(() {
                                        onTapFunc(size);
                                      });
                                    },
                                    onChanged: (value) {
                                      print(value);
                                      setState(() {
                                        isEmpty2 =
                                            value.length != 0 ? true : false;
                                      });
                                    },
                                    obscureText: !pwv,
                                    decoration: InputDecoration(
                                      labelText: "비밀번호",
                                      suffixIcon: pwv
                                          ? IconButton(
                                          onPressed: () {
                                            setState(() {
                                              pwv = !pwv;
                                            });
                                          },
                                          icon: const Icon(Icons
                                              .visibility_outlined),
                                          color: Colors.black)
                                          : IconButton(
                                          onPressed: () {
                                            setState(() {
                                              pwv = !pwv;
                                            });
                                          },
                                          icon: const Icon(Icons
                                              .visibility_off_outlined),
                                          color:
                                          Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                  child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                //crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    child: TextButton(
                                      onPressed: () {},
                                      child: const Text("비밀번호 찾기",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: "NSM"),
                                          textScaleFactor: 1),
                                    ),
                                  )
                                ],
                              )),
                            ]),
                          ),
                          Container(
                            margin: EdgeInsets.all(size.height * 0.01),
                            width: size.width * 0.7,
                            height: size.height * 0.05,
                            child: ElevatedButton(
                              onPressed:
                                  isEmpty1 && isEmpty2 ? () async {} : null,
                              style: ElevatedButton.styleFrom(
                                primary: Colors.lightBlue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                              child: Text(
                                '로그인',
                                style: TextStyle(
                                    color: isEmpty1 && isEmpty2 ? Colors.black : null, fontFamily: 'NSB'),
                                textScaleFactor: 1,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(size.height * 0.01),
                            width: size.width * 0.7,
                            height: size.height * 0.05,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5)),
                            child: ElevatedButton(
                              onPressed: () {
                                nextpage("signup");
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.lightBlue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                              child: const Text(
                                '회원가입',
                                style: TextStyle(
                                    color: Colors.black, fontFamily: 'NSB'),
                                textScaleFactor: 1,
                              ),
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.all(size.height * 0.01),
                              width: size.width * 0.7,
                              height: 1,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black12),
                              )),
                          Container(
                            margin: EdgeInsets.all(size.height * 0.01),
                            width: size.width * 0.7,
                            height: size.height * 0.05,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black12),
                                borderRadius: BorderRadius.circular(10)),
                            child: ElevatedButton.icon(
                              icon: Image.asset(
                                'assets/logo/google.png',
                                width: 25,
                                height: 25,
                              ),
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              label: const Text(
                                'Google로 시작',
                                style: TextStyle(
                                    color: Colors.black, fontFamily: 'NSB'),
                                textScaleFactor: 1,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(size.height * 0.01),
                            width: size.width * 0.7,
                            height: size.height * 0.05,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(10)),
                            child: ElevatedButton.icon(
                              icon: const Icon(
                                Icons.apple_rounded,
                                color: Colors.white,
                              ),
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                primary: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              label: const Text('  Apple로 시작',
                                  style: TextStyle(
                                      color: Colors.white, fontFamily: 'NSB'),
                                  textScaleFactor: 1),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(size.height * 0.01),
                            width: size.width * 0.7,
                            height: size.height * 0.05,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.yellow),
                                borderRadius: BorderRadius.circular(10)),
                            child: ElevatedButton.icon(
                              icon: Image.asset(
                                'assets/logo/kakao.png',
                                width: 25,
                                height: 25,
                              ),
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                primary: Colors.yellow,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              label: const Text(
                                ' Kakao로 시작',
                                style: TextStyle(
                                    color: Colors.black, fontFamily: 'NSB'),
                                textScaleFactor: 1,
                              ),
                            ),
                          ),
                        ]),
                  ),
                ),
              )),
        ));
  }
}
