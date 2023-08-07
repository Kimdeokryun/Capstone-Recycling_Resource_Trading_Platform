import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../customlibrary/textanimation.dart';
import '../server/http_post.dart';
import '../user/Trans_grade.dart';
import '../user/User_Storage.dart';
import 'dart:io';
import 'dart:math';

class transactiondetailpage extends StatefulWidget {
  @override
  _transactiondetailpage createState() => _transactiondetailpage();
}

class _transactiondetailpage extends State<transactiondetailpage> {
  late Size size;
  late Icon _icon1 = Icon(CupertinoIcons.heart,
      color: Colors.black38, size: size.width * 0.08);

  late final args;
  late List<Map<String, String>> files = [];
  late String address;
  late int wheretoin;

  int _currentPage = 0;
  bool isloading = true;
  bool likepress = false;

  PageController _pageController = PageController();

  late Map<String, dynamic> _userdata;
  late Map<String, dynamic> _transdata;
  late String _usernick;
  late double ecopercent;
  late List<String> ecoGrade;
  late String _profile_path;

  int getRandomInt(int min, int max) {
    final random = Random();
    return min + random.nextInt(max - min + 1);
  }

  void getdata1() async {
    _userdata = (await getUserData())!;
    _transdata = (await getTransData())!;
    _usernick = _userdata['nickname'];
    _profile_path = _userdata['profile'];

    int _trannum = _transdata['sales'] + _transdata['buy'];
    _trannum = 13;
    ecoGrade = getEcoGrade(_trannum);
    ecopercent = (_trannum % 10) / 10;
    print(ecopercent);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        isloading = false;
      });
    });
  }

  void getdata2(dynamic arguments) async {
    _usernick = arguments["list"][0]["name"];
    address = arguments["list"][0]["address"];
    int _trannum = getRandomInt(1,100);
    ecoGrade = getEcoGrade(_trannum);
    ecopercent = (_trannum % 10) / 10;
    print(ecopercent);
    for(var data in arguments["list"]){
      files.add({"path": data["imagePath"], "info": data["resourceNum"]});
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
    if(wheretoin == 1)// 거래 페이지에서 바로 보여줄 때.
    {
      getdata2(args[1]);
    }
    else{
      files = args[1];
      address = args[2];
      getdata1();
    }

  }

  @override
  void dispose() {
    _pageController.dispose();
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
                  child: Column(
                    children: [
                      pagebar(),
                      Container(
                        height: size.height * 0.05,
                      ),
                      Container(
                        width: size.width * 0.8,
                        height: size.width * 0.95,
                        child: buildPageView(),
                      ),
                      Container(
                        height: size.height * 0.01,
                      ),
                      buildIndicator(),
                    ],
                  ),
                ),
              ),
        bottomNavigationBar: bottomnav(),
      ),
    );
  }

  DecoratedBox buildCircularProgressIndicator(double percent, Size size) {
    return DecoratedBox(
      decoration: BoxDecoration(
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
      child: Container
        (
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white
        ),
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
      decoration: BoxDecoration(
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
              child: ClipRect(
                child: wheretoin == 0 ? Image.file(File(_profile_path)) : Container(),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: size.width * 0.55,
                padding: EdgeInsets.only(bottom: size.height*0.005,left: size.width * 0.05),
                child: Container(
                  child: Text(_usernick,
                      style: TextStyle(color: Colors.black, fontFamily: "HanM"),
                      textScaleFactor: 1.5),
                ),
              ),
              Container(
                width: size.width * 0.55,
                padding: EdgeInsets.only(top: size.height*0.005, left: size.width * 0.05),
                child: Container(
                  child: Text(address,
                      style: TextStyle(color: Colors.black, fontFamily: "HanM"),
                      textScaleFactor: 1),
                ),
              ),
            ],
          ),
          Container(
            width: size.width * 0.2,
            height: size.width * 0.21,
            child: buildCircularProgressIndicator(
                ecopercent, Size(size.height * 0.08, size.height * 0.08)),
          ),
        ],
      ),
    );
  }

  Widget buildPageView() {
    return PageView(
      controller: _pageController,
      children: files
          .map((file) => buildPageItem(file['path']!, file['info']!))
          .toList(),
      onPageChanged: (int index) {
        setState(() {
          _currentPage = index;
        });
      },
    );
  }

  Widget buildPageItem(String imagePath, String info) {
    return Container(
      width: size.width * 0.7,
      // 각 페이지의 디자인과 내용을 구성
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: wheretoin == 0 ? Image.file(File(imagePath)) : FutureBuilder(
                future: fetchImage(
                    imagePath),
                builder: (BuildContext context,
                    AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.statusCode ==
                        200) {
                      return Image.memory(
                          snapshot.data!.bodyBytes);
                    } else {
                      return const Text(
                          'Failed to load image');
                    }
                  } else if (snapshot.hasError) {
                    return Text('이미지 로드 오류');
                  } else {
                    return const CircularProgressIndicator(
                      color: Colors.black26,
                    );
                  }
                },
              ),
            ),
          ),
          Container(
            height: size.height * 0.01,
          ),
          Text(info == "" ? "자원 정보가 없습니다." : info,
              style: TextStyle(fontFamily: "HanM")),
        ],
      ),
    );
  }

  Widget buildIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(files.length, (index) {
        return Container(
          width: 10,
          height: 10,
          margin: EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index ? Color(0xff47ABFF) : Colors.black12,
          ),
        );
      }),
    );
  }

  Widget bottomnav() {
    return BottomAppBar(
      height: size.height * 0.08,
      elevation: 0,
      // this creates a notch in the center of the bottom bar
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white, // 적용할 단색 색상
          border: Border(
            top: BorderSide(
              color: Colors.black12, // 적용할 border 색상
              width: 1.0, // border 너비
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                width: size.width * 0.25,
                child: IconButton(
                  icon: wheretoin == 0 ? const Icon(CupertinoIcons.heart_fill, color: Colors.white) :_icon1,
                  onPressed: wheretoin == 0 ? null : () {
                    setState(() {
                      likepress = !likepress;
                      if (likepress) {
                        _icon1 = Icon(CupertinoIcons.heart_fill,
                            color: Colors.red, size: size.width * 0.08);
                      } else {
                        _icon1 = Icon(CupertinoIcons.heart,
                            color: Colors.black38, size: size.width * 0.08);
                      }
                    });
                  },
                ),
              ),
            ),
            Center(
              child: Container(
                width: 1,
                height: size.height * 0.06,
                decoration: BoxDecoration(color: Colors.black38),
              ),
            ),
            Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: size.width*0.3),
              child: Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    wheretoin == 0 ? Container(
                      width: size.width * 0.15,
                      height: size.height * 0.03,
                      decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: Text(
                          "ecotalk",
                          style: TextStyle(
                              color: Colors.white, fontFamily: "HanM"),
                          textScaleFactor: 1,
                        ),
                      ),
                    ) : Container(
                      width: size.width * 0.15,
                      height: size.height * 0.03,
                      decoration: BoxDecoration(
                          color: Color(0xff47ABFF),
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: Text(
                          "ecotalk",
                          style: TextStyle(
                              color: Colors.white, fontFamily: "HanM"),
                          textScaleFactor: 1,
                        ),
                      ),
                    ),
                    Container(width: size.width*0.05,),
                    Container(
                      child: GestureDetector(
                        onTap: wheretoin == 0 ? null : () {},
                        child: Center(
                          child: Text(
                            "대화하기",
                            style: TextStyle(
                                color: wheretoin == 0 ? Colors.black26 : Colors.black, fontFamily: "HanM"),
                            textScaleFactor: 1.6,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
