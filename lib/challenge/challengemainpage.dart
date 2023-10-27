import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:ui';

import '/user/User_Storage.dart';
import '/customlibrary/textanimation.dart';
import '/challenge/challengeUI.dart';
import '/challenge/challengemypageUI.dart';
import 'Upload.dart';
import 'detailpage.dart';


settingpagenum challenge_page = settingpagenum();

class settingpagenum{
  int _settingnum = 0;

  void setting(int num){
    _settingnum = num;
  }

  int getnum(){
    return _settingnum;
  }
}

User_Info userinfo = User_Info();

class User_Info
{
  late String _username;
  late String _usernickname;
  late String _userphonenumber;
  late String _profileimage;

  User_Info(){}

  void init(username, usernickname, userphonenumber, profile)
  {
    _username=username;
    _usernickname=usernickname;
    _userphonenumber=userphonenumber;
    _profileimage=profile;
  }

  String getname()
  {
    return _username;
  }
  String getnickname()
  {
    return _usernickname;
  }
  String getphonenum()
  {
    return _userphonenumber;
  }
  String getprofile()
  {
    return _profileimage;
  }
}

void next_detail_page(datas)
{
  Get.to(()=>detailpage(), arguments: [datas], transition: Transition.zoom);
}

class challengemain extends StatefulWidget {
  @override
  _challengemain createState() => _challengemain();
}

class _challengemain extends State<challengemain> {

  late Size size;
  late Map<String, dynamic> _userdata;


  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  bool isloading = true;
  String appbarname =  "";

  Future<void> getdata() async {
    appbarname = await Get.arguments[0];
    _userdata = (await getUserData())!;
    print(_userdata);
    userinfo.init(_userdata["name"], _userdata["nickname"], _userdata["phonenumber"], _userdata["profile"]);
    challenge_page.setting(0);
  }

  @override
  void initState() {
    super.initState();

    getdata().then((value) {
      setState(() {
        isloading = false;
      });

    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery
        .of(context)
        .size;
    const SystemUiOverlayStyle overlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // 투명색
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(overlayStyle);
    });

    return Scaffold(
      appBar: challenge_page.getnum() == 0
          ? mainappbar() : mypageappbar(),
      body: challenge_page.getnum() == 0
          ? challengemainUI() : challengemyUI(),
      bottomNavigationBar: bottomnav(),
      floatingActionButton: actionbutton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
    );
  }

  AppBar mainappbar() {
    return AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black), // 이 부분이 뒤로 가기 버튼 아이콘을 변경하는 부분입니다.
          onPressed: () => Navigator.of(context).pop(),
        ),
        toolbarHeight: size.height*0.05,
    );
  }

  AppBar mypageappbar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black), // 이 부분이 뒤로 가기 버튼 아이콘을 변경하는 부분입니다.
        onPressed: () => Navigator.of(context).pop(),
      ),
      toolbarHeight: size.height*0.05,
      title: Text(userinfo.getnickname(), style: const TextStyle(fontFamily: "HanM", color: Colors.black),textScaleFactor: 0.9,),
      actions: [
        const Icon(Icons.menu, color: Colors.black,),
        Container(width: size.width*0.05,)
      ],
    );
  }

  Widget bottomnav() {
    return BottomAppBar(
      color: Colors.white,
      height: size.height*0.06,
      // this creates a notch in the center of the bottom bar
      shape: const CircularNotchedRectangle(),
      notchMargin: 2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              IconButton(
                icon: Icon(Icons.image_search, color: _selectedIndex == 0 ? Colors.black : Colors.black38),
                splashColor: Colors.transparent,
                color: Colors.black,
                onPressed: () {
                  _onItemTapped(0);
                  challenge_page.setting(0);
                },
              ),
            ],
          ),
          const SizedBox(
            width: 20,
          ),
          Column(
            children: [
              IconButton(
                icon: Icon(CupertinoIcons.person_circle, color: _selectedIndex == 1 ? Colors.black : Colors.black38),
                splashColor: Colors.transparent,
                onPressed: () {
                  _onItemTapped(1);
                  challenge_page.setting(1);
                },
              ),
            ],
          )
          ,
        ],
      ),
    );
  }
  Widget actionbutton() {
    return ElevatedButton(
      onPressed: () {
        pickImages();

      },
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100), // 버튼의 모서리 반경 설정
          ),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(const Color(0xff47ABFF)),
        elevation: MaterialStateProperty.all<double>(2), // 그림자 효과 설정
        minimumSize: MaterialStateProperty.all<Size>(Size(size.width*0.15, size.width*0.15)),
      ),

      child: const Icon(Icons.recycling, color: Colors.white,),
    );
  }

}
