import 'package:multi_masked_formatter/multi_masked_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sprintf/sprintf.dart';
import '../customlibrary/dialog.dart';
import '../server/http_post.dart';
import 'package:get/get.dart';
import 'dart:async';

import 'signup2.dart';
import '../user/User.dart';
import 'explainpage.dart';
import 'welcome.dart';
import 'login.dart';



class signup1 extends StatefulWidget {
  @override
  _signup1 createState() => _signup1();
}

class _signup1 extends State<signup1> {
  late Timer _timer;
  late Size size;

  int _currentTick = 180;
  final _seconds = 1;
  bool isFull = false;
  bool _visible = false;
  bool isEmpty2 = false;
  bool complete = false;
  final _phonenumber = TextEditingController();
  final _code = TextEditingController();

  FocusNode myFocusNode = FocusNode();

  String authcode = "";
  late bool user_in;

  void send_sms() async {
    bool connect = await check_connect();
    if(connect == false){
      Connecterror().showErrorDialog(context);
    }
    else{
      String phnum = _phonenumber.text.replaceAll("-", "");
      authcode = await post_sms(phnum);
      if(authcode == "error"){
        Othererror("서버 오류" ,"이용에 불편을 드려 죄송합니다.").showErrorDialog(context);
      }
    }
  }

  Future<void> nextpage() async {
    bool connect = await check_connect();
    if(connect == false){
      Connecterror().showErrorDialog(context);
    }
    else{
      user.phonenumber = _phonenumber.text;
      user_in = await check_signup("0" ,user.phonenumber);
      if(user_in == true){
        Inusererror().showErrorDialog(context);
      }
      else{
        Get.to(() => signup2());
      }
    }
  }

  auth_message() {
    return Incorrrecterror().showErrorDialog(context);
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

  void timer() {
    _currentTick = 180;
    _start(180);
  }

  @override
  void initState() {
    super.initState();
    user.init();
  }

  @override
  void dispose() {
    _timer.cancel();
    _phonenumber.dispose();
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
              "회원가입",
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
                        _visible == false ? "전화번호를\n입력해주세요" : "인증번호를\n입력해주세요",
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
                            input_phonenum(),
                            input_authnum(),
                          ]),
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                        padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom) +
                            EdgeInsets.only(top:size.height * 0.01, bottom: size.height * 0.01),
                        child: SizedBox(
                          width: size.width * 0.9,
                          height: size.height * 0.08,
                          child: next_button()
                        )),
                  ),
                ]))),
      ),
    );
  }

  Widget input_phonenum(){
    return Container(
      margin: EdgeInsets.all(size.height * 0.01),
      width: size.width * 0.9,
      child: TextField(
        controller: _phonenumber,
        autofocus: true,
        enabled: !_visible,
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.number,
        inputFormatters: [
          MultiMaskedTextInputFormatter(
              masks: ['xxx-xxxx-xxxx', 'xxx-xxx-xxxx'],
              separator: '-')
        ],
        onChanged: (value) {
          setState(() {
            isFull = value.length >= 13 ? true : false;
          });
        },
        decoration: const InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(10))),
          labelText: "휴대폰번호",
          hintText: "010-1234-5678",
        ),
      ),
    );
  }


  Widget input_authnum(){
    return Visibility(
        visible: _visible,
        child: Container(
          margin: EdgeInsets.all(size.height * 0.01),
          width: size.width * 0.9,
          child: TextField(
            enabled: !complete,
            maxLength: 6,
            focusNode: myFocusNode,
            controller: _code,
            keyboardType: TextInputType.number,
            onChanged: (value) async {
              setState(() {
                isFull =
                value.length == 6 ? true : false;
              });
            },
            decoration: InputDecoration(
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                        Radius.circular(10))),
                labelText: "인증번호",
                counterText: "",
                suffix: Container(
                    width: size.width * 0.4,
                    height: size.height * 0.03,
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.end,
                      children: [
                        Visibility(
                            visible: _currentTick == 0
                                ? false
                                : true,
                            child: Container(
                              child: Text(
                                "${_currentTick ~/ 60}:${sprintf('%02d', [
                                  _currentTick % 60
                                ])} ",
                                style: TextStyle(
                                    color:
                                    _currentTick <
                                        60
                                        ? Colors.red
                                        : Colors
                                        .black),
                              ),
                            )),
                        ElevatedButton(
                          style:
                          ElevatedButton.styleFrom(
                            backgroundColor:
                            Colors.white,
                            shape:
                            RoundedRectangleBorder(
                              side: BorderSide(
                                  color: _currentTick ==
                                      0
                                      ? Colors.black12
                                      : Colors.white),
                              borderRadius:
                              BorderRadius.circular(
                                  30.0),
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
                                color: _currentTick == 0
                                    ? Colors.black
                                    : null),
                            textScaleFactor: 0.8,
                          ),
                        ),
                      ],
                    ))),
          ),
        ));

  }

  Widget next_button(){
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
