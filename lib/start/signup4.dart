import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../customlibrary/dialog.dart';
import '../customlibrary/textanimation.dart';
import 'package:image_picker/image_picker.dart';
import '../user/User.dart';
import '../server/http_post.dart';
import '../main/mainpage.dart';
import 'package:get/get.dart';
import 'dart:io';


class signup4 extends StatefulWidget {
  @override
  _signup4 createState() => _signup4();
}

class _signup4 extends State<signup4> {
  late ScrollController _scrollController;
  late TextEditingController _nickname;
  late bool servercondition;
  late Size size;
  late String imageFile;

  bool nextv = false;
  bool pickimage = false;
  String changedetail = "";

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().getImage(source: source);

    if (pickedFile != null) {
      setState(() {
        pickimage = true;
        imageFile = pickedFile.path;
      });
    } else {
      print('No image selected.');
    }
  }


  void enablebutton() {
    if (changedetail != "") {
      setState(() {
        nextv = true;
      });
    } else {
      setState(() {
        nextv = false;
      });
    }
  }

  Future<void> nextpage() async {
    bool connect = await check_connect();
    if (connect == false) {
      Connecterror().showErrorDialog(context);
    } else {
      setState(() {
        isloading = true;
      });
      // 백엔드와 통신 부분.
      user.nickname = _nickname.text;
      user.profile = imageFile;

      servercondition = await post_signup();
      if (servercondition == true) {
        setState(() {
          isloading = false;
        });
        Get.offAll(() => mainpage());
      } else {
        setState(() {
          isloading = false;
        });
        Othererror("오류", "회원가입 실패").showErrorDialog(context);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    isloading = false;
    imageFile = "assets/image/eco.png";
    _nickname = TextEditingController();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _nickname.dispose();
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
                          !nextv
                              ? "마지막입니다!\n원하는 닉네임을 입력해주세요."
                              : "회원가입 완료 버튼을\n눌러주세요.",
                          style:
                          TextStyle(color: Colors.black, fontFamily: "NSB"),
                          textScaleFactor: 1.8,
                        ),
                      ],
                    )),
              ),
            ),
            body: isloading
                ? Center(child: BouncingTextAnimation())
                : SafeArea(
                child: Container(
                    color: Colors.white,
                    width: double.infinity,
                    child: Column(children: <Widget>[
                      Expanded(
                          child: SingleChildScrollView(
                              controller: _scrollController,
                              child: Column(children: [
                                Container(
                                  margin:
                                  EdgeInsets.all(size.height * 0.01),
                                  width: size.width * 0.9,
                                  child: Column(
                                    children: [
                                      input_profile(),
                                      input_nickname(),
                                    ],
                                  ),
                                ),
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
                      )
                    ])))));
  }

  Widget input_profile() {
    return Container(
      padding: EdgeInsets.all(size.height*0.05),
        child: GestureDetector(
          onTap: () {
            setState(() async {
              await _pickImage(ImageSource.gallery);
            });
          },
          child: Container(
            width: size.width*0.3,
            height: size.width*0.3,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(100),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100), // 반지름의 절반을 사용하여 원 모양에 적용
              child: pickimage ? Image.file(File(imageFile), fit: BoxFit.contain) :
              Image.asset(imageFile, fit: BoxFit.contain),
            )
          ),
        ));
  }

  Widget input_nickname() {
    return Container(
      width: size.width * 0.9,
      margin: EdgeInsets.all(size.height * 0.01),
      child: Container(
        margin: EdgeInsets.all(size.height * 0.01),
        child: TextFormField(
          controller: _nickname,
          enabled: true,
          onChanged: (val) {
            setState(() {
              changedetail = val;
            });

            enablebutton();
          },
          decoration: const InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            labelText: "닉네임",
            hintText: "김에코"
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
      onPressed: nextv
          ? () {
        nextpage();
      }
          : null,
      child: const Text(
        '회원가입 완료',
        style: TextStyle(fontFamily: "NSB"),
        textScaleFactor: 1.2,
      ),
    );
  }
}
