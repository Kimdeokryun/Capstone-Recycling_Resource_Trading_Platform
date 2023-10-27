import 'package:ecocycle/how/detailhowpage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:ui';

class noticepage extends StatefulWidget {
  @override
  _noticepage createState() => _noticepage();
}

class _noticepage extends State<noticepage> {
  late Size size;
  late ScrollController _scrollController;

  bool isloading = true;
  String appbarname = "";

  List color_list = [
    Color(0xff329886),
    Color(0xffD94925),
    Color(0xff125E9E),
    Color(0xff5D6DBE),
    Color(0xff692498),
    Color(0xffFD6F22)
  ];

  List resource_list = ["유리", "금속", "종이", "플라스틱", "스티로폼", "비닐"];

  Future<void> getdata() async {
    appbarname = await Get.arguments[0];
    setState(() {
      isloading = false;
    });
  }

  void movepage(num) {
    Get.to(detailhowpage(), arguments: [num]);
  }

  Future<void> movepage2(where) async {
    print(where);
    if (where == "instagram"){
      // 브라우저를 열 링크
      final url = Uri.parse('https://www.instagram.com/ecocycle_official/');
      // 인앱 브라우저 실행
      if (await canLaunchUrl(url)){
        print("canlaunch");
        launchUrl(url, mode:LaunchMode.externalApplication);
      }
      else{
        print("Instagram을 실행할 수 없음");
      }
    }
    //Get.to(detailhowpage(), arguments: [num]);
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    getdata().then((_) {
      isloading = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
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

    return isloading
        ? Container(
            color: Colors.white,
          )
        : Scaffold(
            appBar: mainappbar(),
            body: SingleChildScrollView(
              child: mainbody(),
            ),
          );
  }

  AppBar mainappbar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: const IconThemeData(
        color: Colors.black, //change your color here
      ),
      title: Text(appbarname,
          style: const TextStyle(color: Colors.black, fontFamily: "HanM"),
          textScaleFactor: 1.1),
      centerTitle: true,
    );
  }

  Widget mainbody() {
    return Container(
      width: size.width,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          hownoticeview(),
          instagram(),
          noticeview1(),
        ],
      ),
    );
  }

  Widget hownoticeview() {
    return SizedBox(
        width: size.width,
        height: size.width * 0.2 * (resource_list.length),
        child: Container(
          color: Colors.white,
          child: ListView.builder(
            physics: const ClampingScrollPhysics(),
            controller: _scrollController,
            itemCount: resource_list.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  print((index + 1).toString());
                  movepage((index + 1).toString());
                },
                child: Container(
                  margin: EdgeInsets.all(size.width * 0.01),
                  decoration: const BoxDecoration(
                      border: Border(
                          top: BorderSide(
                    width: 1,
                    color: Colors.black12,
                  ))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(size.width * 0.02),
                        child: RichText(
                            text: TextSpan(children: [
                              const TextSpan(
                                  text: "eco",
                                  style: TextStyle(
                                      color: Colors.black, fontFamily: 'HanM')),
                              const TextSpan(
                                text: "cycle",
                                style: TextStyle(
                                    color: Color(0xff47ABFF),
                                    fontFamily: 'HanM'),
                              ),
                              const TextSpan(
                                text: " 과 함께 배우는 ",
                                style: TextStyle(
                                    color: Colors.black, fontFamily: 'HanM'),
                              ),
                              TextSpan(
                                text: resource_list[index],
                                style: TextStyle(
                                    color: color_list[index],
                                    fontFamily: 'HanM'),
                              ),
                              const TextSpan(
                                text: " 분리배출",
                                style: TextStyle(
                                    color: Colors.black, fontFamily: 'HanM'),
                              ),
                            ]),
                            textScaleFactor: 1.2),
                      ),
                      Container(
                        padding: EdgeInsets.all(size.width * 0.02),
                        child: const Text(
                          "2023.09.23 22:00",
                          style: TextStyle(
                              color: Colors.black26, fontFamily: "HanM"),
                          textScaleFactor: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ));
  }

  Widget instagram() {
    return Container(
      width: size.width,
      color: Colors.white,
      child: GestureDetector(
        onTap: () {
          print("instagram");
          movepage2("instagram");
        },
        child: Container(
          margin: EdgeInsets.all(size.width * 0.01),
          decoration: const BoxDecoration(
              border: Border(
                  top: BorderSide(
                    width: 1,
                    color: Colors.black12,
                  ))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(size.width * 0.02),
                child: RichText(
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
                      TextSpan(
                        text: " Instagram ",
                        style: TextStyle(
                            color: Colors.black, fontFamily: 'HanM'),
                      ),
                    ]),
                    textScaleFactor: 1.2),
              ),
              Container(
                padding: EdgeInsets.all(size.width * 0.02),
                child: const Text(
                  "2023.09.23 12:00",
                  style: TextStyle(color: Colors.black26, fontFamily: "HanM"),
                  textScaleFactor: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget noticeview1() {
    return Container(
      width: size.width,
      color: Colors.white,
      child: GestureDetector(
        onTap: () {
          print("7");
          movepage("7");
        },
        child: Container(
          margin: EdgeInsets.all(size.width * 0.01),
          decoration: const BoxDecoration(
              border: Border(
                  top: BorderSide(
                    width: 1,
                    color: Colors.black12,
                  ))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(size.width * 0.02),
                child: RichText(
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
                      TextSpan(
                        text: " 이란? ",
                        style: TextStyle(
                            color: Colors.black, fontFamily: 'HanM'),
                      ),
                    ]),
                    textScaleFactor: 1.2),
              ),
              Container(
                padding: EdgeInsets.all(size.width * 0.02),
                child: const Text(
                  "2023.09.22 12:00",
                  style: TextStyle(color: Colors.black26, fontFamily: "HanM"),
                  textScaleFactor: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
