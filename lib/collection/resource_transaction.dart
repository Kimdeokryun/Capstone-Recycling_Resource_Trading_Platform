import 'package:ecocycle/collection/resource_transaction_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:remedi_kopo/remedi_kopo.dart';
import '../customlibrary/progressindicator.dart';
import '../main/mainpage.dart';
import '../server/http_post.dart';
import 'package:get/get.dart';
import '../customlibrary/textanimation.dart';
import '../user/User_Storage.dart';
import './first.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'addressDetailpage.dart';
import 'buy_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';

class transactionpage extends StatefulWidget {
  @override
  _transactionpage createState() => _transactionpage();
}

class _transactionpage extends State<transactionpage> with TickerProviderStateMixin {
  late Size size;
  late TabController _tabController;
  late PageController _pageController;
  late List<ScrollController> _scrollControllers;
  late TextEditingController _texteditcontroller;
  late KopoModel model;

  late String _token;
  late List<double> _previousScrollOffset;
  int _data1length = 0;
  List<String> _addresslist1 = [];
  List<String> _datelist1 = [];
  List<String> _imagepathlist1 = [];
  List<String> _datalist1 = [];
  List<String> _titlelist1 = [];
  List<Future> imageFuture1 = [];
  List<String> _idlist1 = [];

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
  List<String> _idlist2 = [];

  late Map<String, dynamic> _data2;
  int page2 = 0;
  late int totalpage2 = 1;
  bool _isLoading2 = true; // 데이터를 로딩 중인지 여부를 나타내는 변수

  bool tabselect = true;
  bool indexIsChanging = false;

  String _address = "";
  String _city = "";
  String _building = "";
  String path = "";

  String searching_address = "";
  String searching_building = "";
  int line = 0;
  bool isSearching = false;

  void initlists() {
    _isLoading1 = true; // 데이터를 로딩 중인지 여부를 나타내는 변수
    _isLoading2 = true; // 데이터를 로딩 중인지 여부를 나타내는 변수
  }

  Future<void> getmyAddress() async {
    List<dynamic>? addresslist = await getAddressData();
    Map<String, dynamic> address = addresslist![await getAddressNum()];
    _address = address['address'];
    _city = address['city'];
    _building = address['building'];
    print(_city);
    print(_address);
    print(_building);
  }

  Future<void> getData() async {
    getmyAddress();
    _token = await getToken();
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

  Future<void> refreshData1() async {
    // 서버에서 데이터를 받아오는 비동기 작업을 수행
    _datelist1 = [];
    _imagepathlist1 = [];
    imageFuture1 = [];
    _addresslist1 = [];
    _datalist1 = [];
    _titlelist1 = [];
    _idlist1 = [];
  }

  Future<void> refreshData2() async {
    // 서버에서 데이터를 받아오는 비동기 작업을 수행
    _datelist2 = [];
    _imagepathlist2 = [];
    _addresslist2 = [];
    _datalist2 = [];
    _titlelist2 = [];
    _idlist2 = [];
  }

  Future<void> fetchData1() async {
    // 서버에서 데이터를 받아오는 비동기 작업을 수행
    _data1 = await getSaleResources(page1, await getToken());
    print(_data1);


    page1 = _data1["pagination"]["page"] + 1;
    totalpage1 = _data1["pagination"]["totalpage"];

    for (var data in _data1["body"]) {
      if(data["resourceStates"] == "COMPLETED") {continue;}


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
      _idlist1.add(data["id"]);
      //날짜 수정 예정
      _datelist1.add(await CalData(data["createdAt"]));
      changeResource1(data["list"][0]["imagePath"]);
      _addresslist1.add(data["list"][0]["address"]);
      _datalist1.add(dataname);
      _titlelist1.add(title1);
    }

    setState(() {
      _data1length = _datalist1.length;
    });

  }

  Future<void> fetchData2() async {
    // 서버에서 데이터를 받아오는 비동기 작업을 수행

    _data2 = await getBuyResources(page2, await getToken());


    page2 = _data2["pagination"]["page"] + 1;
    totalpage2 = _data2["pagination"]["totalpage"];
    for (var data in _data2["body"]) {
      if(data["resourceStates"] == "COMPLETED") {continue;}

      String dataname = "";
      List<String> settile = [];
      for (var list in data["list"]) {
        dataname += "${list["resourceNum"]}, ";
        settile.add(list["resourceNum"]);
      }
      Set<String> settiles = Set<String>.from(settile);
      settile = settiles.toList();
      late String title2;
      if (settile.length > 2) {
        title2 = "${settile[0]} 외 ${settile.length - 1}건";
      } else if (settile.length == 2) {
        title2 = "${settile[0]}, ${settile[1]}";
      } else {
        title2 = settile[0];
      }

      _idlist2.add(data["id"]);
      //날짜 수정 예정
      _datelist2.add(await CalData(data["createdAt"]));
      _addresslist2.add(data["list"][0]["address"]);
      _datalist2.add(dataname);
      _titlelist2.add(title2);
    }
    setState(() {
      _data2length = _datalist2.length;
    });

  }

  void move(where) {
    if (where == "home") {
      Get.to(() => mainpage(), arguments: [2]);
    } else {
      //collection2_main();
      print(where);
      print(_city);
      print(_address);
      Get.to(() => collection1(), arguments: [where, _address, _city]);
    }
  }

  void ontabmove(String method, var data, String id) {
    if (method == "sale") {
      Get.to(() => transactiondetailpage(), arguments: [1, data, id]);
    } else {
      Get.to(() => buy_page(), arguments: [1, data, id]);
    }
  }

  Future<void> editmyaddress() async {
    setState(() {
      isSearching = true;
    });
    List<dynamic> addresslist = await getAddressData2();
    int selectaddress = await getAddressNum();
    print(addresslist);
    setState(() {
      isSearching = false;
    });
    Get.bottomSheet(isDismissible: true, isScrollControlled: true,
        StatefulBuilder(
      builder: (BuildContext context, StateSetter modalSetState) {
        return Container(
          alignment: Alignment.bottomCenter,
          height: size.height * 0.8,
          child: Container(
            width: size.width,
            height: size.height,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      top: size.height * 0.01, bottom: size.height * 0.01),
                  child: const Center(
                      child: Text("주소 설정",
                          style: TextStyle(
                              color: Colors.black, fontFamily: "HanB"),
                          textScaleFactor: 1.5)),
                ),
                // 로그인 방법 선택 부분과 거리를 두기 위함.
                Container(
                  width: size.width,
                    margin: EdgeInsets.only(
                        top: size.height * 0.01, bottom: size.height * 0.01),
                  child: input_address(),
                ),
                search_address_gps(),
                Container(
                  height: size.height * 0.05,
                ),
                Container(
                  height: 5,
                  color: Colors.black12,
                ),
                isSearching
                    ? BouncingTextAnimation()
                    : Expanded(child: show_all_address(addresslist, selectaddress, modalSetState))
              ],
            ),
          ),
        );
      },
    ));
  }

  Widget input_address() {
    return Container(
        margin: EdgeInsets.all(size.height * 0.02),
        child: GestureDetector(
            onTap: () async {
              model = await Get.to(() => RemediKopo(), transition: Transition.rightToLeft);
              if (model != null) {
                Get.to(() => addressdetail(), arguments: [
                  "주소 상세 정보",
                  model.address!,
                  model.buildingName!,
                  model.zonecode
                ]);
              }
            },
            child: TextFormField(
              enabled: false,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.black38),
                hintText: "도로명, 건물명 또는 지번으로 검색",
                border: InputBorder.none,
              ),
              maxLines: line + 1,
              minLines: 1,
            )));
  }

  void _getCurrentLocation() async {
    // Check if location services are enabled
    if (!await Geolocator.isLocationServiceEnabled()) {
      print('Location services are disabled.');
      return;
    }
    // Check location permission
    LocationPermission permission = await Geolocator.checkPermission();

    // If permission is denied, request permission
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
        return;
      }
    }
    Get.to(() => addressdetail(),
        arguments: ["주소 상세 정보", searching_address, searching_building, ""],
        transition: Transition.rightToLeft);
  }

  Widget search_address_gps() {
    return Container(
      width: size.width * 0.9,
      height: size.height * 0.05,
      child: ElevatedButton.icon(
        onPressed: () {
          // 버튼 클릭 시 수행할 작업
          _getCurrentLocation();
        },
        icon: Icon(Icons.gps_fixed), // 아이콘 설정
        label: Text('현재 위치로 주소 찾기'), // 텍스트 설정
        style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            elevation: MaterialStateProperty.all(0),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: const BorderSide(color: Colors.black54, width: 1),
            ))),
      ),
    );
  }

  Widget show_all_address(List<dynamic> addresslist, int selectaddress, StateSetter modalSetState) {
    return ListView.builder(
      shrinkWrap: true,
      // This is needed if ListView.builder is inside another scrolling widget
      itemCount: addresslist.length ?? 0,
      itemBuilder: (context, index) {
        var addressItem = addresslist[index];
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: size.width*0.1,
              child: index == selectaddress ? Icon(Icons.check, color: Color(0xff47ABFF),) : Container()
            ),
            Container(
              width: size.width * 0.6,
              margin: EdgeInsets.only(top: size.width * 0.05, bottom: size.width * 0.05),
              child: GestureDetector(
                onTap: () async {
                  print(index);
                  if(index != selectaddress){
                    setState(() {
                      _address = addressItem['address'];
                      _city = addressItem['city'];
                    });
                    await storage.write(key: 'addressnum', value: index.toString());
                  }
                  Get.back();
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      addressItem['nickname'],
                      style: const TextStyle(
                          fontFamily: "HanM", color: Colors.black),
                      textScaleFactor: 1.5,
                    ),
                    Container(height: size.height*0.01,),
                    Text(
                      addressItem['address'],
                      style: const TextStyle(
                          fontFamily: "HanM", color: Colors.black),
                      textScaleFactor: 1.2,
                    ),
                    Container(height: size.height*0.01,),
                    Text(
                      addressItem['building'],
                      style: const TextStyle(
                          fontFamily: "HanM", color: Colors.black26),
                      textScaleFactor: 1.1,
                    ),
                    Container(height: size.height*0.02,),
                    Container(height: 1, color: Colors.black12,),
                  ],
                ),
              ),
            ),
            Container(
              width: size.width*0.15,
              child: IconButton(
                onPressed: () async {
                  print(index);
                  print("==============before=============");
                  print(addresslist);
                  if(addresslist.length == 1){
                    Fluttertoast.showToast(
                        msg: "하나의 주소는 필요합니다",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.grey,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  }
                  else{
                    modalSetState(() {
                      addresslist.removeAt(index);
                    });

                    if(index <= selectaddress){
                      if(index == 0){
                      }
                      else{
                        modalSetState(() {
                          index--;
                          selectaddress--;
                        });
                        await storage.write(key: 'addressnum', value: index.toString());
                      }
                    }
                    await storage.write(key: 'address', value: jsonEncode(addresslist));
                    setState(() {
                      _address = addresslist[selectaddress]['address'];
                      _city = addresslist[selectaddress]['city'];
                    });
                  }
                  print("==============after=============");
                  print(addresslist);
                },
                icon: const Icon(Icons.close, color: Colors.black26,),
              ),
            )
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    initlists();
    getData();
    _texteditcontroller = TextEditingController();
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
    _texteditcontroller.dispose();
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
          body: _mainpage(),
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
          style: TextStyle(
              color: Colors.black,
              fontFamily: "HanM",
              fontSize: size.width * 0.04)),
      centerTitle: true,
      bottom: PreferredSize(
          preferredSize: Size.fromHeight(size.height * 0.1),
          child: Column(
            children: [
              TextButton(
                onPressed: () {
                  print("tab address");
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
                  //search
                },
                icon: const Icon(Icons.search),
                color: Colors.black)),
      ],
    );
  }

  Widget _mainpage() {
    return PageView(
      controller: _pageController,
      onPageChanged: (index) {
        _tabController.animateTo(index);
      },
      children: <Widget>[firstTab(), secondTab()],
    );
  }

  void changeResource1(String newResource) {
    _imagepathlist1.add(newResource);
    imageFuture1.add(fetchImage(newResource));
  }

  Widget firstTab() {
    return _isLoading1
        ? Center(child: BouncingTextAnimation())
        : _data1length == 0
            ? RefreshIndicator(
                onRefresh: () async {
                  page1 = 0;
                  await refreshData1();
                  await fetchData1().then((_) {});
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
                  await fetchData1().then((_) {});
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
                            ontabmove("sale", _data1["body"][index], _idlist1[index]);
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
                                      // 이미지
                                      child: Container(
                                        padding:
                                            EdgeInsets.all(size.width * 0.01),
                                        child: FutureBuilder(
                                          future: imageFuture1[index],
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
                                              return Progressindicator();
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: size.width*0.05),
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
                  await fetchData2().then((_) {});
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
                  await fetchData2().then((_) {});
                },
                child: SizedBox(
                  height: size.width * 0.4 * (_data2length),
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
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
                            ontabmove("buy", _data2["body"][index], _idlist2[index]);
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
                                    margin: EdgeInsets.all(size.width * 0.05),
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
          SizedBox(width: size.width * 0.01), // 아이콘과 텍스트 사이의 간격을 위해 SizedBox 추가
          const Text('자원 등록하기',
              style: TextStyle(color: Colors.white, fontFamily: "HanB")),
        ],
      ),
    );
  }
}
