import 'package:multi_masked_formatter/multi_masked_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../customlibrary/textanimation.dart';
import '../server/http_post.dart';
import '../main/mainpage.dart';
import '../user/searchpw.dart';
import 'package:get/get.dart';
import 'dart:async';

enum Type { phone, email }

class login extends StatefulWidget {
  @override
  _login createState() => _login();
}

class _login extends State<login> {
  Type _type = Type.phone;
  int selnum = 0;

  String idlabel = "휴대폰번호";
  String idhint = "010-1234-5678";

  String email = "";
  bool isFull = false;
  bool isEmail = false;

  bool isEmpty2 = false;
  bool pwv = false;

  final _id = TextEditingController();
  final _pw = TextEditingController();

  late ScrollController _scrollController;
  late Size size;

  late bool servercond;

  FocusNode idfield = FocusNode();
  FocusNode pwfield = FocusNode();

  Future<void> nextpage() async {
    bool connect = await check_connect();
    if(connect == false){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(child: Text("인터넷 연결", style: TextStyle(fontFamily: "HanB"))),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: Text("인터넷 연결을 확인 해주세요.", style: TextStyle(fontFamily: "HanM")))
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
    else{
      setState(() {
        isloading = true;
      });
      servercond = await post_login(selnum, _id.text, _pw.text);
      if(servercond == true){
        // 로그인 성공 메인 페이지로 이동 (이전 화면 전부다 pop)
        setState(() {
          isloading = false;
        });
        Get.offAll(() => mainpage());
      }
      else{ // 로그인 실패 (사유: 서버와의 통신이 좋지 않거나, id나 pw가 맞지 않음)
        setState(() {
          isloading = false;
        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content:  Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: Text("입력한 정보가 맞지 않습니다.", style: TextStyle(fontFamily: "HanM")))
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
  }

  void searchpwpage() {
    Get.to(() => searchpw());
  }

  void onTapFunc() {
    Future.delayed(Duration(milliseconds: 500), () {
      _scrollController.animateTo(MediaQuery.of(context).viewInsets.bottom,
          duration: const Duration(microseconds: 500), curve: Curves.easeIn);
    });
  }

  void check_email() {
    if (email == null || email.isEmpty) {
      setState(() {
        isEmail = false;
        isFull = false;
      });
    }
    if (!RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email)) {
      setState(() {
        isEmail = false;
        isFull = false;
      });
    } else {
      setState(() {
        isEmail = true;
        isFull = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    isloading = false;
  }

  @override
  void dispose() {
    idfield.dispose();
    pwfield.dispose();
    _id.dispose();
    _pw.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            textAlign: TextAlign.center,
            "로그인",
            style: TextStyle(color: Colors.black, fontFamily: 'NSB'),
            textScaleFactor: 1,
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
        ),
        body:
        isloading ? Center(child: BouncingTextAnimation()):
        SafeArea(
            child: Container(
                color: Colors.white,
                width: double.infinity,
                child: Column(children: <Widget>[
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      physics: NeverScrollableScrollPhysics(),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(height: size.height * 0.02),
                            logo(),
                            Container(height: size.height * 0.05),
                            sel_type(),
                            selnum == 0 ? login_id1() : login_id2(),
                            login_pw(),
                            login_searchpw(),
                            login_button()
                          ]),
                    ),
                  ),
                ]))),
      ),
    );
  }

  Widget logo(){
    return Container(
      margin: EdgeInsets.all(size.height * 0.01),
      child: Center(
        child: RichText(
            text: const TextSpan(children: [
              TextSpan(
                  text: "eco",
                  style: TextStyle(color: Colors.black, fontFamily: 'NSB')),
              TextSpan(
                text: "cycle",
                style: TextStyle(color: Color(0xff47ABFF), fontFamily: 'NSB'),
              )
            ]),
            textScaleFactor: 1.5),
      ),
    );
  }

  Widget sel_type() {
    return Container(
            margin: EdgeInsets.all(size.height * 0.01),
            width: size.width * 0.7,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Radio(
                        value: Type.phone,
                        groupValue: _type,
                        onChanged: (value) {
                          setState(() {
                            _type = value!;
                            selnum = 0;
                            idlabel = "휴대폰번호";
                            idhint = "010-1234-5678";
                          });
                        }),
                    Text(
                        '휴대폰'
                    ),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                        value: Type.email,
                        groupValue: _type,
                        onChanged: (value) {
                          setState(() {
                            _type = value!;
                            selnum = 1;
                            idlabel = "이메일";
                            idhint = "ecocycle@example.com";
                          });
                        }),
                    Text(
                        '이메일'
                    ),
                  ],
                )
              ],
            ));
  }

  Widget login_id1() {
    return Container(
      margin: EdgeInsets.all(size.height * 0.01),
      width: size.width * 0.7,
      child: Center(
        child: TextField(
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          focusNode: idfield,
          controller: _id,
          inputFormatters: [
            MultiMaskedTextInputFormatter(
                masks: ['xxx-xxxx-xxxx', 'xxx-xxx-xxxx'],
                separator: '-')
          ],
          onTap: () {
            setState(() {
              onTapFunc();

            });
          },
          onChanged: (value) {
            setState(() {
              isFull = value.length >= 13 ? true : false;
            });
          },
          decoration: InputDecoration(
              labelText: idlabel, hintText: idhint),
        ),
      ),
    );
  }

  Widget login_id2() {
    return Container(
      margin: EdgeInsets.all(size.height * 0.01),
      width: size.width * 0.7,
      child: Center(
        child: TextField(
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          focusNode: idfield,
          controller: _id,
          onTap: () {
            setState(() {
              onTapFunc();
            });
          },
          onChanged: (value) {
            setState(() {
              email = value;
            });
            check_email();
          },
          decoration: InputDecoration(
              labelText: idlabel, hintText: idhint),
        ),
      ),
    );
  }

  Widget login_pw() {
    return Container(
      margin: EdgeInsets.all(size.height * 0.01),
      width: size.width * 0.7,
      child: Center(
        child: TextField(
          keyboardType: TextInputType.visiblePassword,
          focusNode: pwfield,
          controller: _pw,
          maxLength: 20,
          onTap: () {
            setState(() {
              onTapFunc();
            });
          },
          onChanged: (value) {
            setState(() {
              isEmpty2 = value.length != 0 ? true : false;
            });
          },
          obscureText: !pwv,
          decoration: InputDecoration(
            labelText: "비밀번호",
            counterText: "",
            suffixIcon: pwv
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        pwv = !pwv;
                      });
                    },
                    icon: const Icon(Icons.visibility_outlined),
                    color: Colors.black)
                : IconButton(
                    onPressed: () {
                      setState(() {
                        pwv = !pwv;
                      });
                    },
                    icon: const Icon(Icons.visibility_off_outlined),
                    color: Colors.black),
          ),
        ),
      ),
    );
  }

  Widget login_searchpw() {
    return Container(
        margin: EdgeInsets.all(size.height * 0.01),
        width: size.width * 0.7,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          //crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              child: TextButton(
                onPressed: () {
                  searchpwpage();
                },
                child: const Text("비밀번호를 잊으셨나요?",
                    style: TextStyle(color: Colors.black, fontFamily: "NSM", decoration: TextDecoration.underline),

                    textScaleFactor: 1),
              ),
            )
          ],
        ));
  }

  Widget login_button() {
    return Container(
      margin: EdgeInsets.all(size.height * 0.01),
      width: size.width * 0.7,
      height: size.height * 0.06,
      child: ElevatedButton(
        onPressed: isFull && isEmpty2 ? () { nextpage(); } : null,
        style: ElevatedButton.styleFrom(
          primary: Color(0xff47ABFF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        child: Text(
          '로그인',
          style: TextStyle(
              color: isFull && isEmpty2 ? Colors.white : null,
              fontFamily: 'NSB'),
          textScaleFactor: 1,
        ),
      ),
    );
  }
}
