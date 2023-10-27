import 'package:ecocycle/customlibrary/textanimation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:ui';

import '../user/User_Storage.dart';

class malldetailpage extends StatefulWidget {
  @override
  _malldetailpage createState() => _malldetailpage();
}

class _malldetailpage extends State<malldetailpage> {
  late Size size;
  bool isloading = true;

  late final args;
  late String getnum;
  late int selcategory = 0;

  final Map<String, String> _itemnamelist = {
    "item0": "친환경 반려견 터그",
    "item1": "친환경 애완견 터그",
    "item2": "친환경 애완견 장난감",
    "item3": "친환경 반려견 장난감"
  };
  final Map<String, String> _itemdescriptionlist = {
    "item0":
        "이 제품은 반려견들과 놀이를 즐기는 데 사용되는 터그 장난감입니다. 친환경적인 재료로 제작되어 있어, 환경에 부담을 주지 않으며, 견고하고 안전한 구조로 반려견의 입과 이빨에도 해를 끼치지 않습니다.",
    "item1":
        "이 제품은 모든 종류의 애완견에게 적합한 터그 장난감입니다. 친환경 소재로 만들어져 있어, 환경 보호에 기여하며 동시에 애완동물의 건강을 유지하는 데도 도움이 됩니다.",
    "item2":
        "각종 애완동물용으로 설계된 이 장난감들은 비독성 및 생분해성 소재를 사용하여 환경친화적입니다. 다양한 형태와 기능이 있으므로, 개별 애완동물의 성향과 필요에 맞추어 선택할 수 있습니다.",
    "item3":
        "이런 종류의 장난감은 다양한 형태와 크기로 제공되며, 모두 친환경적인 소재로 만들어져 있습니다. 이는 환경을 보호하는 한편으로, 동물이 안전하게 놀 수 있는 방법을 제공합니다."
  };
  List item_list = ['assets/image/아이템1.png', 'assets/image/아이템2.png'];
  int currentpage = 0;

  Map<String, dynamic> like_press = {};
  late Icon heart_icon = Icon(CupertinoIcons.heart,
      color: Colors.black38, size: size.width * 0.07);

  List category = ["생활/건강", "가구/인테리어", "패션잡화", "가전제품", "전자제품"];

  Future<void> setStorage() async {
    String val1 = jsonEncode(MallLike(like_press["item0"], like_press["item1"],
        like_press["item2"], like_press["item3"]));
    await storage.write(key: 'MallLike', value: val1);
  }

  Future<void> getdata() async {
    args = Get.arguments;
    getnum = args[0];
    selcategory = args[1];

    like_press = (await getMallLike())!;
    print(like_press);

    print(getnum);
    print(selcategory);
  }

  Future<void> move() async {
    print("외부 링크 연동 $getnum");
// 브라우저를 열 링크
    final url = Uri.parse('https://link.tumblbug.com/LTIcHKntlDb');
    // 인앱 브라우저 실행
    if (await canLaunchUrl(url)) {
      print("canlaunch");
      launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      print("Instagram을 실행할 수 없음");
    }
  }

  @override
  void initState() {
    super.initState();
    getdata().then((_) {
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

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: mainappbar(),
      body: isloading
          ? Center(child: BouncingTextAnimation())
          : SingleChildScrollView(
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
      title: Text(
        _itemnamelist[getnum]!,
        style: const TextStyle(color: Colors.black, fontFamily: "HanM"),
        textScaleFactor: 1,
      ),
      centerTitle: true,
    );
  }

  Widget mainbody() {
    return Container(
      width: size.width,
      height: size.height,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          itemimage(),
          const SizedBox(height: 20),
          indicator(),
          const SizedBox(height: 20),
          Container(
            color: Colors.black12,
            width: size.width,
            height: 2,
          ),
          button_container(),
          Container(
            color: Colors.black12,
            width: size.width,
            height: 2,
          ),
          maininfo(),
          //SizedBox(height: size.height*0.2),
        ],
      ),
    );
  }

  Widget itemimage() {
    return Container(
        width: size.width,
        height: size.height * 0.2,
        color: Colors.white,
        child: (getnum == "item0" || getnum == "item3")
            ? PageView(
                onPageChanged: (index) {
                  setState(() {
                    currentpage = index;
                  });
                },
                scrollDirection: Axis.horizontal, // 좌우로 스크롤
                children: <Widget>[
                  Image(image: AssetImage(item_list[0])),
                  Image(
                      image:
                          AssetImage(item_list[1])), // 여기에 두 번째 이미지 경로를 넣으세요.
                ],
              )
            : PageView(
                onPageChanged: (index) {
                  setState(() {
                    currentpage = index;
                  });
                },
                scrollDirection: Axis.horizontal, // 좌우로 스크롤
                children: <Widget>[
                  Image(image: AssetImage(item_list[1])),
                  Image(
                      image:
                          AssetImage(item_list[0])), // 여기에 두 번째 이미지 경로를 넣으세요.
                ],
              ));
  }

  List<Widget> indicators(listLength, currentIndex) {
    return List<Widget>.generate(listLength, (index) {
      return Container(
        margin: EdgeInsets.all(3),
        width: currentIndex == index ? 20 : 10,
        height: 10,
        decoration: BoxDecoration(
            color:
                currentIndex == index ? const Color(0xff47ABFF) : Colors.grey,
            borderRadius: BorderRadius.circular(100)),
      );
    });
  }

  Widget indicator() {
    return Container(
      color: Colors.white,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: indicators(item_list.length, currentpage)),
    );
  }

  Widget maininfo() {
    return Container(
      width: size.width,
      padding: EdgeInsets.all(size.width * 0.1),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          maininfo_category(),
          maininfo_name(),
          maininfo_description()
        ],
      ),
    );
  }

  Widget maininfo_category() {
    return Container(
        padding: EdgeInsets.only(bottom: size.width * 0.05),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("카테고리 : ",
                style: TextStyle(color: Colors.black, fontFamily: "HanM"),
                textScaleFactor: 1.4),
            Text(category[selcategory],
                style: const TextStyle(color: Colors.black, fontFamily: "HanM"),
                textScaleFactor: 1.4)
          ],
        ));
  }

  Widget maininfo_name() {
    return Container(
        padding: EdgeInsets.only(bottom: size.width * 0.05),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("제품명 : ",
                style: TextStyle(color: Colors.black, fontFamily: "HanM"),
                textScaleFactor: 1.4),
            Text(_itemnamelist[getnum]!,
                style: const TextStyle(color: Colors.black, fontFamily: "HanM"),
                textScaleFactor: 1.4)
          ],
        ));
  }

  Widget maininfo_description() {
    return Container(
        padding: EdgeInsets.all(size.width * 0.05),
        child: Text(_itemdescriptionlist[getnum]!,
            style: const TextStyle(color: Colors.black, fontFamily: "HanR"),
            textScaleFactor: 1.2));
  }

  Widget button_container() {
    return Container(
      margin: EdgeInsets.all(size.height * 0.01),
      width: size.width * 0.8,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          movebutton(),
          Container(
            color: Colors.black12,
            width: 2,
            height: size.height * 0.03,
          ),
          likebutton(getnum)
        ],
      ),
    );
  }

  Widget likebutton(key_val) {
    bool isLiked = like_press[key_val];
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: IconButton(
          key: Key(key_val),
          onPressed: () async {
            print(key_val);
            setState(() {
              like_press[key_val] = !isLiked;
            });
            await setStorage();
          },
          icon: like_press[key_val]
              ? Icon(CupertinoIcons.heart_fill,
                  color: Colors.red, size: size.width * 0.07)
              : Icon(CupertinoIcons.heart,
                  color: Colors.black38, size: size.width * 0.07)),
    );
  }

  Widget movebutton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: const Color(0xff47ABFF),
      ),
      child: TextButton(
        onPressed: () {
          move();
        },
        child: const Text(
          "상세 페이지 이동",
          style: TextStyle(color: Colors.white, fontFamily: "HanM"),
          textScaleFactor: 1.5,
        ),
      ),
    );
  }
}
