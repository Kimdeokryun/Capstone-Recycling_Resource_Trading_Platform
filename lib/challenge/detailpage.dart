import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecocycle/challenge/otheruserpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:ui';

import '../customlibrary/progressindicator.dart';
import '/customlibrary/hashtagcontroller.dart';
import '/server/http_post.dart';
import 'challenge_http.dart';
import 'challengemainpage.dart';

class detailpage extends StatefulWidget {
  @override
  _detailpage createState() => _detailpage();
}

class _detailpage extends State<detailpage> {
  late Size size;
  late Uint8List _profile_path;
  late Map<String, dynamic> _user_profile;
  late List<Future> images = [];

  bool isloading = true;
  String appbarname = "";

  int like_num = 0;
  bool like = false;
  String _nick_name = "";
  String title = "";
  String hashtag = "";
  String _phonenum = "";
  String time = "";

  late Map<String, dynamic> datas;

  Future<void> getdata() async {
    appbarname = "챌린지 게시물";
    datas = Get.arguments[0];
    print(datas);

    // 프로필 사진과 닉네임 가져오기  (프로필 사진을 눌렀을 때, 해당 사용자의 프로필로 가기.)  (datas["phonenum"])
    _phonenum = datas["phonenum"];
    _user_profile = (await Other_Profile(_phonenum))!;
    _profile_path = base64Decode(_user_profile['profile']);
    _nick_name = datas["list"][0]["name"];
    time = await CalData(datas["createdAt"]);
    //사진
    for (var data in datas["list"]) {
      images.add(fetchImage(data["imagePath"]));
    }
    // 좋아요 버튼 로직 처리 (datas["_id"])
    like = await if_like_post(datas["_id"], userinfo.getphonenum());
    // 좋아요 개수 가져오기   (datas["_id"])
    like_num = await search_posts_likenum(datas["_id"]);

    // 타이틀  (datas["list"][0]["address"])
    title = datas["list"][0]["address"];
    // 해시태그   (datas["list"][0]["resourceNum"])
    hashtag = datas["list"][0]["resourceNum"];
  }

  Future<String> CalData(String serverdate) async {
    DateTime dateTime = DateTime.parse(serverdate);
    DateTime now = DateTime.now();

    Duration difference = now.difference(dateTime);
    String date = "";
    if (difference.inDays >= 7) {
      DateFormat formatter = DateFormat('yyyy년 M월 d일');
      date = formatter.format(dateTime);
      print(date);
    } else if (difference.inDays > 0) {
      date = '${difference.inDays}일 전';
      print('${difference.inDays}일 전');
    } else if (difference.inHours > 0) {
      date = '${difference.inHours}시간 전';
      print('${difference.inHours}시간 전');
    } else if (difference.inMinutes > 0) {
      date = '${difference.inMinutes}분 전';
      print('${difference.inMinutes}분 전');
    } else if (difference.inSeconds > 0) {
      date = '${difference.inSeconds}초 전';
      print('${difference.inSeconds}초 전');
    } else {
      date = '방금 전';
      print('방금 전');
    }
    return date;
  }

  Future<void> push(what) async {
    if (what == "like") {
      bool status = await like_post(datas["_id"], userinfo.getphonenum());
      int number = await search_posts_likenum(datas["_id"]);
      setState(() {
        like = status;
        like_num = number;
      });
    } else //share 부분
    {}
  }

  void next_user_page() {
    //_phonenum
    Get.to(() => otheruserpage(),
        arguments: [_phonenum, _nick_name, _profile_path]);
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
      backgroundColor: Colors.white,
            appBar: mainappbar(),
            body: mainbody(),
          );
  }

  AppBar mainappbar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
        // 이 부분이 뒤로 가기 버튼 아이콘을 변경하는 부분입니다.
        onPressed: () => Navigator.of(context).pop(),
      ),
      toolbarHeight: size.height * 0.05,
      title: Text(
        appbarname,
        style: const TextStyle(color: Colors.black, fontFamily: "HanM"),
        textScaleFactor: 0.8,
      ),
      centerTitle: true,
    );
  }

  Widget mainbody() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Container(
        width: size.width,
        height: size.height,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 1,
              color: Colors.black12,
            ),
            top_status(),
            Container(
              height: 1,
              color: Colors.black12,
            ),
            slider(),
            Container(height: 10),
            middle_status(),
            Container(height: 10),
            widget_title(),
            Container(height: 10),
            widget_hashtag(),
            Container(height: 30),
            widget_time()
          ],
        ),
      ),
    );
  }

  Widget top_status() {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        profile(),
      ]),
    );
  }

  Widget profile() {
    return GestureDetector(
      onTap: () {
        //personal_page
        next_user_page();
      },
      child: Container(
        child: Row(
          mainAxisSize: MainAxisSize.min, // Row의 가로 크기를 최소로 설정
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: 10,
            ),
            SizedBox(
              width: size.height * 0.05,
              height: size.height * 0.05,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.grey),
                child: ClipOval(
                  child: Image.memory(_profile_path),
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Text(_nick_name,
                style: TextStyle(color: Colors.black, fontFamily: "HanB"),
                textScaleFactor: 1)
          ],
        ),
      ),
    );
  }

  int currentpage = 0;
  int numofimage = 3;

  List<Widget> indicators(listLength, currentIndex) {
    return List<Widget>.generate(listLength, (index) {
      return Container(
        margin: const EdgeInsets.all(3),
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color:
                currentIndex == index ? const Color(0xff47ABFF) : Colors.grey,
            borderRadius: BorderRadius.circular(100)),
      );
    });
  }

  Widget slider() {
    return Stack(
      children: [
        CarouselSlider.builder(
          options: CarouselOptions(
            aspectRatio: 1 / 1,
            autoPlay: false,
            enlargeCenterPage: true,
            enableInfiniteScroll: false,
            viewportFraction: 1.0,
            onPageChanged: (index, reason) {
              setState(() {
                currentpage = index;
              });
            },
          ),
          itemCount: images.length, // 리스트의 길이만큼 아이템 생성
          itemBuilder: (context, index, realIndex) {
            // 각 이미지에 대한 FutureBuilder
            return FutureBuilder(
              future: images[index],
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.statusCode == 200) {
                    return Image.memory(snapshot.data!.bodyBytes);
                  } else {
                    return const Text('Failed to load image');
                  }
                } else if (snapshot.hasError) {
                  return Text('이미지 로드 오류');
                } else {
                  return Progressindicator();
                }
              },
            );
          },
        ),
        Positioned(
          bottom: 10, // 위쪽으로 10 픽셀 이동
          right: 10, // 왼쪽으로 10 픽셀 이동
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: (currentpage + 1).toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'HanM',
                    ),
                  ),
                  const TextSpan(
                    text: ' / ',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'HanM',
                    ),
                  ),
                  TextSpan(
                    text: images.length.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'HanM',
                    ),
                  ),
                ],
              ),
              textScaleFactor: 0.8,
            ),
          ),
        ),
      ],
    );
  }

  Widget middle_status() {
    return Container(
      padding:
          EdgeInsets.only(left: size.width * 0.05, right: size.width * 0.05),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {
                    push("like");
                  },
                  icon: Icon(
                      !like
                          ? CupertinoIcons.suit_heart
                          : CupertinoIcons.suit_heart_fill,
                      color: !like ? Colors.black : Colors.red,
                      size: size.width * 0.08)),
              indicator(),
              IconButton(
                  onPressed: () {},
                  icon: Icon(CupertinoIcons.share_up, size: size.width * 0.08))
            ],
          ),
          RichText(
            textAlign: TextAlign.start,
            textScaleFactor: 1,
            text: TextSpan(children: [
              const TextSpan(
                  text: "좋아요 ",
                  style: TextStyle(color: Colors.black, fontFamily: 'HanM')),
              TextSpan(
                text: like_num == 0 ? "" : like_num.toString(),
                style: const TextStyle(color: Colors.red, fontFamily: 'HanB'),
              ),
              TextSpan(
                  text: like_num == 0 ? "" : " 개 ",
                  style:
                      const TextStyle(color: Colors.black, fontFamily: 'HanM'))
            ]),
          )
        ],
      ),
    );
  }

  Widget indicator() {
    return Expanded(
        child: Container(
      color: Colors.white,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: indicators(images.length, currentpage)),
    ));
  }

  Widget widget_title() {
    return Container(
      padding:
          EdgeInsets.only(left: size.width * 0.05, right: size.width * 0.05),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              next_user_page();
            },
            child: Text(_nick_name,
                style:
                    const TextStyle(color: Colors.black, fontFamily: 'HanB')),
          ),
          Container(
            width: 5,
          ),
          Text(title,
              style: const TextStyle(color: Colors.black, fontFamily: 'HanM')),
        ],
      ),
    );
  }

  Widget widget_hashtag() {
    return Container(
      padding:
          EdgeInsets.only(left: size.width * 0.05, right: size.width * 0.05),
      child: GestureDetector(
        onTap: (){
          print(hashtag);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            HashTagText(text: hashtag, style: const TextStyle(fontFamily: "HanR", color: Colors.black, fontSize: 15))
          ],
        ),
      ),
    );
  }

  Widget widget_time() {
    return Container(
      padding:
          EdgeInsets.only(left: size.width * 0.05, right: size.width * 0.05),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(time,
              style: const TextStyle(color: Colors.black, fontFamily: 'HanM')),
        ],
      ),
    );
  }
}
