import 'package:flutter/material.dart';
import '../customlibrary/textanimation.dart';
import '../server/http_post.dart';
import '../main/mainpage.dart';
import 'package:get/get.dart';
import '../user/User.dart';
import '../user/User_Storage.dart';
import './second.dart';
import 'dart:async';

import 'make_buy_page.dart';

class collection1 extends StatefulWidget {
  @override
  _collection1 createState() => _collection1();
}

class _collection1 extends State<collection1> {
  late Size size;
  late bool graphloaded = false;
  late final args;

  String _address = "";
  String _city = "";
  String _resource = "";
  late Future graphFuture = fetchGraph(_city, _resource);

  int selcategory = 0;

  String selection = "";
  String buttontext = "";
  String moveto = "";

  Future<void> getData() async {
    args  = await Get.arguments;
    selection = args[0];

    if(selection == "register1"){
      buttontext = "자원 사진 찍기";
      moveto = "camera";
    }
    else{
      buttontext = "자원 등록하기";
      moveto = "make_page";
    }

    _address = args[1];
    _city = args[2];
    _resource = "압축 (PE)";

    print(_address);
    print(_city);
  }

  List resources = ["압축 (PE)", "압축 (PET)", "압축 (PP)", "폐금속류 (알루미늄캔)", "폐금속류 (철스크랩)", "폐금속류 (철캔)", "폐유리병 (갈색)",
    "폐유리병 (백색)", "폐유리병 (청녹색)", "플레이크 (ABS)", "플레이크 (PE)", "플레이크 (PET무색)", "플레이크 (PET복합)",
    "플레이크 (PET유색)", "플레이크 (PP)", "플레이크 (PS)", "플레이크 (PVC)"];


  void move(where) {
    svaddress.set(_address);
    if (where == "home") {
      Get.offAll(() => mainpage(), arguments: [2]);
    }
    else if (where == "camera") {

      Get.to(() => CameraPage());
    }
    else if(where == "make_page") {

      Get.to(() => make_buy_page());
    }
  }

  void editmyaddress(){

  }


  @override
  void initState() {
    super.initState();
    getData().then((value) {
      setState(() {
        graphFuture = fetchGraph(_city, _resource);
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
    return isloading
        ? Center(
            child: BouncingTextAnimation(),
          )
        : Scaffold(
            appBar: appbar(),
            body: _mainpage(),
          );
  }

  AppBar appbar() {
    return AppBar(
      toolbarHeight: size.height * 0.05,
      backgroundColor: Colors.white,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
      ),
      iconTheme: const IconThemeData(
        color: Colors.black, //change your color here
      ),
      title: const Text("자원 등록",
          style: TextStyle(color: Colors.black, fontFamily: "HanM"),
          textScaleFactor: 1.2),
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(size.height * 0.05),
        child: Container(
          child: TextButton(
            onPressed: () {
              editmyaddress();
            }, //서버에서 가져온 값
            style: ButtonStyle(
                overlayColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                return Colors.transparent;
              },
            )),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_address,
                    style: TextStyle(color: Colors.black, fontFamily: "HanM"),
                    textScaleFactor: 1), //서버에서 가져온 최상위 값
              ],
            ),
          ),
        ),
      ),
      actions: <Widget>[
        Padding(
            padding: EdgeInsets.only(right: size.width * 0.06),
            child: IconButton(
                onPressed: () {
                  move("home");
                },
                icon: Icon(Icons.home),
                color: Colors.black))
      ],
    );
  }

  Widget _mainpage() {
    return Container(
      width: size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          pagebar(),
          pagebar_selection(),
          graphContainer(),
          graph_data_from(),
          button()
        ],
      ),
    );
  }

  Widget pagebar() {
    return Container(
      margin: EdgeInsets.all(size.width*0.03),
      child: Text("재활용 자원 가격", style: TextStyle(fontFamily: 'HanM'), textScaleFactor: 1.4),
    );
  }



  Widget pagebar_selection() {
    return Container(
      margin: EdgeInsets.only(bottom: size.width*0.03),
      height: size.height*0.05,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.only(left:size.width*0.01, right: size.width*0.01),
          itemCount: resources.length,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(right: 10),
              child: ElevatedButton(
                onPressed: (){
                  setState(() {
                    selcategory = index;
                  });
                  changeResource(resources[index]);
                },
                style: index != selcategory ? ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
                    elevation: MaterialStateProperty.all(0),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: const BorderSide(color: Color(0xff47ABFF), width: 2),
                        )
                    )
                ): ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(const Color(0xff47ABFF)),
                    overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
                    elevation: MaterialStateProperty.all(0),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: const BorderSide(color: Color(0xff47ABFF), width: 2),
                        )
                    )
                ),
                child: Text(resources[index], style: TextStyle(
                    color: index != selcategory ? Colors.black : Colors.white,
                    fontFamily: "HanM"), textScaleFactor: 1,),
              ),
            );
          }
      ),
    );
  }

  void changeResource(String newResource) {
    if (_resource != newResource) { // 리소스가 실제로 변경되었는지 확인
      setState(() {
        _resource = newResource;
        graphFuture = fetchGraph(_city, _resource); // 리소스가 변경되었을 때만 새로운 요청 수행
      });
    }
  }

  Widget graphContainer() {
    return Container(
      width: size.width * 0.9,
      height: size.height * 0.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 1,
          ),
        ],
      ),
      child: FutureBuilder(
        future: graphFuture,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              if (snapshot.data!.statusCode == 200) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    graphloaded = true;
                  });
                });
                return Image.memory(snapshot.data!.bodyBytes);
              } else {
                return const Center(
                  child: Text(
                    '해당 자원 정보가 없습니다.',
                    style: TextStyle(fontFamily: 'HanB'),
                    textScaleFactor: 1.3,
                  ),
                );
              }
            } else if (snapshot.hasError) {
              return const Center(
                child: Text(
                  '해당 자원 정보가 없습니다.',
                  style: TextStyle(fontFamily: 'HanB'),
                  textScaleFactor: 1.3,
                ),
              );
            }
          }
          return Center(
            child: BouncingTextAnimation(),
          );
        },
      ),
    );
  }

  Widget graph_data_from() {
    return Container(
      padding: const EdgeInsets.only(top: 2),
      width: size.width * 0.9,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          graphloaded
              ? const Text(
                  "데이터 출처: 한국환경공단",
                  style: TextStyle(fontFamily: 'HanM'),
                )
              : const Text(
                  "",
                  style: TextStyle(fontFamily: 'HanM'),
                )
        ],
      ),
    );
  }

  Widget button() {
    return Container(
      padding: EdgeInsets.only(top: size.height * 0.05),
      width: size.width * 0.8,
      height: size.height * 0.125,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color(0xff47ABFF),
        ),
        child: TextButton(
          onPressed: () {
            move(moveto);
          },
          child: Text(
            buttontext,
            style: const TextStyle(color: Colors.white, fontFamily: "HanM"),
            textScaleFactor: 1.5,
          ),
        ),
      ),
    );
  }
}
