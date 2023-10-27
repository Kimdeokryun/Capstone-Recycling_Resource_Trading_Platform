import 'package:ecocycle/server/http_post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:ui';

import '../customlibrary/progressindicator.dart';
import '/customlibrary/textanimation.dart';
import 'challenge_http.dart';
import 'challengemainpage.dart';

class passtime_posts extends StatefulWidget {
  @override
  _passtime_posts createState() => _passtime_posts();
}

class _passtime_posts extends State<passtime_posts> {
  late Size size;

  late List<dynamic> _data1 = [];
  late List<dynamic> _data2 = [];
  late List<dynamic> _data1_subinfo = [];
  late List<int> _data1_likes = [];
  late List<int> _data2_likes = [];

  late List<Future> images1 = [];
  late List<Future> images2 = [];

  bool isloading = true;
  int currentimage1page = 0;
  int currentimage2page = 0;

  Future<void> refreshData1() async {
    // 서버에서 데이터를 받아오는 비동기 작업을 수행
    _data1 = [];
    _data2 = [];
    _data1_subinfo = [];
    _data1_likes = [];
    _data2_likes = [];
    images1 = [];
    images2 = [];
  }

  Future<void> getdata() async {
    _data1 = await get_last_top_10_likes();
    _data2 = await get_total_top_10_likes();
    _data1_subinfo = await get_last_top10_subinfo();

    for (var data1 in _data1) {
      String id = data1["_id"];
      for (var subdata in _data1_subinfo) {
        if (id == subdata["id"]) {
          _data1_likes.add(subdata["likes"]);
          images1.add(fetchImage(data1["list"][0]["imagePath"]));
          break;
        }
      }
    }

    for (var data2 in _data2) {
      String id = data2["_id"];
      int likenum = await search_posts_likenum(id);
      _data2_likes.add(likenum);
      images2.add(fetchImage(data2["list"][0]["imagePath"]));
    }

    print(images1.length);
    print(images2.length);
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
    return isloading
        ? Container(
            color: Colors.white,
            child: Center(child: BouncingTextAnimation()),
          )
        : posts();
  }

  Widget posts() {
    return mainbody();
  }

  Widget mainbody() {
    return RefreshIndicator(
        color: Colors.black,
        onRefresh: () async {
      isloading = true;
      await refreshData1();
      await getdata().then((_) {
        setState(() {
          isloading = false;
        });
      });
    },
    child: SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: size.height * 0.05,
          ),
          Container(
            height: 10,
          ),
          Container(
            padding:
            EdgeInsets.only(left: size.width * 0.05, right: size.width * 0.05),
            child: const Text(
              "지난 주 가장 좋아요를 많이 받은 게시물",
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'HanB',
              ),
              textScaleFactor: 1.2,
            ),
          ),
          Container(
            height: 10,
          ),
          _data1.isEmpty ? no_post() : buildPageView1(),
          Container(
            height: size.height * 0.05,
          ),
          Container(
            padding:
            EdgeInsets.only(left: size.width * 0.05, right: size.width * 0.05),
            child: const Text(
              "역대 가장 좋아요를 많이 받은 게시물",
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'HanB',
              ),
              textScaleFactor: 1.2,
            ),
          ),
          Container(
            height: 10,
          ),
          _data1.isEmpty ? no_post() : buildPageView2(),
        ],
      ),
    ));
  }

  Widget buildPageView1() {
    return Container(
        width: size.width,
        height: size.height * 0.25,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12, width: 1)
        ),
        child: Stack(
          children: [
            PageView.builder(
              itemCount: _data1.length,
              onPageChanged: (value) {
                setState(() {
                  currentimage1page = value;
                });
              },
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    next_detail_page(_data1[index]);
                  },
                  child: Container(
                    width: size.width,
                    child: Row(
                      children: [
                        Container(
                          child: FutureBuilder(
                            future: images1[index],
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.data!.statusCode == 200) {
                                  return Image.memory(snapshot.data!.bodyBytes);
                                } else {
                                  return const Text('Failed to load image');
                                }
                              } else if (snapshot.hasError) {
                                return Text('이미지 로드 오류');
                              } else {
                                return Progressindicator();
                              }
                            },
                          ),
                        ), // 이미지를 넣는 부분
                        SizedBox(width: size.width * 0.1),
                        RichText(
                          textAlign: TextAlign.start,
                          textScaleFactor: 1,
                          text: TextSpan(children: [
                            const TextSpan(
                                text: "좋아요 ",
                                style: TextStyle(color: Colors.black, fontFamily: 'HanM')),
                            TextSpan(
                              text: _data1_likes[index].toString(),
                              style: const TextStyle(color: Colors.red, fontFamily: 'HanB', fontSize: 18),
                            ),
                            const TextSpan(
                                text: " 개 ",
                                style:
                                TextStyle(color: Colors.black, fontFamily: 'HanM'))
                          ]),
                        )
                        ,
                      ],
                    ),
                  ),
                );
              },
            ),
            Positioned(
              bottom: 10, // 위쪽으로 10 픽셀 이동
              right: 10, // 왼쪽으로 10 픽셀 이동
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: (currentimage1page + 1).toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'HanM',
                        ),
                      ),
                      const TextSpan(
                        text: ' / ',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'HanM',
                        ),
                      ),
                      TextSpan(
                        text: images1.length.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'HanM',
                        ),
                      ),
                    ],
                  ),
                  textScaleFactor: 1,
                ),
              ),
            ),
          ],
        ));
  }

  Widget buildPageView2() {
    return Container(
        width: size.width,
        height: size.height * 0.25,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black12, width: 1)
        ),
        child: Stack(
          children: [
            PageView.builder(
              itemCount: _data2.length,
              onPageChanged: (value) {
                setState(() {
                  currentimage2page = value;
                });
              },
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    next_detail_page(_data2[index]);
                  },
                  child: Container(
                    width: size.width,
                    child: Row(
                      children: [
                        Container(
                          child: FutureBuilder(
                            future: images2[index],
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.data!.statusCode == 200) {
                                  return Image.memory(snapshot.data!.bodyBytes);
                                } else {
                                  return const Text('Failed to load image');
                                }
                              } else if (snapshot.hasError) {
                                return const Text('이미지 로드 오류');
                              } else {
                                return Progressindicator();
                              }
                            },
                          ),
                        ), // 이미지를 넣는 부분
                        SizedBox(width: size.width * 0.1),
                        RichText(
                          textAlign: TextAlign.start,
                          textScaleFactor: 1,
                          text: TextSpan(children: [
                            const TextSpan(
                                text: "좋아요 ",
                                style: TextStyle(color: Colors.black, fontFamily: 'HanM')),
                            TextSpan(
                              text: _data2_likes[index].toString(),
                              style: const TextStyle(color: Colors.red, fontFamily: 'HanB', fontSize: 18),
                            ),
                            const TextSpan(
                                text: " 개 ",
                                style:
                                TextStyle(color: Colors.black, fontFamily: 'HanM'))
                          ]),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            Positioned(
              bottom: 10, // 위쪽으로 10 픽셀 이동
              right: 10, // 왼쪽으로 10 픽셀 이동
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: (currentimage2page + 1).toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'HanM',
                        ),
                      ),
                      const TextSpan(
                        text: ' / ',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'HanM',
                        ),
                      ),
                      TextSpan(
                        text: images2.length.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'HanM',
                        ),
                      ),
                    ],
                  ),
                  textScaleFactor: 1,
                ),
              ),
            ),
          ],
        ));
  }

  Widget no_post() {
    return RefreshIndicator(
      color: Colors.black,
      onRefresh: () async {
        isloading = true;
        await refreshData1();
        await getdata().then((_) {
          setState(() {
            isloading = false;
          });
        });
      },
      child: ListView(
        children: [
          SizedBox(
              height: size.height * 0.3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.camera_circle,
                    size: size.width * 0.1,
                    color: Colors.black54,
                  ),
                  Container(
                    height: size.height * 0.01,
                  ),
                  const Text(
                    "게시물이 없습니다.",
                    style: TextStyle(fontFamily: "HanB", color: Colors.black54),
                    textScaleFactor: 1,
                  )
                ],
              )),
        ],
      ),
    );
  }
}
