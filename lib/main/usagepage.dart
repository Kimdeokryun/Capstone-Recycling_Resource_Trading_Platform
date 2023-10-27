import 'package:ecocycle/customlibrary/textanimation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:ui';
import '../server/http_post.dart';
import '../start/ReadyScreen.dart';
import '../user/User_Storage.dart';
import 'dart:io';

class usagepage extends StatefulWidget {
  @override
  _usagepage createState() => _usagepage();
}

class _usagepage extends State<usagepage> {
  late Size size;
  late final args;

  List<Future> imageFuture = [];

  bool isloading = true;

  late String _addresslist1 = "";      // 주소
  late String _datelist1 = "";        // 날짜
  late String _statuslist1 = "";        // 상태 (거래 완료 및 거래 중)

  List<String> _imagepathlist1 = [];    // 이미지
  List<int> _numlist1 = [];         // 자원 수
  List<String> _datalist1 = [];         // 자원 명

  Future<void> getdata() async {
    args = Get.arguments;

    _datalist1 = args[0];
    _datelist1 = args[1];
    _imagepathlist1 = args[2];
    _addresslist1 = args[3];
    _statuslist1 = args[4];
    _numlist1 = args[5];

    print(_datelist1);
    print(_addresslist1);
    print(_statuslist1);

    print(_datalist1);
    print(_imagepathlist1);
    print(_numlist1);
  }

  @override
  void initState() {
    super.initState();
    getdata().then((_){
      setState(() {
        for(String imagepath in _imagepathlist1)
        {
          imageFuture.add(fetchImage(imagepath));
        }
        setState(() {
          isloading = false;
        });
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: mainappbar(),
      body: isloading
          ? Center(
        child: BouncingTextAnimation(),
      )
          : mainbody(),
    );
  }

  AppBar mainappbar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: const IconThemeData(
        color: Colors.black, //change your color here
      ),
      title: const Text("자원 거래 상세 내역",
          style: TextStyle(color: Colors.black, fontFamily: "HanM"), textScaleFactor: 1.1,),
      centerTitle: true,
    );
  }

  Widget mainbody() {
    return Container(
      color: Colors.white,
      width : size.width,
      // height : size . height , // remove this line
      child : Column (
        mainAxisAlignment : MainAxisAlignment . start ,
        crossAxisAlignment : CrossAxisAlignment . start ,
        children : [
          Container ( width : size.width , height : 2 , color : Colors.black12 ,) ,
          maininfo() ,
          Container ( width : size.width , height : 2 , color : Colors.black12 ,) ,
          resourcestitle(),
          isloading ? BouncingTextAnimation() : resourcesinfo(),
        ] ,
      ) ,
    );
  }
  
  Widget maininfo()
  {
    return Container(
      width: size.width,
      padding: EdgeInsets.all(size.width*0.1),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          maininfo_status(),
          maininfo_adress(),
          maininfo_date()
        ],
      ),
    );
  }

  Widget maininfo_status(){
    return Container(
      padding: EdgeInsets.only(bottom: size.width*0.05),
        child: _statuslist1 == "거래 중"? const Text("거래가 아직 진행 중이에요.", style: TextStyle(color: Color(0xff47ABFF), fontFamily: "HanB"),textScaleFactor: 1.2)
            : const Text("거래가 완료되었어요.", style: TextStyle(color: Color(0xff47ABFF), fontFamily: "HanB"),textScaleFactor: 1.2)
    );
  }
  Widget maininfo_adress(){
    return Container(
      padding: EdgeInsets.only(bottom: size.width*0.05),
      child: Text(_addresslist1, style: const TextStyle(color: Colors.black, fontFamily: "HanB"),textScaleFactor: 1.5),
    );
  }
  Widget maininfo_date(){
    return Container(
      padding: EdgeInsets.only(bottom: size.width*0.05),
      child: Text(_datelist1, style: const TextStyle(color: Colors.black, fontFamily: "HanM"),textScaleFactor: 1),
    );
  }

  Widget resourcestitle()
  {
    return _imagepathlist1.isNotEmpty ? Container(
      padding: EdgeInsets.only(left: size.width*0.1, top: size.width*0.05),
      width: size.width,
      color: Colors.white,
      child: const Text("판매 재활용 자원 정보", style: TextStyle(color: Colors.black, fontFamily: "HanM"),textScaleFactor: 1.5),

    ): Container(
      padding: EdgeInsets.only(left: size.width*0.1, top: size.width*0.05),
      width: size.width,
      color: Colors.white,
      child: const Text("구매 재활용 자원 정보", style: TextStyle(color: Colors.black, fontFamily: "HanM"),textScaleFactor: 1.5),

    );
  }

  Widget resourcesinfo()
  {
    return Container(
      width: size.width,
      color: Colors.white,
        padding: EdgeInsets.only(top: size.width*0.05),
      child: resources()
    );
  }

  Widget resources()
  {
    return SizedBox(
      width: size.width,
      height: size.width * 0.4 * (_datalist1.length),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(top: size.height*0.01),
        itemCount: _datalist1.length,
        itemBuilder: (context, index) {
          return Container(
            width: size.width,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _imagepathlist1.isNotEmpty ? Container(
                    margin: EdgeInsets.only(left:size.width*0.1),
                    width: size.width * 0.4,
                    height: size.width * 0.4,
                    child: Center(
                      // 이미지
                      child: Container(
                        padding: EdgeInsets.all(size.width * 0.01),
                        child: FutureBuilder(
                          future: imageFuture[index],
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
                  ): Container(
                    margin: EdgeInsets.only(left:size.width*0.1),
                    width: size.width * 0.2,
                    height: size.width * 0.15,
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(size.width * 0.01),
                        child: const Icon(Icons.recycling),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left:size.width*0.1),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [
                        Container(
                          padding:
                          EdgeInsets.all(size.width * 0.01),
                          child: Text(
                            _datalist1[index],
                            style: const TextStyle(
                                color: Colors.black,
                                fontFamily: "HanM"),
                            textScaleFactor: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ));
        },
      ),
    );
  }

}
