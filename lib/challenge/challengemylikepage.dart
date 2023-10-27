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

class mylikepage extends StatefulWidget {
  @override
  _mylikepage createState() => _mylikepage();
}

class _mylikepage extends State<mylikepage> {
  late Size size;

  bool isloading = true;

  late List<String> _id_data = [];
  late List<dynamic> _data = [];
  late List<Future> images = [];
  int _datalength = 0;

  Future<void> getdata() async {
    List<dynamic> _getlist = Get.arguments[0];
    _id_data = _getlist.map((item) => item.toString()).toList();
    print(_id_data);
    await fetchData1().then((value) {
      setState(() {
        _datalength = images.length;
      });
    });
  }

  Future<void> fetchData1() async {
    _data = await search_like_posts_withid(_id_data);

    print(_data);
    for(var data in _data)
    {
      List<dynamic> list_data = data["list"];
      images.add(fetchImage(list_data[0]["imagePath"]));
    }
  }


  @override
  void initState() {
    super.initState();
    getdata().then((value) {
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
    size = MediaQuery
        .of(context)
        .size;
    const SystemUiOverlayStyle overlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // 투명색
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(overlayStyle);
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: mainappbar(),
      body: isloading ? Container(color: Colors.white,child: Center(child: BouncingTextAnimation()),) : posts(),
    );
  }

  AppBar mainappbar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: const IconThemeData(
        color: Colors.black, //change your color here
      ),
      title: const Text("좋아요 누른 게시물",
          style: TextStyle(color: Colors.black, fontFamily: "HanM"), textScaleFactor: 0.8,),
      centerTitle: true,
    );
  }

  Widget posts() {
    return Container(
      color: Colors.white,
      width: size.width,
      height: size.width/3 * (_data.length/3 + 1),
      padding: const EdgeInsets.only(top:2),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // 열의 개수
          childAspectRatio: 1, // 아이템의 가로 세로 비율
          mainAxisSpacing: 1, // 행 간격
          crossAxisSpacing: 1, // 열 간격
        ),
        itemCount: _datalength,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: (){
              next_detail_page(_data[index]);
            },
            child: post(index), // 각 게시물에 해당하는 위젯
          );
        },
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








}
