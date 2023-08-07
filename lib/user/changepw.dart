import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../server/http_post.dart';
import 'package:get/get.dart';
import '../start/login.dart';

class changepw extends StatefulWidget {
  @override
  _changepw createState() => _changepw();
}

class _changepw extends State<changepw> {
  int setnum = 0;
  int selnum = 0;
  late Size size;

  bool isFull = false;
  bool _visible = false;
  bool isEmpty2 = false;
  bool complete = false;
  bool isFull3 = true;

  final _controller = TextEditingController();
  final _password = TextEditingController();

  FocusNode pwfield = FocusNode();
  FocusNode pwckfield = FocusNode();

  String password = "";
  String password2 = "";

  bool isPassword = false;
  bool isPassword2 = false;
  bool isPw1 = false;
  bool isPw2 = false;
  bool pw1v = false;
  bool pw2v = false;


  String passwd = "";
  String data = "";
  String beforepw = "";
  int type = 0;
  String cond = "";
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
      setState(() {
        isloading = true;
      });
      passwd = _password.text;
      data = Get.arguments['data'];
      type = Get.arguments['selnum'];

      print(type);
      print(data);
      print(passwd);

      cond = (await post_changepw(type, data, passwd)) as String;
      if (cond == "true"){   // 비밀번호 변경 성공
        setState(() {
          isloading = false;
        });
        Get.offAll(() => login());
      }
      else{ // 비밀번호 변경 실패 (사유: 기존과 비밀번호가 같음)
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
                  Expanded(child: Text("다른 비밀번호를 입력해주세요.", style: TextStyle(fontFamily: "HanM")),)
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
    isloading = false;
  }

  @override
  void dispose() {
    pwfield.dispose();
    pwckfield.dispose();
    _controller.dispose();
    _password.dispose();
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
                    children: const [
                      Text(
                        "새로운 비밀번호를\n입력해주세요",
                        style: TextStyle(
                            color: Colors.black, fontFamily: "NSB"),
                        textScaleFactor: 1.8,
                      ),
                    ],
                  )),
            )),
        body:
        isloading ? const Center(child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Color(0xff47ABFF),),
        )):SafeArea(
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
                            input_pw(),
                            input_checkpw(),
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

  Widget input_pw() {
    return Container(
      margin: EdgeInsets.all(
          size.height * 0.01),
      width: size.width * 0.9,
      child: TextFormField(
          controller: _password,
          focusNode: pwfield,
          maxLength: 20,
          onTap: () {
            setState(() {
              selnum = 2;
            });
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
    );
  }

  Widget input_checkpw() {
    return Container(
      margin: EdgeInsets.all(
          size.height * 0.01),
      width: size.width * 0.9,
        child: TextFormField(
          focusNode: pwckfield,
          maxLength: 20,
          onTap: () {
            setState(() {
              selnum = 3;
            });
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
    );
  }

  Widget next_button(){
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Color(0xff47ABFF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      onPressed: isPassword2
          ? () {
        nextpage();
      }
          : null,
      child: const Text(
        '비밀번호 변경하기',
        style: TextStyle(fontFamily: "NSB"),
        textScaleFactor: 1.2,
      ),
    );
  }

}
