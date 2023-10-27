import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:ui';

import '../customlibrary/progressindicator.dart';
import '/server/http_post.dart';
import '/customlibrary/textanimation.dart';
import 'challenge_http.dart';
import 'challengemainpage.dart';

class thistime_posts extends StatefulWidget {
  @override
  _thistime_posts createState() => _thistime_posts();
}

class _thistime_posts extends State<thistime_posts> {
  late Size size;
  late List<dynamic> _data = [];
  late List<Future> images = [];
  late PageController pageController;
  late ScrollController scrollController;

  int floor = 3;
  int page1 = 0;
  int _datalength = 0;
  bool isloading = true;

  Future<void> getdata() async {
    fetchData1();
  }

  Future<void> refreshData1() async {
    // 서버에서 데이터를 받아오는 비동기 작업을 수행
    _data = [];
    images = [];
  }

  Future<void> fetchData1() async {
    print("$page1 찾는 페이지");
    _data = await get_event_posts(page1);
    print(_data);
    for(var data in _data)
    {
      List<dynamic> list_data = data["list"];
      images.add(fetchImage(list_data[0]["imagePath"]));
    }
    setState(() {
      _datalength = images.length;
    });
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    scrollController = ScrollController();

    scrollController.addListener(() async {
      // 스크롤이 끝에 도달하면 추가 데이터 요청
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        page1 += 1;
        await fetchData1();
      }
    });

    getdata().then((_) {
      setState(() {
        isloading = false;
      });
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return isloading ? Container(color: Colors.white,child: Center(child: BouncingTextAnimation()),) : posts();
  }

  Widget posts() {
    return _data.isEmpty
        ? no_post()
        : RefreshIndicator(
      color: Colors.black,
            onRefresh: () async {
              page1 = 0;
              await refreshData1();
              await fetchData1().then((_) {});
            },
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.only(top:2),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 열의 개수
                  childAspectRatio: 1, // 아이템의 가로 세로 비율
                  mainAxisSpacing: 1, // 행 간격
                  crossAxisSpacing: 1, // 열 간격
                ),
                itemCount: _datalength,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: (){
                      next_detail_page(_data[index]);
                    },
                    child: post(index), // 각 게시물에 해당하는 위젯
                  );
                },
              ),
            ),
          );
  }

  Widget post(index)
  {
    return Container(
      child: FutureBuilder(
        future: images[index],
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
    );
  }

  Widget no_post() {
    return RefreshIndicator(
      color: Colors.black,
      onRefresh: () async {
        page1 = 0;
        await refreshData1();
        await fetchData1().then((_) {});
      },
      child: ListView(
        children: [
          SizedBox(
              height: size.height * 0.7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.camera_circle,
                    size: size.width * 0.2,
                    color: Colors.black54,
                  ),
                  Container(
                    height: size.height * 0.01,
                  ),
                  const Text(
                    "게시물이 없습니다.",
                    style: TextStyle(fontFamily: "HanB", color: Colors.black54),
                    textScaleFactor: 2,
                  )
                ],
              )),
        ],
      ),
    );
  }
}
