import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../customlibrary/textanimation.dart';
import '../server/http_post.dart';
import '../user/Trans_grade.dart';
import '../user/User.dart';
import '../user/User_Storage.dart';
import 'dart:io';
import 'dart:math';

class buy_page extends StatefulWidget {
  @override
  _buy_page createState() => _buy_page();
}

class _buy_page extends State<buy_page> {
  late Size size;
  late Icon _icon1 = Icon(CupertinoIcons.heart,
      color: Colors.black38, size: size.width * 0.08);

  late final args;
  late List<Map<String, String>> files = [];

  late int wheretoin;

  bool isloading = true;
  bool likepress = false;

  late Map<String, dynamic> _userdata;
  late Map<String, dynamic> _user_profile;
  late String _address;

  late String _usernick;
  late double ecopercent;
  late List<String> ecoGrade;
  late Uint8List _profile_path;
  late String _id;

  Map<String, String> category_key = {
    "PET" : "1",
    "PP" : "2",
    "알루미늄캔" : "3",
    "철스크랩" : "4",
    "철캔" : "5",
    "갈색 유리병" : "6",
    "백색 유리병" : "7",
    "청녹색 유리병" : "8",
    "ABS" : "9",
    "F PE" : "10",
    "F PET 무색" : "11",
    "F PET 복합" : "12",
    "F PET 유색" : "13",
    "F PP" : "14",
    "F PS" : "15",
    "F PVC" : "16",
  };


  Map<String, String> name_data = {};
  Map<String, String> number_data = {};
  Map<String, String> price_data = {};

  int getRandomInt(int min, int max) {
    final random = Random();
    return min + random.nextInt(max - min + 1);
  }

  // 본인 정보 불러옴
  void getdata1() async {
    _userdata = (await getUserData())!;

    _address = svaddress.get();
    _usernick = _userdata['nickname'];

    _user_profile = (await Other_Profile(_userdata["phonenumber"]))!;
    _profile_path = base64Decode(_user_profile['profile']);
    int _trannum = int.parse(_user_profile['point']);

    ecoGrade = getEcoGrade(_trannum);
    ecopercent = (_trannum % 10) / 10;
    print(ecopercent);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        isloading = false;
      });
    });

    bool sent_info= await sent_buy_info(_userdata, _address, name_data, number_data);   // http_post
    print(sent_info);
  }

  // 게시물 개인 정보 불러옴
  void getdata2(dynamic arguments) async {
    print("==============page id=====================");
    print(_id);
    print("==============page id=====================");

    _usernick = arguments["list"][0]["name"];
    _address = arguments["list"][0]["address"];

    _user_profile = (await Other_Profile(arguments["phonenum"]))!;
    _profile_path = base64Decode(_user_profile['profile']);
    int _trannum = int.parse(_user_profile['point']);

    ecoGrade = getEcoGrade(_trannum);
    ecopercent = (_trannum % 10) / 10;
    print(ecopercent);

    for (var data in arguments["list"]) {
      String key = "";

      if (category_key.containsKey(data["resourceNum"])) {
        key = category_key[data["resourceNum"]]!;
      } else {
        // 매핑되는 값이 없을 때의 처리
        key = "17";
      }
      name_data[key] = data["resourceNum"];
      number_data[key] = data["num"].toString();
    }

    for (var entry in name_data.entries)
    {
      print(entry.value);
      print(number_data[entry.key]);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        isloading = false;
      });
    });
  }

  void initcomplete() {}

  @override
  void initState() {
    super.initState();
    args = Get.arguments;
    wheretoin = args[0];

    // 등록 이후에 보여주는 페이지
    if (wheretoin == 1) // 거래 페이지에서 바로 보여줄 때.
    {
      _id = args[2];
      getdata2(args[1]);
    } else {
      name_data = args[1];
      number_data = args[2];
      price_data = args[3];

      print(name_data);
      print(number_data);
      print(price_data);

      getdata1();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        setState(() {});
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          centerTitle: true,
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: size.width * 0.01),
              child: IconButton(
                  onPressed: () {
                    //move("home");
                  },
                  icon: Icon(Icons.ios_share),
                  color: Colors.black),
            ),
            Padding(
              padding: EdgeInsets.only(right: size.width * 0.05),
              child: IconButton(
                  onPressed: () {
                    //move("home");
                  },
                  icon: Icon(Icons.more_vert),
                  color: Colors.black),
            ),
          ],
        ),
        body: isloading
            ? Center(child: BouncingTextAnimation())
            : SafeArea(
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      pagebar(),
                      resource_page(),
                      Container(
                        height: size.height * 0.01,
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  DecoratedBox buildCircularProgressIndicator(double percent, Size size) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Container(
        decoration:
            const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
        child: CircularPercentIndicator(
          radius: size.width * 0.6,
          lineWidth: size.height * 0.06,
          animation: true,
          animationDuration: 1000,
          percent: percent,
          progressColor: Color(0xff47ABFF),
          backgroundColor: Colors.black12,
          fillColor: Colors.transparent,
          circularStrokeCap: CircularStrokeCap.round,
          center: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: "${ecoGrade[0]}\n",
                  style: TextStyle(color: Colors.black, fontFamily: 'HanM'),
                ),
                TextSpan(
                  text: " ${(percent * 100).toStringAsFixed(0)}%",
                  style: TextStyle(color: Colors.black, fontFamily: 'HanM'),
                ),
              ],
            ),
            textScaleFactor: 1,
          ),
        ),
      ),
    );
  }

  Widget pagebar() {
    return Container(
      width: size.width,
      height: size.height * 0.15,
      decoration: const BoxDecoration(
        color: Colors.white, // 적용할 단색 색상
        border: Border(
          top: BorderSide(
            color: Colors.black12, // 적용할 border 색상
            width: 1.0, // border 너비
          ),
          bottom: BorderSide(
            color: Colors.black12, // 적용할 border 색상
            width: 1.0, // border 너비
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: size.width * 0.2,
            height: size.width * 0.2,
            padding: EdgeInsets.all(size.width * 0.02),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100), color: Colors.grey),
              child: ClipOval(
                child: Image.memory(_profile_path),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: size.width * 0.55,
                padding: EdgeInsets.only(
                    bottom: size.height * 0.005, left: size.width * 0.05),
                child: Text(_usernick,
                    style: const TextStyle(
                        color: Colors.black, fontFamily: "HanM"),
                    textScaleFactor: 1.5),
              ),
              Container(
                width: size.width * 0.55,
                padding: EdgeInsets.only(
                    top: size.height * 0.005, left: size.width * 0.05),
                child: Text(_address,
                    style: const TextStyle(
                        color: Colors.black, fontFamily: "HanM"),
                    textScaleFactor: 1),
              ),
            ],
          ),
          Container(
            width: size.width * 0.2,
            height: size.width * 0.22,
            child: buildCircularProgressIndicator(
                ecopercent, Size(size.height * 0.08, size.height * 0.08)),
          ),
        ],
      ),
    );
  }

  // 필요자원
  Widget resource_page() {
    return Container(
      width: size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [page_title(), resources_title(), resources_list()],
      ),
    );
  }

  Widget page_title() {
    return Container(
      margin: EdgeInsets.only(left: size.width * 0.1, right: size.width * 0.1),
      padding: EdgeInsets.only(top: size.height*0.03, bottom: size.height*0.03),
      child: const Text(
        "필요로 하는 자원",
        style: TextStyle(color: Colors.black, fontFamily: 'HanM'),
        textScaleFactor: 1.5,
      ),
    );
  }

  Widget resources_title() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black12, width: 1),
          shape: BoxShape.rectangle),
      child: Container(
          margin: EdgeInsets.only(left: size.width * 0.1, right: size.width * 0.1),
          padding: EdgeInsets.only(top: size.height*0.01, bottom: size.height*0.01),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const <Widget>[
              Text("자원명",
                  style: TextStyle(
                      color: Colors.black, fontFamily: 'HanM'),
                  textScaleFactor: 1.2),
              Text("개수",
                  style: TextStyle(
                      color: Colors.black, fontFamily: 'HanM'),
                  textScaleFactor: 1.2),
              Text("금액 및 등록",
                  style: TextStyle(
                      color: Colors.black, fontFamily: 'HanM'),
                  textScaleFactor: 1.2),
            ],
          )),
    );
  }

  Widget resources_list() {
    return Container(
      child: Column(
        children: <Widget>[
          for (var entry in name_data.entries)
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12, width: 1),
                  shape: BoxShape.rectangle),
              child: Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                          width: size.width*0.4,
                          padding: EdgeInsets.all(size.width*0.05),
                          child: Text(entry.value,
                              style: const TextStyle(
                                  color: Colors.black, fontFamily: 'HanM'),
                              textScaleFactor: 1.2)
                      ),
                      Container(
                        width: size.width*0.25,
                        padding: EdgeInsets.only(top: size.width*0.05, bottom: size.width*0.05),
                        child: Text('${number_data[entry.key]}',
                            style: const TextStyle(
                                color: Colors.black, fontFamily: 'HanM'),
                            textScaleFactor: 1.2),
                      ),
                      Container(
                          width: size.width*0.25,
                          child: TextButton(
                              onPressed: () {
                                if(wheretoin == 0){
                                  print("등록 불가");
                                }
                              },
                              style: TextButton.styleFrom(
                                primary: Colors.white, // Button text color
                                backgroundColor: Colors.blue, // Button background color
                                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0), // Button padding
                              ),
                              child: wheretoin == 0 ? Text('${price_data[entry.key]}원') :  const Text('등록하기')
                          )
                      ),
                      Container(
                          width: size.width*0.05,
                      ),
                    ],
                  )),
            ),
        ],
      ),
    );
  }
}
