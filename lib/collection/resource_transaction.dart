import 'package:ecocycle/collection/resource_transaction_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import '../main/mainpage.dart';
import '../server/http_post.dart';
import 'package:get/get.dart';
import '../customlibrary/textanimation.dart';
import '../user/User_Storage.dart';
import 'dart:convert';
import './first.dart';
import 'dart:async';
import 'dart:io';

Future<String> getAddress() async {
  late String _result;
  List<dynamic>? addresslist = await getAddressData();
  Map<String, dynamic> address = addresslist![0];
  print(address);
  _result =
      "${address['address1']} ${address['address2']} ${address['address3']} ${address['address4']}";
  return _result;
}

class transactionpage extends StatefulWidget {
  @override
  _transactionpage createState() => _transactionpage();
}

class _transactionpage extends State<transactionpage>
    with TickerProviderStateMixin {
  late Size size;
  late TabController _tabController;
  late PageController _pageController;
  late List<ScrollController> _scrollControllers;

  late String _token;
  late List<double> _previousScrollOffset;
  int _data1length = 0;
  List<String> _addresslist1 = [];
  List<String> _datelist1 = [];
  List<String> _imagepathlist1 = [];
  List<String> _datalist1 = [];
  List<String> _titlelist1 = [];
  late Map<String, dynamic> _data1;
  int page1 = 0;
  late int totalpage1 = 1;
  bool _isLoading1 = true; // 데이터를 로딩 중인지 여부를 나타내는 변수

  int _data2length = 0;
  List<String> _addresslist2 = [];
  List<String> _datelist2 = [];
  List<String> _imagepathlist2 = [];
  List<String> _datalist2 = [];
  List<String> _titlelist2 = [];
  late Map<String, dynamic> _data2;
  int page2 = 0;
  late int totalpage2 = 1;
  bool _isLoading2 = true; // 데이터를 로딩 중인지 여부를 나타내는 변수

  bool tabselect = true;
  bool indexIsChanging = false;

  String _address = "";
  String path = "";

  void initlists() {
    _isLoading1 = true; // 데이터를 로딩 중인지 여부를 나타내는 변수
    _isLoading2 = true; // 데이터를 로딩 중인지 여부를 나타내는 변수
  }

  Future<void> getData() async {
    _address = await getAddress();
    _token = await getToken();
  }

  Future<String> CalData(String serverdate) async {
    DateTime dateTime = DateTime.parse(serverdate);
    DateTime now = DateTime.now();

    Duration difference = now.difference(dateTime);
    String date = "";
    if (difference.inDays >= 7) {
      int weeks = difference.inDays ~/ 7;
      date = '${weeks}주 전';
      print('${weeks}주 전');
    } else if (difference.inDays >= 30) {
      int months = difference.inDays ~/ 30;
      date = '${months}달 전';
      print('${months}달 전');
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

  Future<void> refreshData1() async {
    // 서버에서 데이터를 받아오는 비동기 작업을 수행
    _datelist1 = [];
    _imagepathlist1 = [];
    _addresslist1 = [];
    _datalist1 = [];
    _titlelist1 = [];
  }

  Future<void> refreshData2() async {
    // 서버에서 데이터를 받아오는 비동기 작업을 수행
    _datelist2 = [];
    _imagepathlist2 = [];
    _addresslist2 = [];
    _datalist2 = [];
    _titlelist2 = [];
  }

  Future<void> fetchData1() async {
    // 서버에서 데이터를 받아오는 비동기 작업을 수행
    _data1 = await getSaleResources(page1, await getToken());
    setState(() {
      _data1length = _data1["pagination"]["cuurentElement"];
    });
    print(_data1length);
    page1 = _data1["pagination"]["page"] + 1;
    totalpage1 = _data1["pagination"]["totalpage"];
    for (var data in _data1["body"]) {
      String dataname = "";
      List<String> settile = [];
      for (var list in data["list"]) {
        dataname += "${list["resourceNum"]}, ";
        settile.add(list["resourceNum"]);
      }
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
      _datelist1.add(await CalData(data["id"]["date"]));
      _imagepathlist1.add(data["list"][0]["imagePath"]);
      _addresslist1.add(data["list"][0]["address"]);
      _datalist1.add(dataname);
      _titlelist1.add(title1);
    }
  }

  Future<void> fetchData2() async {
    // 서버에서 데이터를 받아오는 비동기 작업을 수행
    List<dynamic> _dataList2 = await getBuyPage();
    // 받아온 데이터를 리스트에 추가
    for (Map<String, dynamic> data in _dataList2) {
      _addresslist2.add(data['address']);
      for (String imageinfo in jsonDecode(data['resultPath'])) {}
    }
  }

  void move(where) {
    if (where == "home") {
      Get.to(() => mainpage());
    } else if (where == "register1") {
      //collection2_main();
      Get.to(() => collection1());
    } else if (where == "register2") {
      print("register2");
    }
  }

  void ontabmove(var data){
    Get.to(() => transactiondetailpage(), arguments: [1, data]);
  }


  @override
  void initState() {
    super.initState();
    initlists();
    getData();
    _previousScrollOffset = [0, 0];
    fetchData1().then((_) {
      setState(() {
        _isLoading1 = false; // 로딩 완료 플래그 설정
      });
    });

    fetchData2().then((_) {
      setState(() {
        _isLoading2 = false; // 로딩 완료 플래그 설정
      });
    });

    _tabController = TabController(length: 2, vsync: this); // 탭의 개수와 vsync 설정
    _pageController = PageController();
    _tabController.addListener(onTabPressed);

    _scrollControllers = List<ScrollController>.generate(
      2,
      (index) => ScrollController(),
    );

    _scrollControllers[0].addListener(() async {
      // 스크롤이 끝에 도달하면 추가 데이터 요청
      if (_scrollControllers[0].position.pixels ==
          _scrollControllers[0].position.maxScrollExtent) {
        if (totalpage1 <= page1) {
        } else {
          await fetchData1();
        }
      }
    });

    _scrollControllers[1].addListener(() async {
      // 스크롤이 끝에 도달하면 추가 데이터 요청
      if (_scrollControllers[1].position.pixels ==
          _scrollControllers[1].position.maxScrollExtent) {
        if (totalpage2 <= page2) {
        } else {
          await fetchData2();
        }
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose(); // TabController 정리
    _pageController.dispose();
    _scrollControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void onTabPressed() {
    if (_tabController.indexIsChanging) {
      setState(() {
        indexIsChanging = true;
      });
    } else {
      setState(() {
        tabselect = !tabselect;
        indexIsChanging = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: appbar(),
          body: _mainpage2(),
          floatingActionButton: actionbutton(),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        ));
  }

  AppBar appbar() {
    return AppBar(
      toolbarHeight: size.height * 0.05,
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: const IconThemeData(
        color: Colors.black, //change your color here
      ),
      title: Text("자원 거래",
          style: TextStyle(color: Colors.black, fontFamily: "HanM", fontSize: size.width*0.04 )),
      centerTitle: true,
      bottom: PreferredSize(
          preferredSize: Size.fromHeight(size.height * 0.1),
          child: Column(
            children: [
              TextButton(
                onPressed: () {
                  print("tab address");
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
                        style: const TextStyle(
                            color: Colors.black, fontFamily: "HanM"),
                        textScaleFactor: 1), //서버에서 가져온 최상위 값
                    const Icon(Icons.arrow_drop_down, color: Color(0xff47ABFF))
                  ],
                ),
              ),
              TabBar(
                indicatorColor: const Color(0xff47ABFF),
                controller: _tabController,
                overlayColor:
                    const MaterialStatePropertyAll(Colors.transparent),
                onTap: (index) {
                  _pageController.animateToPage(index,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut);
                },
                tabs: const <Widget>[
                  Tab(
                      child: Text("판매하기",
                          style: TextStyle(
                              color: Colors.black, fontFamily: "HanM"))),
                  Tab(
                      child: Text("구매하기",
                          style: TextStyle(
                              color: Colors.black, fontFamily: "HanM"))),
                ],
              ),
            ],
          )),
      actions: <Widget>[
        Padding(
            padding: EdgeInsets.only(right: size.width * 0.05),
            child: IconButton(
                onPressed: () {
                  //move("home");
                },
                icon: const Icon(Icons.search),
                color: Colors.black)),
      ],
    );
  }

  Widget _mainpage2() {
    return PageView(
      controller: _pageController,
      onPageChanged: (index) {
        _tabController.animateTo(index);
      },
      children: <Widget>[firstTab(), secondTab()],
    );
  }

  Widget _mainpage() {
    return TabBarView(
      controller: _tabController,
      children: <Widget>[firstTab(), secondTab()],
    );
  }

  Widget firstTab() {
    return _isLoading1
        ? Center(child: BouncingTextAnimation())
        : _data1length == 0
            ? RefreshIndicator(
                onRefresh: () async {
                  page1 = 0;
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
                  page1 = 0;
                  await refreshData1();
                  await fetchData1().then((_) {
                  });
                },
                child: SizedBox(
                  height: size.width * 0.4 * (_data1length),
                  child: ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    controller: _scrollControllers[0],
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
                            ontabmove(_data1["body"][index]);
                          },
                          child: Container(
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                      top: BorderSide(
                                    color: Colors.black12, // 적용할 border 색상
                                    width: 1.0, // border 너비
                                  ))),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: size.width * 0.4,
                                    height: size.width * 0.4,
                                    child: Center(
                                      child: Container(
                                        padding:
                                            EdgeInsets.all(size.width * 0.01),
                                        child: FutureBuilder(
                                          future: fetchImage(
                                              _imagepathlist1[index]),
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
                                  ),
                                  Container(
                                    width: size.width * 0.5,
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
                                            _titlelist1[index],
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontFamily: "HanB"),
                                            textScaleFactor: 1.3,
                                          ),
                                        ),
                                        Container(
                                          padding:
                                              EdgeInsets.all(size.width * 0.01),
                                          child: Text(
                                            _addresslist1[index],
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontFamily: "HanM"),
                                            textScaleFactor: 1,
                                          ),
                                        ),
                                        Container(
                                          padding:
                                              EdgeInsets.all(size.width * 0.01),
                                          child: Text(
                                            _datelist1[index],
                                            style: const TextStyle(
                                                color: Colors.black26,
                                                fontFamily: "HanM"),
                                            textScaleFactor: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                        );
                      }
                    },
                  ),
                ),
              );
  }

  Widget secondTab() {
    return _isLoading2
        ? Center(child: BouncingTextAnimation())
        : _data2length == 0
            ? RefreshIndicator(
                onRefresh: () async {
                  page2 = 0;
                  await refreshData2();
                  await fetchData2().then((_) {
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
                  page2 = 0;
                  await refreshData2();
                  await fetchData2().then((_) {
                  });
                },
                child: SizedBox(
                  height: size.width * 0.4 * (_data2length),
                  child: ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    controller: _scrollControllers[1],
                    itemCount: _data2length,
                    itemBuilder: (context, index) {
                      if (index == _data2length) {
                        // 마지막 아이템일 경우 로딩 표시 위젯 표시
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(child: BouncingTextAnimation()),
                        );
                      } else {
                        // 데이터 아이템을 표시
                        return GestureDetector(
                          onTap: () {
                            print(_data2["body"][index]);

                          },
                          child: Container(
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                      top: BorderSide(
                                    color: Colors.black12, // 적용할 border 색상
                                    width: 1.0, // border 너비
                                  ))),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: size.width * 0.5,
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
                                            _titlelist2[index],
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontFamily: "HanB"),
                                            textScaleFactor: 1.3,
                                          ),
                                        ),
                                        Container(
                                          padding:
                                              EdgeInsets.all(size.width * 0.01),
                                          child: Text(
                                            _addresslist2[index],
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontFamily: "HanM"),
                                            textScaleFactor: 1,
                                          ),
                                        ),
                                        Container(
                                          padding:
                                              EdgeInsets.all(size.width * 0.01),
                                          child: Text(
                                            _datelist2[index],
                                            style: const TextStyle(
                                                color: Colors.black26,
                                                fontFamily: "HanM"),
                                            textScaleFactor: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                        );
                      }
                    },
                  ),
                ),
              );
  }

  Widget actionbutton() {
    return ElevatedButton(
      onPressed: indexIsChanging
          ? null
          : () {
              // 플로팅 액션 버튼 클릭 시 동작할 내용
              if (tabselect) {
                move("register1");
              } else {
                move("register2");
              }
            },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // 버튼의 모서리 반경 설정
        ),
        backgroundColor: Color(0xff47ABFF),
        padding: EdgeInsets.all(size.width * 0.04), // 버튼의 내부 padding 설정
        elevation: 5.0, // 그림자 효과 설정
        // 원하는 스타일 속성 추가
      ),
      child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add),
                SizedBox(
                    width:
                        size.width * 0.01), // 아이콘과 텍스트 사이의 간격을 위해 SizedBox 추가
                const Text('자원 등록하기',
                    style: TextStyle(color: Colors.white, fontFamily: "HanB")),
              ],
            ),
    );
  }
}
