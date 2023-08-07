import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'signup3.dart';
import '../user/User.dart';
import 'package:get/get.dart';

class signup2 extends StatefulWidget {
  @override
  _signup2 createState() => _signup2();
}

class _signup2 extends State<signup2> {
  int setnum = 0;
  int selnum = 0;

  String name = "";
  String email = "";
  String password = "";
  String password2 = "";
  bool isFull1 = false,
      isFull2 = true,
      isFull3 = true;
  bool isEmail = false;
  bool isPassword = false;
  bool isPassword2 = false;
  bool isPw1 = false;
  bool isPw2 = false;
  bool pw1v = false;
  bool pw2v = false;

  FocusNode namefield = FocusNode();
  FocusNode birthdayfield = FocusNode();
  FocusNode emailfield = FocusNode();
  FocusNode pwfield = FocusNode();
  FocusNode pwckfield = FocusNode();

  late ScrollController _scrollController;
  late TextEditingController _name;
  late TextEditingController _birthday;
  late TextEditingController _email;
  late TextEditingController _password;
  late Size size;

  void nextpage() {
    user.init2();
    user.name = _name.text;
    user.birthday = _birthday.text;
    user.email = _email.text;
    user.password = _password.text;
    Get.to(() => signup3());
  }

  void onTapFunc(double val) async {
    _scrollController.jumpTo(val);
  }

  void check_email() {
    if (email == null || email.isEmpty) {
      setState(() {
        isEmail = false;
        isFull2 = false;
      });
    }
    if (!RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email)) {
      setState(() {
        isEmail = false;
        isFull2 = false;
      });
    } else {
      setState(() {
        isEmail = true;
        isFull2 = true;
      });
    }
  }

  void check_password() {
    if (password == null || password.isEmpty) {
      setState(() {
        isPassword = false;
        isFull3 = false;
      });
    }
    if (!RegExp(
        r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$')
        .hasMatch(password)) {
      setState(() {
        isPassword = false;
        isFull3 = false;
      });
    } else {
      setState(() {
        isPassword = true;
      });
    }
  }

  void check_repw() {
    if (password2 == null || password2.isEmpty || password2 != password) {
      isPassword2 = false;
      isFull3 = false;
    } else if (password2 == password) {
      isPassword2 = true;
      isFull3 = true;
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _name = TextEditingController();
    _birthday = TextEditingController();
    _email = TextEditingController();
    _password = TextEditingController();
  }

  @override
  void dispose() {
    _name.dispose();
    _birthday.dispose();
    _email.dispose();
    _password.dispose();
    _scrollController.dispose();

    namefield.dispose();
    birthdayfield.dispose();
    emailfield.dispose();
    pwfield.dispose();
    pwckfield.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery
        .of(context)
        .size;
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
                    width: size.width * 0.8,
                    height: size.height * 0.1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selnum == 0
                              ? "이름과 생년월일을\n입력해주세요"
                              : selnum == 1
                              ? "이메일 주소를\n입력해주세요"
                              : selnum == 2
                              ? "비밀번호를\n입력해주세요"
                              : "비밀번호를\n한번 더 입력해주세요",
                          style: const TextStyle(
                              color: Colors.black, fontFamily: "NSB"),
                          textScaleFactor: 1.8,
                        ),
                      ],
                    )),
              ),
            ),
            body: SafeArea(
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
                                    Container(
                                        margin:
                                        EdgeInsets.all(size.height * 0.01),
                                        width: size.width * 0.9,
                                        child: Column(
                                          children: [
                                            input_name(),
                                            input_birth(),
                                            input_email(),
                                            input_pw(),
                                            input_checkpw(),
                                          ],
                                        )),
                                  ]))),
                      SafeArea(
                        child: Padding(
                            padding: EdgeInsets.only(
                                bottom: MediaQuery
                                    .of(context)
                                    .viewInsets
                                    .bottom) +
                                EdgeInsets.only(
                                    top: size.height * 0.01,
                                    bottom: size.height * 0.01),
                            child: SizedBox(
                                width: size.width * 0.9,
                                height: size.height * 0.08,
                                child: next_button()
                            )),
                      ),
                    ])))));
  }


  Widget input_name() {
    return Container(
      margin: EdgeInsets.all(
          size.height * 0.01),
      child: TextFormField(
        controller: _name,
        maxLength: 6,
        onTap: () {
          setState(() {
            selnum = 0;
          });
          onTapFunc(0);
        },
        autofocus: true,
        enabled: true,
        focusNode: namefield,
        autovalidateMode:
        AutovalidateMode.always,
        textInputAction:
        TextInputAction.next,
        keyboardType:
        TextInputType.name,
        validator: (val) {
          if (val == null ||
              val.isEmpty) {
            return "이름은 필수사항입니다";
          } else {
            return null;
          }
        },
        onChanged: (value) async {
          setState(() {
            name = value;
          });
        },
        decoration:
        const InputDecoration(
          border: OutlineInputBorder(
              borderRadius:
              BorderRadius.all(
                  Radius.circular(
                      10))),
          counterText: "",
          labelText: "이름",
          hintText: "홍길동",
        ),
      ),
    );
  }

  Widget input_birth() {
    return Container(
      margin: EdgeInsets.all(
          size.height * 0.01),
      child: TextFormField(
        controller: _birthday,
        maxLength: 8,
        onTap: () {
          setState(() {
            selnum = 0;
          });
          onTapFunc(0);
        },
        autofocus: true,
        enabled: true,
        focusNode: birthdayfield,
        autovalidateMode:
        AutovalidateMode.always,
        textInputAction:
        TextInputAction.next,
        keyboardType:
        TextInputType.number,
        validator: (val) {
          if (val == null ||
              val.isEmpty) {
            return "생년월일을 알려주세요";
          } else {
            return null;
          }
        },
        onChanged: (value) async {
          setState(() {
            name = value;
            if (value.length == 8) {
              isFull1 = true;
            } else {
              isFull1 = false;
            }
          });
        },
        decoration:
        const InputDecoration(
          border: OutlineInputBorder(
              borderRadius:
              BorderRadius.all(
                  Radius.circular(
                      10))),
          counterText: "",
          labelText: "생년월일 8자리",
          hintText: "19990211",
        ),
      ),
    );
  }

  Widget input_email() {
    return Container(
        margin: EdgeInsets.all(
            size.height * 0.01),
        child: Visibility(
          visible: setnum >= 1,
          child: TextFormField(
            controller: _email,
            focusNode: emailfield,
            onTap: () {
              setState(() {
                selnum = 1;
              });
            },
            autovalidateMode:
            AutovalidateMode.always,
            textInputAction:
            TextInputAction.next,
            keyboardType: TextInputType
                .emailAddress,
            validator: (val) {
              if (val == null ||
                  val.isEmpty) {
                return "이메일은 필수사항입니다.";
              } else if (!isEmail) {
                return '잘못된 이메일 형식입니다.';
              } else {
                return null;
              }
            },
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
        ));
  }

  Widget input_pw() {
    return Container(
      margin: EdgeInsets.all(
          size.height * 0.01),
      child: Visibility(
        visible: setnum == 2,
        child: TextFormField(
          controller: _password,
          focusNode: pwfield,
          maxLength: 20,
          onTap: () {
            setState(() {
              selnum = 2;
            });
            onTapFunc(_scrollController
                .position
                .maxScrollExtent);
          },
          obscureText: !pw1v,
          autovalidateMode:
          AutovalidateMode.always,
          keyboardType: TextInputType
              .visiblePassword,
          textInputAction:
          TextInputAction.next,
          validator: (val) {
            if (!isPassword) {
              return '영어, 숫자, 특수문자 포함 8~20자';
            } else {
              return null;
            }
          },
          onChanged: (value) {
            setState(() {
              password = value;
            });
            check_password();
          },
          onFieldSubmitted: (v) {
            FocusScope.of(context)
                .requestFocus(
                pwckfield);
          },
          decoration: InputDecoration(
            border: const OutlineInputBorder(
                borderRadius:
                BorderRadius.all(
                    Radius.circular(
                        10))),
            labelText: "비밀번호",
            hintText: "비밀번호 입력",
            counterText: "",
            suffixIcon: pw1v
                ? IconButton(
                onPressed: () {
                  setState(() {
                    pw1v = !pw1v;
                  });
                },
                icon: const Icon(Icons
                    .visibility_outlined),
                color: Colors.black)
                : IconButton(
                onPressed: () {
                  setState(() {
                    pw1v = !pw1v;
                  });
                },
                icon: const Icon(Icons
                    .visibility_off_outlined),
                color:
                Colors.black),
          ),
        ),
      ),
    );
  }

  Widget input_checkpw() {
    return Container(
      margin: EdgeInsets.all(
          size.height * 0.01),
      child: Visibility(
        visible: setnum == 2,
        child: TextFormField(
          focusNode: pwckfield,
          maxLength: 20,
          onTap: () {
            setState(() {
              selnum = 3;
            });
            onTapFunc(_scrollController
                .position
                .maxScrollExtent);
          },
          obscureText: !pw2v,
          autovalidateMode:
          AutovalidateMode.always,
          keyboardType: TextInputType
              .visiblePassword,
          validator: (val) {
            if (!isPassword2) {
              return '비밀번호가 다릅니다';
            } else {
              return null;
            }
          },
          onChanged: (value) {
            setState(() {
              password2 = value;
            });
            check_repw();
          },
          decoration: InputDecoration(
            border: const OutlineInputBorder(
                borderRadius:
                BorderRadius.all(
                    Radius.circular(
                        10))),
            labelText: "비밀번호 확인",
            hintText: "비밀번호 확인",
            counterText: "",
            suffixIcon: pw2v
                ? IconButton(
                onPressed: () {
                  setState(() {
                    pw2v = !pw2v;
                  });
                },
                icon: const Icon(Icons
                    .visibility_outlined),
                color: Colors.black)
                : IconButton(
                onPressed: () {
                  setState(() {
                    pw2v = !pw2v;
                  });
                },
                icon: const Icon(Icons
                    .visibility_off_outlined),
                color:
                Colors.black),
          ),
        ),
      ),
    );
  }

  Widget next_button() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Color(0xff47ABFF),
        shape: RoundedRectangleBorder(


          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      onPressed: isFull1 && isFull2 && isFull3
          ? () {
        setState(() {
          if (setnum == 0) {
            setnum = 1;
            selnum = 1;
            isFull2 = false;
            onTapFunc(size.height);
            emailfield.requestFocus();
          } else if (setnum == 1) {
            setnum = 2;
            selnum = 2;
            isFull3 = false;
            onTapFunc(size.height);
            pwfield.requestFocus();
          } else {
            nextpage();
          }
        });
      }
          : null,
      child: Text(
        setnum < 2 ? '다음' : '확인',
        style: const TextStyle(fontFamily: "NSB"),
        textScaleFactor: 1.2,
      ),
    );
  }
}
