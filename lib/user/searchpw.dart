import 'package:multi_masked_formatter/multi_masked_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sprintf/sprintf.dart';
import '../server/http_post.dart';
import 'package:get/get.dart';
import 'changepw.dart';
import '../start/welcome.dart';
import 'dart:async';

enum Type { phone, email }

class searchpw extends StatefulWidget {
  @override
  _searchpw createState() => _searchpw();
}

class _searchpw extends State<searchpw> {
  Type _type = Type.phone;
  late Timer _timer;
  late Size size;

  int _currentTick = 180;
  final _seconds = 1;

  bool isFull = false;
  bool _visible = false;
  bool isEmpty2 = false;
  bool complete = false;
  final _text = TextEditingController();
  final _code = TextEditingController();


  FocusNode myFocusNode = FocusNode();
  FocusNode emailfield = FocusNode();

  String email = "";
  bool isEmail = false;
  String subtitle = "가입한 휴대폰 번호를\n입력해주세요";
  int selnum = 0;
  String user_in = "";

  String authcode = "";

  void send_sms() async {
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
      String phnum = _text.text.replaceAll("-", "");
      authcode = await post_sms(phnum);
    }
  }


  void nextpage() async {
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
      user_in = await post_searchpw(selnum, _text.text);
      if(user_in == "false"){
        print("가입한 정보가 없습니다.");
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content:  Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: Text("가입된 정보가 없습니다.\n먼저 회원가입을 해주세요.", style: TextStyle(fontFamily: "HanM")))
                ],
              ),
              actions: [
                Center(
                  child: TextButton(
                    child: Text("확인", style: TextStyle(fontFamily: "NSB", color: Color(0xff47ABFF))),
                    onPressed: (){
                      Navigator.pop(context);
                      Get.offAll(() => Welcome());
                    },
                  ),
                )
              ],
            );
          },
        );
      }
      else{
        Get.to(() => changepw(), arguments: {'selnum': selnum, 'data': _text.text} );
      }
    }
  }

  auth_message() {
    return showDialog(
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


  void _start(int sec) {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _currentTick -= _seconds;
        if (_currentTick == 0) {
          _timer.cancel();
        }
      });
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

  void timer() {
    _currentTick = 180;
    _start(180);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    _text.dispose();
    _code.dispose();
    myFocusNode.dispose();
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
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            title: const Text(
              textAlign: TextAlign.center,
              "비밀번호 변경",
              style: TextStyle(color: Colors.black, fontFamily: 'NSB'),
              textScaleFactor: 1,
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: const IconThemeData(
              color: Colors.black, //change your color here
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(size.height * 0.1),
              child: Container(
                  margin: EdgeInsets.all(size.height * 0.01),
                  width: size.width * 0.8,
                  height: size.height * 0.1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _visible == false ? subtitle : "인증번호를\n입력해주세요",
                        style: const TextStyle(
                            color: Colors.black, fontFamily: "NSB"),
                        textScaleFactor: 1.8,
                      ),
                    ],
                  )),
            )),
        body: SafeArea(
            child: Container(
                color: Colors.white,
                width: double.infinity,
                child: Column(children: <Widget>[
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            sel_type(),
                            selnum == 0 ? input_phonenum() : input_email(),
                            input_authnum(),
                          ]),
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                        padding: EdgeInsets.only(
                            bottom:
                            MediaQuery.of(context).viewInsets.bottom) +
                            EdgeInsets.only(
                                top: size.height * 0.01,
                                bottom: size.height * 0.01),
                        child: SizedBox(
                            width: size.width * 0.9,
                            height: size.height * 0.08,
                            child: next_button())),
                  ),
                ]))),
      ),
    );
  }

  Widget sel_type() {
    return Visibility(
        visible: !_visible,
        child: Container(
            margin: EdgeInsets.all(size.height * 0.01),
            width: size.width * 0.8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Radio(
                        value: Type.phone,
                        groupValue: _type,
                        onChanged: (value) {
                          setState(() {
                            _type = value!;
                            subtitle = "가입한 휴대폰 번호를\n입력해주세요";
                            selnum = 0;
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
                            subtitle = "가입한 이메일을\n입력해주세요";
                            selnum = 1;
                          });
                        }),
                    Text(
                        '이메일'
                    ),
                  ],
                )
              ],
            )));
  }

  Widget input_phonenum() {
    return Container(
      margin: EdgeInsets.all(size.height * 0.01),
      width: size.width * 0.9,
      child: TextField(
        controller: _text,
        autofocus: true,
        enabled: !_visible,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.number,
        inputFormatters: [
          MultiMaskedTextInputFormatter(
              masks: ['xxx-xxxx-xxxx', 'xxx-xxx-xxxx'], separator: '-')
        ],
        onChanged: (value) {
          setState(() {
            isFull = value.length >= 13 ? true : false;
          });
        },
        decoration: const InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          labelText: "휴대폰 번호",
          hintText: "010-1234-5678",
        ),
      ),
    );
  }

  Widget input_email(){
    return Container(
      margin: EdgeInsets.all(size.height * 0.01),
      width: size.width * 0.9,
      child: TextFormField(
        autofocus: true,
        controller: _text,
        focusNode: emailfield,
        enabled: !_visible,
        autovalidateMode:
        AutovalidateMode.always,
        textInputAction:
        TextInputAction.next,
        keyboardType: TextInputType
            .emailAddress,
        onChanged: (value) async {
          setState(() {
            email = value;
          });
          check_email();
        },
        decoration:
        const InputDecoration(
          border: OutlineInputBorder(
              borderRadius:
              BorderRadius.all(
                  Radius
                      .circular(
                      10))),
          counterText: "",
          labelText: "이메일",
          hintText:
          "example@example.com",
        ),
      ),
    );
  }

  Widget input_authnum() {
    return Visibility(
        visible: _visible,
        child: Container(
          margin: EdgeInsets.all(size.height * 0.01),
          width: size.width * 0.9,
          child: TextField(
            controller: _code,
            enabled: !complete,
            maxLength: 6,
            focusNode: myFocusNode,
            keyboardType: TextInputType.number,
            onChanged: (value) async {
              setState(() {
                isFull = value.length == 6 ? true : false;
              });
            },
            decoration: InputDecoration(
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                labelText: "인증번호",
                counterText: "",
                suffix: Container(
                    width: size.width * 0.4,
                    height: size.height * 0.03,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Visibility(
                            visible: _currentTick == 0 ? false : true,
                            child: Container(
                              child: Text(
                                "${_currentTick ~/ 60}:${sprintf('%02d', [
                                  _currentTick % 60
                                ])} ",
                                style: TextStyle(
                                    color: _currentTick < 60
                                        ? Colors.red
                                        : Colors.black),
                              ),
                            )),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: _currentTick == 0
                                      ? Colors.black12
                                      : Colors.white),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          onPressed: _currentTick == 0
                              ? () {
                            send_sms();
                            setState(() {
                              isFull = false;
                              _code.clear();
                              _timer.cancel();
                              timer();
                            });
                          }
                              : null,
                          child: Text(
                            "재전송",
                            style: TextStyle(
                                color: _currentTick == 0 ? Colors.black : null),
                            textScaleFactor: 0.8,
                          ),
                        ),
                      ],
                    ))),
          ),
        ));
  }

  Widget next_button() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Color(0xff47ABFF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      onPressed: isFull
          ? () async {
        if(_visible == false){
          send_sms();
        }
        setState(() {
          if (_visible == false) {
            _visible = true;
            isFull = false;
            timer();
            myFocusNode.requestFocus();
          } else {
            if(authcode == _code.text)
            {
              _currentTick = 0;
              _timer.cancel();
              complete = true;
              nextpage();
            }
            else{
              print("인증번호가 맞지 않습니다");
              auth_message();
            }
          }
        });
      }
          : null,
      child: Text(
        _visible == false ? '인증번호 요청하기' : '확인',
        style: const TextStyle(fontFamily: "NSB"),
        textScaleFactor: 1.2,
      ),
    );
  }
}
