import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:ui';

import 'breakdownUI.dart';
import 'mainpageUI.dart';
import 'mypageUI.dart';

class mainpage extends StatefulWidget {
  @override
  _mainpage createState() => _mainpage();
}

class _mainpage extends State<mainpage> {
  late Size size;
  int selectedindex = 2;

  void movepage(int index) {
    if (index == 1) {
      //Get.to(() => menu());
    } else {
      //Get.to(() => shopping_basket());
    }
  }

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

    return Scaffold(
      appBar: selectedindex == 1
          ? breakdownappbarUI()
          : selectedindex == 3
              ? mypageappbarUI()
              : null,
      body: _getPage(selectedindex),
      bottomNavigationBar: mybottomnav(),
    );
  }

  AppBar mypageappbarUI() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Text("내 정보",
          style: TextStyle(color: Colors.black, fontFamily: "HanM"),
          textScaleFactor: 1.2),
      centerTitle: true,
    );
  }

  AppBar breakdownappbarUI() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Text("이용 내역",
          style: TextStyle(color: Colors.black, fontFamily: "HanM"),
          textScaleFactor: 1.2),
      centerTitle: true,
    );
  }

  Widget _getPage(int index) {
    if (index == 1) {
      return breakdownUI();
    } else if (index == 3) {
      return mypageUI();
    } else {
      return mainpageUI();
    }
  }

  Widget mybottomnav() {
    return BottomNavigationBar(
      elevation: 5,
      currentIndex: selectedindex,
      onTap: (index) {
        print(index);
        if (index == 1 || index == 2 || index == 3) {
          setState(() {
            selectedindex = index;
          });
        } else {
          movepage(index);
        }
      },
      selectedItemColor: Color(0xff47ABFF),
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.circle_grid_3x3_fill), label: '메뉴'),
        BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.arrow_3_trianglepath), label: '이용내역'),
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '홈'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: '내 정보'),
        BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined), label: '장바구니'),
      ],
    );
  }
}
