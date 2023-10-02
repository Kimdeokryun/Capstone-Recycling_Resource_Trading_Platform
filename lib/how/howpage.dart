import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:ui';
import 'detailhowpage.dart';

class howpage extends StatefulWidget {
  @override
  _howpage createState() => _howpage();
}

class _howpage extends State<howpage> {
  late Size size;
  bool isloading = true;
  List image_list = ["assets/image/how/glass/001.png", "assets/image/how/metal/001.png",
    "assets/image/how/paper/001.png", "assets/image/how/plastic/001.png",
    "assets/image/how/poly/001.png", "assets/image/how/vinyl/001.png"];


  void getdata() async {
    setState(() {
      isloading = false;
    });
  }

  void movepage(val)
  {
    Get.to(() => detailhowpage(), arguments: [val] , transition: Transition.zoom);
  }

  @override
  void initState() {
    super.initState();
    getdata();
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
            appBar: mainappbar(),
            body: mainbody(),
          );
  }

  AppBar mainappbar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: const IconThemeData(
        color: Colors.black, //change your color here
      ),
      title: Text("이건 어떻게 버릴까?",
          style: TextStyle(
              color: Colors.black,
              fontFamily: "HanM",
              fontSize: size.width * 0.04)),
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
          maintitle(),
          image_table()
        ],
      ),
    );
  }

  Widget maintitle() {
    return Container(
        padding: EdgeInsets.only(
            top: size.height * 0.02, bottom: size.height * 0.03),
        width: size.width,
        color: Colors.white,
        child: Center(
          child: RichText(
              text: const TextSpan(children: [
                TextSpan(
                    text: "eco",
                    style: TextStyle(
                        color: Colors.black, fontFamily: 'HanM')),
                TextSpan(
                  text: "cycle",
                  style: TextStyle(color: Color(0xff47ABFF), fontFamily: 'HanM'),
                ),
                TextSpan(
                  text: " 과 함께 알아봐요!",
                  style: TextStyle(color: Colors.black, fontFamily: 'HanM'),
                ),
              ]),
              textScaleFactor: 1.5),
        ));
  }

  Widget image_table() {
    return Container(
      width: size.width,
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              image("1", image_list[0]),
              image("2", image_list[1])
            ],
          ),
          Container(
            width: size.width,
            height: 1,
            color: Colors.black12,
          ),
          Row(
            children: [
              image("3", image_list[2]),
              image("4", image_list[3])
            ],
          ),
          Container(
            width: size.width,
            height: 1,
            color: Colors.black12,
          ),
          Row(
            children: [
              image("5", image_list[4]),
              image("6", image_list[5])
            ],
          ),
        ],
      ),
    );
  }

  Widget image(key_val, image) {
    return GestureDetector(
      key: Key(key_val),
      onTap: () {
        //print(key_val);
        movepage(key_val);
      },
      child: Container(
          width: size.width * 0.5, child: Image(image: AssetImage(image))),
    );
  }
}
