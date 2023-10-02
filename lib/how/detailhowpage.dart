import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:ui';

class detailhowpage extends StatefulWidget {
  @override
  _detailhowpage createState() => _detailhowpage();
}

class _detailhowpage extends State<detailhowpage> {
  late Size size;
  late String hownum;
  late String directory;
  late String appbar_name;
  late Color indicator_color;

  int currentpage = 0;
  int numofimage = 3;
  bool isloading = true;

  List image_list = ["001.png", "002.png", "003.png", "004.png"];
  List color_list = [Color(0xff329886), Color(0xffD94925),
    Color(0xff125E9E),Color(0xff5D6DBE),
    Color(0xff692498),Color(0xffFD6F22),Color(0xff47ABFF)];

  late List<String> images = [];

  void getdata() async {
    setState(() {
      isloading = false;
      hownum = Get.arguments[0];
      switch(hownum){
        case "1":
          directory = "assets/image/how/glass/";
          appbar_name = "유리";
          indicator_color = color_list[0];
          break;
        case "2":
          directory = "assets/image/how/metal/";
          appbar_name = "금속";
          indicator_color = color_list[1];
          break;
        case "3":
          directory = "assets/image/how/paper/";
          appbar_name = "종이";
          indicator_color = color_list[2];
          numofimage = 4;
          break;
        case "4":
          directory = "assets/image/how/plastic/";
          appbar_name = "플라스틱";
          indicator_color = color_list[3];
          break;
        case "5":
          directory = "assets/image/how/poly/";
          appbar_name = "스티로폼";
          indicator_color = color_list[4];
          break;
        case "6":
          directory = "assets/image/how/vinyl/";
          appbar_name = "비닐";
          indicator_color = color_list[5];
          break;
        case "7":
          directory = "assets/image/how/ecocycle/";
          appbar_name = "ecocycle이란?";
          indicator_color = color_list[6];
          numofimage = 4;

      }
      for(int i =0; i<numofimage; i++)
      {
        images.add(directory+image_list[i]);
      }
    });
  }

  List<Widget> indicators(listLength, currentIndex) {
    return List<Widget>.generate(listLength, (index) {
      return Container(
        margin: EdgeInsets.all(3),
        width: currentIndex == index ? 20 : 10,
        height: 10,
        decoration: BoxDecoration(
            color: currentIndex == index ? indicator_color : Colors.grey,
            borderRadius: BorderRadius.circular(100)),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    getdata();
    //print(images.length);
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
      title: Text("$appbar_name 분리 배출 방법",
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
        mainAxisAlignment: MainAxisAlignment.center, // 세로 방향 중앙 정렬
        crossAxisAlignment: CrossAxisAlignment.center, // 가로 방향 중앙 정렬
        children: [
          SizedBox(height: size.height*0.1),
          slider(),
          SizedBox(height: 10),
          indicator()
        ],
      ),
    );
  }

  Widget slider() {
    return CarouselSlider(
      options: CarouselOptions(
        aspectRatio: 1/1, // 이미지 화면 비율
        autoPlay: true, // 자동 재생
        enlargeCenterPage: true, // 가운데 이미지 확대
        autoPlayInterval: Duration(seconds: 3), // 자동 재생 간격
        enableInfiniteScroll: false,
        viewportFraction: 1.0, // 이미지가 화면 너비에 꽉 차게 표시됨
        onPageChanged: (index, reason) {
          setState(() {
            currentpage = index;
          });
        },
      ),
      items: images.map((String imageUrl) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: size.width,
              child: Image(image: AssetImage(imageUrl), fit: BoxFit.contain),
            );
          },
        );
      }).toList(),
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
}
