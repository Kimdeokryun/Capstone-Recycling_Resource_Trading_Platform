import 'package:ecocycle/challenge/passtime_posts.dart';
import 'package:ecocycle/challenge/thistime_posts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:ui';

class challengemainUI extends StatefulWidget {
  @override
  _challengemainUI createState() => _challengemainUI();
}

class _challengemainUI extends State<challengemainUI> with TickerProviderStateMixin {
  late Size size;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // 탭의 개수와 vsync 설정
  }

  @override
  void dispose() {
    _tabController.dispose();
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

    return mainbody();
  }

  Widget mainbody() {
    return Container(
      width: size.width,
      color: Colors.white,
      child: Column(
        children: [
          Material(
            color: Colors.white,
            elevation: 1,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.black, // 선택된 탭의 텍스트 색상 설정
              unselectedLabelColor: Colors.black, // 선택되지 않은 탭의 텍스트 색상 설정
              overlayColor: MaterialStateProperty.all<Color>(Colors.white), // Overlay 색상 설정
              unselectedLabelStyle: const TextStyle(fontFamily: "HanR", fontSize: 15),
              indicatorColor: Colors.black,
              indicatorSize: TabBarIndicatorSize.label, // Indicator 크기 설정
              labelStyle: const TextStyle(fontFamily: "HanM", fontSize: 15),
              tabs: const [
                Tab(text: '전체 챌린지'),
                Tab(text: '지난 챌린지'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const BouncingScrollPhysics(),
              children: [
                thistime_posts(),
                passtime_posts(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
