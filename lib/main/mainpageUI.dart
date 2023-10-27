import 'package:ecocycle/main/mainpage.dart';
import 'package:ecocycle/notice/noticepage.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../collection/resource_transaction.dart';
import 'package:get/get.dart';

import '../customlibrary/textanimation.dart';
import '../server/http_post.dart';
import '../user/Trans_grade.dart';
import '../user/User_Storage.dart';
import '/challenge/challengemainpage.dart';
import 'dart:ui';

import 'ReadytoPage.dart';
import 'package:ecocycle/how/howpage.dart';
import 'package:ecocycle/mall/mainmallpage.dart';


class mainpageUI extends StatefulWidget {
  @override
  _mainpageUI createState() => _mainpageUI();
}

class _mainpageUI extends State<mainpageUI>with TickerProviderStateMixin{
  late Size size;
  Color _color1 = Colors.transparent;
  Color _color2 = Colors.transparent;
  int noticecount = 1;
  int selectedindex = 2;

  late ScrollController _scrollController;
  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _controller3;
  late AnimationController _controller4;
  late AnimationController _controller5;

  late AnimationController _subcontroller;

  late Map<String, dynamic> _userdata;
  late String _usernick;
  late double ecopercent;
  late List<String> ecoGrade;

  bool isloading = true;

  bool get _changeExposureAppBarState {
    return _scrollController.hasClients && _scrollController.offset > ( 200 - size.height *0.05);
  }

  void movepage(where) {
    if(where == "about"){}
    else if(where == "how"){
      Get.to(() => howpage());
    }
    else if (where == "collection") {
      Get.to(() => transactionpage());
    } else if (where == "mall") {
      Get.to(() => mainmallpage());
    }
    else if(where == "notice")
    {
      Get.to(() => noticepage(), arguments: ["공지사항"]);
    }
    else if(where == "challenge")
    {
      Get.to(() => challengemain(), arguments: ["재활용 챌린지"]);

    }
  }

  void getdata() async {
    _userdata = (await getUserData())!;
    _usernick = _userdata['nickname'];

    Map<String, dynamic> _user_profile = (await Other_Profile(_userdata["phonenumber"]))!;
    int _trannum = int.parse(_user_profile['point']);

    ecoGrade = getEcoGrade(_trannum);
    ecopercent = (_trannum % 10) / 10;
    setState(() {
      isloading = false;
    });
  }


  @override
  void initState() {
    super.initState();
    getdata();
    // 서버로 부터 사진과 에코사이클링 횟수 전달 받음
    _scrollController = ScrollController()..addListener(
            (){
          setState(() {
            _color1 = _changeExposureAppBarState ? const Color(0xff47ABFF) : Colors.transparent;
            _color2 = _changeExposureAppBarState ? Colors.black : Colors.transparent;
          }
          );
        }
    );
    _controller1 = AnimationController(
      duration: const Duration(milliseconds: 100), vsync: this,
    );
    _controller2 = AnimationController(
      duration: const Duration(milliseconds: 100), vsync: this,
    );
    _controller3 = AnimationController(
      duration: const Duration(milliseconds: 100), vsync: this,
    );
    _controller4 = AnimationController(
      duration: const Duration(milliseconds: 100), vsync: this,
    );
    _controller5 = AnimationController(
      duration: const Duration(milliseconds: 100), vsync: this,
    );
    _subcontroller = AnimationController(
      duration: const Duration(milliseconds: 100), vsync: this,
    );

  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    _controller5.dispose();
    _subcontroller.dispose();
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

    return isloading ?  Container(color: Colors.white,child: Center(child: BouncingTextAnimation()),) : mainappbar();
  }

  DecoratedBox buildCircularProgressIndicator(double percent, Size size) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Container
        (
        decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white
        ),
        child: CircularPercentIndicator(
          radius: size.width * 0.6,
          lineWidth: size.height * 0.06,
          animation: true,
          animationDuration: 1000,
          percent: percent,
          progressColor: const Color(0xff47ABFF),
          backgroundColor: Colors.black12,
          fillColor: Colors.transparent,
          circularStrokeCap: CircularStrokeCap.round,
          center: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: "${ecoGrade[0]}\n",
                  style: TextStyle(color: Colors.black, fontFamily: 'HanM', fontSize: size.width*0.2),
                ),
                TextSpan(
                  text: " ${(percent * 100).toStringAsFixed(0)}%",
                  style: TextStyle(color: Colors.black, fontFamily: 'HanM', fontSize: size.width*0.2),
                ),
              ],
            ),
            textScaleFactor: 1,
          ),
        ),
      ),
    );
  }

  CustomScrollView mainappbar() {
    return CustomScrollView(
      controller: _scrollController,
      slivers: <Widget>[
        SliverAppBar(
          expandedHeight: size.width*0.5,
          toolbarHeight: size.height*0.05,
          elevation: 1,
          pinned: true,
          snap: false,
          floating: false,
          stretch: true,
          title: RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: "환경운동가 ",
                    style: TextStyle(color: _color1, fontFamily: 'HanM')),
                TextSpan(
                  text: "$_usernick님",
                  style: TextStyle(color: _color2, fontFamily: 'HanM'),
                )
              ]),
              textScaleFactor: 1.3),  // 서버에서 이름과 등급 받아옴
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.light,
              statusBarColor: Colors.transparent
          ),
          flexibleSpace:
          FlexibleSpaceBar(
            background: ShaderMask(
              shaderCallback: (Rect bound){
                return const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.white],
                    stops: [0.9,1.0]
                ).createShader(bound);
              },
              blendMode: BlendMode.colorDodge,
              child: Image.asset('assets/image/1.png', fit: BoxFit.contain),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
              return Container(
                color: Colors.white,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      statusbar(),
                      mainfunc1(),
                      subfunc(),
                      mainfunc2(),
                      mainfunc3(),
                      Container(
                        height: size.height * 0.2,
                        color: Colors.white,
                        child: Center(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: "eco",
                                  style: TextStyle(color: Colors.black, fontFamily: 'HanM'),
                                ),
                                TextSpan(
                                  text: "cycle",
                                  style: TextStyle(color: Color(0xff47ABFF), fontFamily: 'HanM'),
                                ),
                              ],
                            ),
                            textScaleFactor: 2,
                          ),
                        ),
                      ),
                    ]),
              );
            },
            childCount: 1,
          ),
        ),
      ],
    );
  }

  statusbar(){
    return Container(
      width: size.width,
      height: size.height*0.11,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: size.width * 0.22,
            height: size.width * 0.22,
            child: buildCircularProgressIndicator(
                ecopercent, Size(size.height * 0.08, size.height * 0.08)),
          ),
          Container(
            width: size.width * 0.5,
          ),
          Container(
            child: RichText(
              textAlign: TextAlign.end,
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: "다음 등급\n",
                    style: TextStyle(color: Colors.black, fontFamily: 'HanM'),
                  ),
                  TextSpan(
                    text: ecoGrade[1],
                    style: const TextStyle(color: Color(0xff47ABFF), fontFamily: 'HanM'),
                  ),
                ],
              ),
              textScaleFactor: 1.3,
            ),
          ),
        ],
      ),
    );
  }


  Widget mainfunc1(){
    return Container(
      margin:
      EdgeInsets.only(top: size.height * 0.025),
      width: size.width * 0.9,
      height: size.height * 0.2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: size.width*0.425,
            height: size.width*0.425,
            margin:
            EdgeInsets.only(right: size.width * 0.05),
            child: ScaleTransition(
                scale: Tween<double>(
                    begin: 1.0,
                    end: 0.95
                ).animate(_controller1),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 1,
                        )
                      ],
                      image: const DecorationImage(
                          image: AssetImage('assets/image/수거요청.png'),
                          fit: BoxFit.cover
                      )
                  ),
                  child: GestureDetector(
                      onTap: () {
                        _controller1.forward();
                        Future.delayed(const Duration(milliseconds: 100), () { _controller1.reverse();});
                        Future.delayed(const Duration(milliseconds: 200), () { movepage("collection");});
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: size.width*0.03, top: size.width*0.03),
                        child: const Text('자원 거래',
                            style: TextStyle(fontFamily: "HanB", color: Colors.black),
                            textScaleFactor: 1.5),
                      )
                  ),
                )
            ),
          ),
          GestureDetector(
            onTap: (){
              _controller2.forward();
              Future.delayed(const Duration(milliseconds: 100), () { _controller2.reverse();});
              Future.delayed(const Duration(milliseconds: 200), () { movepage("how");});
            },child: Container(
              width: size.width*0.425,
              height: size.width*0.425,
              child: ScaleTransition(
                scale: Tween<double>(
                    begin: 1.0,
                    end: 0.95
                ).animate(_controller2),
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 1,
                        ),
                      ],
                      color: Colors.white,
                    ),
                    child: Container(
                      margin: EdgeInsets.only(left: size.width*0.03, top: size.width*0.03),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('이건 어떻게\n버릴까?',
                              style: TextStyle(fontFamily: "HanB", color: Colors.black),
                              textScaleFactor: 1.5),
                          Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    image: const DecorationImage(
                                      image: AssetImage('assets/image/어떻게버릴까.png'),
                                      fit: BoxFit.contain,
                                    )
                                ),
                              )
                          )
                        ],
                      ),
                    )
                ),
              )
          ),
          )
        ],
      ),
    );
  }

  Widget subfunc(){
    return Container(
      margin:
      EdgeInsets.only(top: size.height * 0.025),
      width: size.width * 0.9,
      height: size.width*0.3,
      child: GestureDetector(
        onTap: (){
          _subcontroller.forward();
          Future.delayed(const Duration(milliseconds: 100), () { _subcontroller.reverse();});
          Future.delayed(const Duration(milliseconds: 200), () { movepage("challenge");});
        },child: Container(
          width: size.width*0.9,
          height: size.width*0.2,
          child: ScaleTransition(
            scale: Tween<double>(
                begin: 1.0,
                end: 0.95
            ).animate(_subcontroller),
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 1,
                      )
                    ],
                    color: Color(0xff47ABFF)
                ),
                child: Container(
                  margin: EdgeInsets.only(left: size.width*0.03, top: size.width*0.03),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text('재활용 챌린지',
                                  style: TextStyle(fontFamily: "HanB", color: Colors.white),
                                  textScaleFactor: 1.5),
                              Container(width: size.width*0.02),
                              const Icon(Icons.outlined_flag_rounded, color: Colors.white,)
                            ],
                          ),
                          Container(height: size.height*0.01,),
                          const Text('사진을 공유하고 포인트를 받아가자!',
                              style: TextStyle(fontFamily: "HanM", color: Colors.white),
                              textScaleFactor: 1)
                        ],
                      ),
                      Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                image: const DecorationImage(
                                    image: AssetImage('assets/image/eco.png'),
                                    fit: BoxFit.fitWidth,
                                    alignment: Alignment.center
                                )
                            ),
                          )
                      )
                    ],
                  ),
                )
            ),
          )
      ),
      ),
    );
  }

  Widget mainfunc2(){
    return Container(
      margin:
      EdgeInsets.only(top: size.height * 0.025),
      width: size.width * 0.9,
      height: size.width*0.3,
      child: GestureDetector(
        onTap: (){
          _controller3.forward();
          Future.delayed(const Duration(milliseconds: 100), () { _controller3.reverse();});
          Future.delayed(const Duration(milliseconds: 200), () { movepage("mall");});
        },child: Container(
          width: size.width*0.9,
          height: size.width*0.2,
          child: ScaleTransition(
            scale: Tween<double>(
                begin: 1.0,
                end: 0.95
            ).animate(_controller3),
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 1,
                      )
                    ],
                    color: Colors.white
                ),
                child: Container(
                  margin: EdgeInsets.only(left: size.width*0.03, top: size.width*0.03),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('제품몰',
                          style: TextStyle(fontFamily: "HanB", color: Colors.black),
                          textScaleFactor: 1.5),
                      Container(height: size.height*0.01,),
                      const Text('이런 제품은 어때?',
                          style: TextStyle(fontFamily: "HanM", color: Colors.black),
                          textScaleFactor: 1)
                    ],
                  ),
                )
            ),
          )
      ),
      ),
    );
  }

  Widget mainfunc3(){
    return Container(
      margin:
      EdgeInsets.only(top: size.height * 0.025, bottom: size.height * 0.025),
      width: size.width * 0.9,
      height: size.width*0.3,
      child: GestureDetector(
        onTap: (){
          _controller4.forward();
          Future.delayed(const Duration(milliseconds: 100), () { _controller4.reverse();});
          Future.delayed(const Duration(milliseconds: 200), () { movepage("notice");});
        },child: Container(
          width: size.width*0.9,
          height: size.width*0.2,
          child: ScaleTransition(
            scale: Tween<double>(
                begin: 1.0,
                end: 0.95
            ).animate(_controller4),
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 1,
                      )
                    ],
                    color: Colors.white
                ),
                child: Container(
                  margin: EdgeInsets.only(left: size.width*0.03, top: size.width*0.03),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('공지사항',
                          style: TextStyle(fontFamily: "HanB", color: Colors.black),
                          textScaleFactor: 1.5),
                      Container(height: size.height*0.01,),
                    ],
                  ),
                )
            ),
          )
      ),
      ),
    );
  }
}

