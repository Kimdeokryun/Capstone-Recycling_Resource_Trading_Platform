import 'package:ecocycle/main/usagepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:ui';
import '../customlibrary/textanimation.dart';
import '../server/http_post.dart';
import '../user/User_Storage.dart';
import 'editmypage.dart';
import 'mainpage.dart';
import 'package:intl/intl.dart';

class usagepageUI extends StatefulWidget {
  @override
  _usagepageUI createState() => _usagepageUI();
}

class _usagepageUI extends State<usagepageUI> {
  late Size size;
  late ScrollController _scrollController;
  bool _isLoading = true;
  String _token = "";


  late Map<String, dynamic> _userdata;
  late Map<String, dynamic> temp;
  late List<dynamic> _data1;
  late List<dynamic> _data2;

  late String _phonenum;

  int _data1length = 0;
  List<String> _addresslist1 = [];      // 주소
  List<String> _datelist1 = [];         // 날짜
  List<String> _realdatelist1 = [];         // 날짜
  List<String> _titlelist1 = [];        // 제목
  List<String> _statuslist1 = [];        // 상태 (거래 완료 및 거래 중)

  List<List<String>> _imagepathlist1 = [];    // 이미지
  List<List<int>> _numlist1 = [];    // 자원 수
  List<List<String>> _datalist1 = [];         // 자원 명

  void move(where, index) {
    if(where == "usagedetailpage")
    {
      Get.to(usagepage() ,arguments: [_datalist1[index], _realdatelist1[index], _imagepathlist1[index], _addresslist1[index], _statuslist1[index], _numlist1[index]]);
    }
  }

  Future<void> getdata() async {
    _userdata = (await getUserData())!;
    _token = await getToken();
    _phonenum = _userdata["phonenumber"];
  }

  Future<void> refreshData1() async {
    // 서버에서 데이터를 받아오는 비동기 작업을 수행
    _datelist1 = [];
    _realdatelist1 = [];
    _imagepathlist1 = [];
    _addresslist1 = [];
    _datalist1 = [];
    _titlelist1 = [];
    _statuslist1 = [];
    _numlist1 = [];    // 자원 수
  }

  Future<String> CalData(String Usagedate) async {
    DateTime dateTime = DateTime.parse(Usagedate);
    DateFormat formatter = DateFormat('yyyy년 M월 d일');
    String formattedDate = formatter.format(dateTime);
    return formattedDate;
  }

  Future<String> RealCalData(String Usagedate) async {
    DateTime dateTime = DateTime.parse(Usagedate);
    DateFormat formatter = DateFormat('yyyy년 M월 d일 a K시 m분', 'ko_KR');
    String formattedDate = formatter.format(dateTime);
    return formattedDate;
  }

  Future<void> fetchData1() async {
    // 서버에서 데이터를 받아오는 비동기 작업을 수행
    temp = await getmyUsage(_phonenum, 0, _token);
    _data1 = temp["api"]["body"];
    _data2 = temp["api2"]["body"];
    _data1length = (_data1+_data2).length;
    print(_data1);
    print(_data2);

    for (var data in _data1+_data2 ){
      // title 정하기   (data를 기반으로)
      String dataname = "";
      List<String> settile = [];
      List<String> names = [];
      List<String> paths = [];
      List<int> nums = [];

      for (var list in data["list"]) {
        dataname += "${list["resourceNum"]}, ";
        settile.add(list["resourceNum"]);

        names.add(list["resourceNum"]);
        if (list["imagePath"] == null){

        }
        else{
          paths.add(list["imagePath"]);
        }
        nums.add(list["num"]);
      }

      // title 길이 지정
      Set<String> settiles = Set<String>.from(settile);
      settile = settiles.toList();
      late String title1;
      if (settile.length > 2) {
        title1 = "${settile[0]} 외 ${settile.length - 1}건";
      } else if (settile.length == 2) {
        title1 = "${settile[0]}, ${settile[1]}";
      } else {
        title1 = settile[0];
      }
      // 날짜 수정 예정
      _datelist1.add(await CalData(data["createdAt"]));
      _realdatelist1.add(await RealCalData(data["createdAt"]));
      _addresslist1.add(data["list"][0]["address"]);
      _titlelist1.add(title1);

      if(data["resourceStates"] == "COMPLETED") {
        _statuslist1.add("거래 완료");
      }
      else{
        _statuslist1.add("거래 중");
      }



      _numlist1.add(nums);
      _imagepathlist1.add(paths);
      _datalist1.add(names);
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    getdata().then((_)
    {
      fetchData1().then((_) {
        setState(() {
          _isLoading = false; // 로딩 완료 플래그 설정
        });
        print(_datelist1);
        print(_addresslist1);
        print(_datalist1);
        print(_titlelist1);
        print(_imagepathlist1);
        print(_numlist1);
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
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

    return mainWidget();
  }

  Widget mainWidget() {
    return _isLoading
        ? Container(
      color: Colors.white,
      child: Center(child: BouncingTextAnimation()),
    )
        : (_data1+_data2).isEmpty
        ? RefreshIndicator(
      onRefresh: () async {
        await refreshData1();
        await fetchData1().then((_) {
        });
      },
      child: ListView(
        children: [
          SizedBox(
            height: size.height * 0.7,
            child: const Center(
              child: Text(
                "데이터가 없습니다.",
                style: TextStyle(
                    color: Colors.black38, fontFamily: "HanM"),
                textScaleFactor: 2,
              ),
            ),
          ),
        ],
      ),
    )
        : RefreshIndicator(
      onRefresh: () async {
        await refreshData1();
        await fetchData1().then((_) {
        });
      },
      child: SizedBox(
        height: size.width * 0.41 * (_data1length),
        child: Container(
          color: Colors.black12,
          child: ListView.builder(
            physics: const ClampingScrollPhysics(),
            controller: _scrollController,
            itemCount: _data1length,
            itemBuilder: (context, index) {
              if (index == _data1length) {
                // 마지막 아이템일 경우 로딩 표시 위젯 표시
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(child: BouncingTextAnimation()),
                );
              } else {
                // 데이터 아이템을 표시
                return GestureDetector(
                  onTap: () {
                    print("onTap: $index");
                    move("usagedetailpage", index);
                  },
                  child: Container(
                      margin: EdgeInsets.all(size.width*0.03),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
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
                                    _datelist1[index],
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontFamily: "HanR"),
                                    textScaleFactor: 1,
                                  ),
                                ),
                                Container(
                                  padding:
                                  EdgeInsets.all(size.width * 0.02),
                                  child: Text(
                                    _addresslist1[index],
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontFamily: "HanB"),
                                    textScaleFactor: 1.2,
                                  ),
                                ),
                                Container(
                                  padding:
                                  EdgeInsets.all(size.width * 0.02),
                                  child: Text(
                                    _titlelist1[index],
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontFamily: "HanM"),
                                    textScaleFactor: 1.1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(size.width*0.05),
                            child: Text(_statuslist1[index], style: const TextStyle(
                                color: Color(0xff47ABFF),
                                fontFamily: "HanM"), textScaleFactor: 1,),
                          )
                        ],
                      )
                  ),
                );
              }
            },
          ),
        )
      ),
    );
  }
}
