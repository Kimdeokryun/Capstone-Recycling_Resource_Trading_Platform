import 'package:ecocycle/main/mainpage.dart';
import 'package:ecocycle/notice/noticepage.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../challenge/challengemainpage.dart';
import '../collection/resource_transaction.dart';
import 'package:get/get.dart';

import '../customlibrary/textanimation.dart';
import '../user/Trans_grade.dart';
import '../user/User_Storage.dart';
import 'dart:ui';

import 'ReadytoPage.dart';
import 'package:ecocycle/how/howpage.dart';
import 'package:ecocycle/mall/mainmallpage.dart';


class menupageUI extends StatefulWidget {
  @override
  _menupageUI createState() => _menupageUI();
}

class _menupageUI extends State<menupageUI>{
  late Size size;


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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

    return mainbody();
  }

  void route_move(key)
  {
    print(key);
    if(key == "0"){
      Get.to(() => noticepage(), arguments: ["공지사항"]);
    }
    else if (key == "1"){
      Get.offAll(()=>mainpage(), arguments: [1]);
    }
    else if (key == "2"){
      Get.offAll(()=>mainpage(), arguments: [3]);
    }
    else if (key == "3"){
      Get.offAll(()=>mainpage(), arguments: [4]);
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
      Get.to(() => challengemain(), arguments: ["재활용 챌린지"]);
    }
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
            CustomButton("7", Icons.outlined_flag_rounded, "챌린지"),
            CustomButton("4", Icons.attach_money, "자원 거래"),
            CustomButton("5", Icons.recycling, "배출 정보"),
            CustomButton("6", Icons.local_mall, "제품몰"),
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
}

