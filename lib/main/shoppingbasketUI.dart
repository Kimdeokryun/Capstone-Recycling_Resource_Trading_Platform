import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:ui';

import '../customlibrary/CounterButton.dart';
import '../customlibrary/textanimation.dart';
import '../mall/malldetailpage.dart';
import '../user/User_Storage.dart';

class shoppingbasketUI extends StatefulWidget {
  @override
  _shoppingbasketUI createState() => _shoppingbasketUI();
}

class _shoppingbasketUI extends State<shoppingbasketUI> {
  late Size size;
  bool isloading = true;
  late ScrollController _scrollController;

  int _dataLength = 0;

  Map<String, dynamic> like_press = {};

  List item_list = ['item0', 'item1', 'item2', 'item3'];

  Map<String, String> origin_itemimage_list = {'item0':'assets/image/아이템1.png', 'item1':'assets/image/아이템2.png', 'item2':'assets/image/아이템2.png', 'item3':'assets/image/아이템1.png'};
  Map<String, String> origin_itemname_list = {'item0':'친환경 반려견 터그', 'item1':'친환경 애완견 터그', 'item2':'친환경 애완견 장난감', 'item3':'친환경 반려견 장난감'};
  //List itemname_list = ['item0', 'item1', 'item2', 'item3'];

  List itemimage_list = [];
  List itemname_list = [];


  Future<void> setStorage() async {
    String val1 = jsonEncode(MallLike(like_press["item0"], like_press["item1"], like_press["item2"], like_press["item3"]));
    await storage.write(key: 'MallLike', value: val1);
  }

  Future<void> getdata() async {
    like_press = (await getMallLike())!;
    print(like_press);

    setState(() {
      like_press.forEach((key, value) {
        if (value == true) {
          _dataLength++;
          itemimage_list.add(origin_itemimage_list[key]);
          itemname_list.add(origin_itemname_list[key]);
        }
      });
    });
  }

  void movepage(key_val) async {
    Get.to(malldetailpage(), arguments: [key_val, 0]);
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    getdata().then((_)
    {
      isloading = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery
        .of(context)
        .size;
    const SystemUiOverlayStyle overlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // 투명색
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(overlayStyle);
    });

    return mainbody();
  }

  Widget mainbody() {
    return isloading
        ? Center(child: BouncingTextAnimation())
        : _dataLength == 0 ? ListView(
      children: [
        SizedBox(
          height: size.height * 0.7,
          child: const Center(
            child: Text(
              "장바구니에 담긴 물품이 없습니다.",
              style: TextStyle(
                  color: Colors.black38, fontFamily: "HanM"),
              textScaleFactor: 1.5,
            ),
          ),
        ),
      ],
    ) : SizedBox(
        height: size.width * 0.5 * (_dataLength),
        child: Container(
          color: Colors.white,
          child: ListView.builder(

            physics: const ClampingScrollPhysics(),
            controller: _scrollController,
            itemCount: _dataLength,
            itemBuilder: (context, index) {
              if (index == _dataLength) {
                // 마지막 아이템일 경우 로딩 표시 위젯 표시
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(child: BouncingTextAnimation()),
                );
              } else {
                // 데이터 아이템을 표시
                return GestureDetector(
                  onTap: () {
                    print("onTap: " + item_list[index]);
                    movepage(item_list[index]);
                  },
                  child: Container(
                      margin: EdgeInsets.all(size.width*0.03),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.black12,
                          width: 2
                        )
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: size.width * 0.4,
                            height: size.width * 0.4,
                            child: Center(
                              // 이미지
                              child: Image(image: AssetImage(itemimage_list[index])),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(size.width*0.04),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding:
                                  EdgeInsets.all(size.width * 0.02),
                                  child: Text(
                                    itemname_list[index],
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontFamily: "HanR"),
                                    textScaleFactor: 1,
                                  ),
                                ),
                                CounterButton()
                              ],
                            ),
                          ),
                        ],
                      )
                  ),
                );
              }
            },
          ),
        )
    );
  }




}
