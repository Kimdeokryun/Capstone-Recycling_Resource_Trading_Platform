import 'package:ecocycle/main/setting_global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:ui';
import '../start/ReadyScreen.dart';
import '../user/User_Storage.dart';
import 'dart:io';
class editmy extends StatefulWidget {
  @override
  _editmy createState() => _editmy();
}

class _editmy extends State<editmy> {
  late Size size;
  bool isloading = true;
  bool istab = false;

  late Map<String, dynamic> _userdata;
  late TextEditingController _textControllers;
  late String _usernick;

  late String imageFile;
  bool pickimage = false;

  void getdata() async {
    _usernick = Get.arguments;
    _userdata = (await getUserData())!;
    imageFile = _userdata['profile'];
    _textControllers = TextEditingController(text: _usernick);
    setState(() {
      isloading = false;
    });
  }

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

  Future<void> logout() async {
    await storage.delete(key: 'login');
    await storage.delete(key: 'token');
    await storage.delete(key: 'userdata');
    await storage.delete(key: 'address');

    await storage.delete(key: 'salepage');
    await storage.delete(key: 'buypage');
    await storage.delete(key: 'transnum');

    await storage.delete(key: 'MallLike');
    await storage.delete(key: 'addressnum');
    class_setting.setting(2);
    Get.offAll(()=>readypage());
  }

  @override
  void initState() {
    super.initState();
    getdata();
  }

  @override
  void dispose() {
    _textControllers.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return isloading
        ? Container(
            color: Colors.white,
          )
        : GestureDetector(
        onTap: () {
      FocusScope.of(context).unfocus();
      setState(() {
        istab = false;
      });
    },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: mainappbar(),
        body: mainbody(),
      ),
    );
  }

  AppBar mainappbar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: true,
      iconTheme: IconThemeData(color: Colors.black),
      actions: <Widget>[
        Padding(
            padding: EdgeInsets.only(right: size.width * 0.05),
            child: IconButton(
                onPressed: () {
                  //move("home");
                },
                icon: Text(
                  "저장",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: "NSM",
                      fontSize: size.width * 0.03),
                ),
                color: Colors.black)),
      ],
      title: Text("내 정보",
          style: TextStyle(color: Colors.black, fontFamily: "HanM"),
          textScaleFactor: 1.2),
      centerTitle: true,
    );
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
                child: Image.file(File(imageFile), fit: BoxFit.contain)
              )
          ),
        ));
  }

  Widget mainbody() {
    return Container(
      width: size.width,
      height: size.height,
      color: Colors.white,
      child: Column(
        children: [
          input_profile(),
          Container(
            width: size.width,
            height: size.height * 0.2,
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        color: Colors.black12, width: size.height * 0.002))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("닉네임",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: size.width * 0.03,
                            fontFamily: "HanM")),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Align(
                    alignment: Alignment.center,
                    child: TextFormField(
                      controller: _textControllers,
                      onEditingComplete: () {
                        FocusScope.of(context).unfocus();
                      },
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff47ABFF),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black38,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty || value == "") {
                          return '닉네임을 입력해주세요.';
                        }
                        return null;
                      },
                    )
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(),
                )
              ],
            ),
          ),
          Container(
            width: size.width,
            height: size.height * 0.1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.only(
                      left: size.width * 0.05, right: size.width * 0.05),
                  child: TextButton(
                      onPressed: () {
                        logout();
                      },
                      child: Text("로그아웃",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: size.width * 0.03,
                              fontFamily: "HanM"))),
                ),
                Container(
                  padding: EdgeInsets.only(
                      left: size.width * 0.05, right: size.width * 0.05),
                  child: TextButton(
                      onPressed: () {},
                      child: Text("회원탈퇴",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: size.width * 0.03,
                              fontFamily: "HanM"))),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
