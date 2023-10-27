import 'package:ecocycle/main/menupageUI.dart';
import 'package:ecocycle/main/shoppingbasketUI.dart';
import 'package:ecocycle/main/usagepageUI.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ecocycle/main/setting_global.dart';
import 'package:get/get.dart';
import 'dart:ui';

import '../collection/resource_transaction.dart';
import '../how/howpage.dart';
import '../mall/mainmallpage.dart';
import '../notice/noticepage.dart';
import 'breakdownUI.dart';
import 'mainpageUI.dart';
import 'menupage.dart';
import 'mypageUI.dart';

class mainpage extends StatefulWidget {
  @override
  _mainpage createState() => _mainpage();
}

class _mainpage extends State<mainpage> {
  late Size size;
  late final args;

  Future<void> getdata() async {
    args = await Get.arguments;
    class_setting.setting(args[0]);
  }

  void movepage() {
    Get.to(() =>menupage(),
        transition: Transition.leftToRight,
        duration: const Duration(milliseconds: 500));
  }

  @override
  void initState() {
    super.initState();
    getdata().then((_) {

    });
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

    return Scaffold(
      appBar: class_setting.getnum() == 1
          ? usagepageappbarUI()
          : class_setting.getnum() == 3
              ? mypageappbarUI()
              : class_setting.getnum() == 4
                  ? shoppingbasketappbarUI()
                  : null,
      body: _getPage(class_setting.getnum()),
      bottomNavigationBar: mybottomnav(),
    );
  }

  AppBar mypageappbarUI() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: const Text("내 정보",
          style: TextStyle(color: Colors.black, fontFamily: "HanM"),
          textScaleFactor: 1.1),
      centerTitle: true,
    );
  }

  AppBar usagepageappbarUI() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: const Text("거래 내역",
          style: TextStyle(color: Colors.black, fontFamily: "HanM"),
          textScaleFactor: 1.1),
      centerTitle: true,
    );
  }

  AppBar shoppingbasketappbarUI() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: const Text("장바구니",
          style: TextStyle(color: Colors.black, fontFamily: "HanM"),
          textScaleFactor: 1.1),
      centerTitle: true,
    );
  }

  Widget _getPage(int index) {
    if (index == 1) {
      return usagepageUI();
    } else if (index == 2) {
      return mainpageUI();
    } else if (index == 3) {
      return mypageUI();
    } else {
      return shoppingbasketUI();
    }
  }

  Widget mybottomnav() {
    return BottomNavigationBar(
      elevation: 5,
      currentIndex: class_setting.getnum(),
      onTap: (index) {
        if (index == 0) {
          movepage();
        } else {
          setState(() {
            class_setting.setting(index);
          });
        }
      },
      selectedItemColor: const Color(0xff47ABFF),
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.circle_grid_3x3_fill), label: '메뉴'),
        BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: '거래 내역'),
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '홈'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: '내 정보'),
        BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined), label: '장바구니'),
      ],
    );
  }
}
