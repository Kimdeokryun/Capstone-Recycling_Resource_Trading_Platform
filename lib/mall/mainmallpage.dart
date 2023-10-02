import 'dart:convert';

import 'package:ecocycle/customlibrary/textanimation.dart';
import 'package:ecocycle/mall/malldetailpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:ui';

import '../user/User_Storage.dart';

class mainmallpage extends StatefulWidget {
  @override
  _mainmallpage createState() => _mainmallpage();
}

class _mainmallpage extends State<mainmallpage> {
  late Size size;
  bool isloading = true;


  List item_list = ['assets/image/아이템1.png', 'assets/image/아이템2.png'];
  Map<String, dynamic> like_press = {};

  late Icon heart_icon = Icon(CupertinoIcons.heart, color: Colors.black38, size: size.width*0.07);

  int selcategory = 0;
  List category = ["생활/건강", "가구/인테리어", "패션잡화", "가전제품", "전자제품"];

  Future<void> setStorage() async {
    String val1 = jsonEncode(MallLike(like_press["item0"], like_press["item1"], like_press["item2"], like_press["item3"]));
    await storage.write(key: 'MallLike', value: val1);
  }

  Future<void> getdata() async {
    like_press = (await getMallLike())!;
    print(like_press);
  }

  void movepage(key_val) async {
    Get.to(malldetailpage(), arguments: [key_val, selcategory]);
  }

  @override
  void initState() {
    super.initState();
    getdata().then((_){
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
      body: SingleChildScrollView(
        child: isloading ? BouncingTextAnimation() : mainbody(),
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
      title: const Text("제품몰",
          style: TextStyle(
              color: Colors.black,
              fontFamily: "HanM"), textScaleFactor: 1.1,),
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
        children: [ad(), category_selection(), item_table()],
      ),
    );
  }

  Widget ad() {
    return Container(
      width: size.width,
      color: Colors.black26,
      child: Image(image: AssetImage("assets/image/ecocyclemall.png")),
    );
  }

  Widget category_selection() {
    return Container(
      margin: EdgeInsets.only(top: size.width*0.03, bottom: size.width*0.03),
      height: size.height*0.05,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.only(left:size.width*0.01, right: size.width*0.01),
          itemCount: category.length,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(right: 10),
              child: ElevatedButton(
                onPressed: (){
                  setState(() {
                    selcategory = index;
                  });
                },
                style: index != selcategory ? ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
                    elevation: MaterialStateProperty.all(0),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.0),
                          side: const BorderSide(color: Color(0xff47ABFF), width: 1),
                        )
                    )
                ): ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(const Color(0xff47ABFF)),
                    overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
                    elevation: MaterialStateProperty.all(0),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.0),
                          side: const BorderSide(color: Color(0xff47ABFF), width: 1),
                        )
                    )
                ),
                child: Text(category[index], style: TextStyle(
                    color: index != selcategory ? Colors.black : Colors.white,
                    fontFamily: "HanM"), textScaleFactor: 0.9,),
              ),
            );
          }
      ),
    );
  }



  Widget item_table() {
    return Container(
      width: size.width,
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              item("item0", "친환경 반려견 터그", item_list[0]),
              item("item1","친환경 애완견 터그", item_list[1])
            ],
          ),
          Container(
            width: size.width,
            height: 3,
            color: Colors.black12,
          ),
          Row(
            children: [
              item("item2","친환경 애완견 장난감", item_list[1]),
              item("item3","친환경 반려견 장난감", item_list[0])
            ],
          )
        ],
      ),
    );
  }

  Widget item(key_val, name, item_url) {
    bool isLiked = like_press[key_val];
    return Container(
      key: Key(key_val),
      padding:
          EdgeInsets.only(top: size.height * 0.02, bottom: size.height * 0.01),
      width: size.width * 0.5,
      color: Colors.white,
      child: Stack(
        children: [
          GestureDetector(
            onTap: (){
              movepage(key_val);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image(image: AssetImage(item_url)),
                Container(
                  padding: EdgeInsets.all(size.width*0.02),
                  child: Text(name,
                      style: const TextStyle(
                          fontFamily: "HanM",
                          color: Colors.black), textScaleFactor: 1,
                      textAlign: TextAlign.center),
                ),
              ],
            ),
          ),
          Positioned(
              bottom: size.height*0.02,
              right: size.width*0.05,
              child: IconButton(
                key: Key(key_val),
                onPressed: () async {
                  print(key_val);
                  setState(() {
                    like_press[key_val] = !isLiked;
                  });
                  await setStorage();
                },
                icon: like_press[key_val] ? Icon(CupertinoIcons.heart_fill,color :
                Colors.red,size:size.width*0.07)
                    : Icon(CupertinoIcons
                    .heart,color :
                Colors.black38,size:size.width*0.07)))
        ],
      ),
    );
  }
}
