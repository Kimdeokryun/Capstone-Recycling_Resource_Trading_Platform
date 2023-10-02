import 'package:ecocycle/main/mainpage.dart';
import 'package:ecocycle/main/setting_global.dart';
import 'package:ecocycle/notice/noticepage.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../collection/resource_transaction.dart';
import 'package:get/get.dart';

import '../customlibrary/textanimation.dart';
import '../user/Trans_grade.dart';
import '../user/User_Storage.dart';
import 'dart:ui';

import 'ReadytoPage.dart';
import 'package:ecocycle/how/howpage.dart';
import 'package:ecocycle/mall/mainmallpage.dart';


class menupage extends StatefulWidget {
  @override
  _menupage createState() => _menupage();
}

class _menupage extends State<menupage>{
  late Size size;


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void route_move(key)
  {
    print(key);
    if(key == "0"){
      Get.to(() => noticepage(), arguments: ["공지사항"]);
    }
    else if (key == "1"){
      class_setting.setting(1);
      Get.offAll(()=>mainpage(), arguments: [1]);
      //Get.to(()=>mainpage(), arguments: [1]);
    }
    else if (key == "2"){
      class_setting.setting(3);
      Get.offAll(()=>mainpage(), arguments: [3]);
      //Get.to(()=>mainpage(), arguments: [3]);
    }
    else if (key == "3"){
      class_setting.setting(4);
      Get.offAll(()=>mainpage(), arguments: [4]);
      //Get.to(()=>mainpage(), arguments: [4]);
    }
    else if (key == "4"){
      Get.to(() => transactionpage());
    }
    else if (key == "5"){
      Get.to(() => howpage());
    }
    else if (key == "6"){
      Get.to(() => mainmallpage());
    }
    else if (key == "7"){
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    const SystemUiOverlayStyle overlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // 투명색
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(overlayStyle);
    });

    return Scaffold(
      appBar: menuappbarUI(),
      body: mainbody(),
      bottomNavigationBar: mybottomnav(),
    );
  }

  AppBar menuappbarUI() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Text("전체 서비스",
          style: TextStyle(color: Colors.black, fontFamily: "HanM"),
          textScaleFactor: 1.1),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          padding: EdgeInsets.all(size.width*0.04),
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {
            class_setting.setting(2);
            Get.offAll(()=>mainpage(), arguments: [2]);
          },
        ),
      ],
    );
  }

  Widget mainbody() {
    return SingleChildScrollView(
      child: Container(
        width: size.width,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: size.height*0.05),
            menu1(),
            Container(height: size.height*0.05),
            menu2(),
            description(),
            rights()
          ],
        ),
      ),
    );
  }

  Widget menu1() {
    return Container(
        width: size.width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomButton("0", Icons.volume_mute, "공지사항"),
            CustomButton("1", Icons.receipt_long, "거래 내역"),
            CustomButton("2", CupertinoIcons.person, "내 정보"),
            CustomButton("3", CupertinoIcons.shopping_cart, "장바구니")
          ],
        )
    );
  }
  Widget menu2() {
    return Container(
        width: size.width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomButton("4", Icons.attach_money, "자원 거래"),
            CustomButton("5", Icons.recycling, "배출 정보"),
            CustomButton("6", Icons.local_mall, "제품몰"),
            CustomButton("7", Icons.settings, "설정")
          ],
        )
    );
  }

  Widget CustomButton(key_val, icondata, title) {
    return Container(
        key: Key(key_val),
        width: size.width * 0.25,
        child: GestureDetector(
          onTap: (){
            route_move(key_val);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(size.width*0.02),
                child: Icon(icondata, color: Colors.black,),
              ),
              Container(
                padding: EdgeInsets.all(size.width*0.02),
                child: Text(title, style: const TextStyle(color: Colors.black26, fontFamily: "HanM"),textScaleFactor: 1.1,),
              )
            ],
          ),
        )
    );
  }

  Widget description() {
    return Container(
      margin: EdgeInsets.only(top: size.height*0.1),
      width: size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(height: 1, color: Colors.black12,),
          SizedBox(height: size.height*0.1,),
          const Text("친환경 혁신으로", style: TextStyle(color: Colors.black, fontFamily: "HanM"),textScaleFactor: 1.3),
          SizedBox(height: size.height*0.05,),
          const Text("지속 가능한 미래를 만들어요!", style: TextStyle(color: Colors.black, fontFamily: "HanM"),textScaleFactor: 1.3),
          SizedBox(height: size.height*0.1,),
          RichText(
              text: const TextSpan(children: [
                TextSpan(
                    text: "eco",
                    style: TextStyle(
                        color: Colors.black, fontFamily: 'HanM')),
                TextSpan(
                  text: "cycle",
                  style: TextStyle(
                      color: Color(0xff47ABFF),
                      fontFamily: 'HanM'),
                ),
              ]),
              textScaleFactor: 1.3),
        ],
      ),
    );
  }

  Widget rights() {
    return Container(
      width: size.width,
      height: size.height * 0.15,
      child: GestureDetector(
        onTap: () {},
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.only(bottom: size.height * 0.01),
            child: const Text("Copyright ecocycle, All Rights Reserved",
              style: TextStyle(
                  color: Colors.black38,
                  fontFamily: "HanR"),textScaleFactor: 0.8,),
          ),
        ),
      ),
    );
  }

  Widget mybottomnav() {
    return BottomNavigationBar(
      elevation: 5,
      currentIndex: 0,
      onTap: (index) {
        class_setting.setting(index);
        Get.offAll(()=>mainpage(), arguments: [index]);
      },
      selectedItemColor: const Color(0xff47ABFF),
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.circle_grid_3x3_fill), label: '메뉴'),
        BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long), label: '거래 내역'),
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '홈'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: '내 정보'),
        BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined), label: '장바구니'),
      ],
    );
  }

}

