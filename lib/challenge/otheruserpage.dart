

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:ui';
import 'dart:io';
import '/server/http_post.dart';
import 'challenge_http.dart';
import 'challengemainpage.dart';

class otheruserpage extends StatefulWidget {
  @override
  _otheruserpage createState() => _otheruserpage();
}

class _otheruserpage extends State<otheruserpage> {
  late Size size;

  late String _name;
  late String _nickname;
  late String _phonenum;
  late Uint8List _image;
  late Map<String, dynamic> _user_point;
  late List<dynamic> _data = [];
  late List<Future> images = [];

  int totalpage = 0;
  int totallikenum = 0;
  int _trannum = 0;
  int _datalength = 0;
  bool isloading = true;

  Future<void> refreshData1() async {
    // 서버에서 데이터를 받아오는 비동기 작업을 수행
    _data = [];
  }

  Future<void> getdata() async {
    _nickname = await Get.arguments[1];
    _phonenum = await Get.arguments[0];
    _image = await Get.arguments[2];
    await fetchData1().then((value) {
      setState(() {
        _datalength = images.length;
        totalpage = _datalength;
      });
    });
  }

  Future<void> fetchData1() async {
    _data = await get_user_posts(_phonenum);
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

    return isloading ? Container(color: Colors.white,) : Scaffold(
      appBar: mainappbar(),
      body: mainbody(),
    );
  }

  AppBar mainappbar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black), // 이 부분이 뒤로 가기 버튼 아이콘을 변경하는 부분입니다.
        onPressed: () => Navigator.of(context).pop(),
      ),
      toolbarHeight: size.height*0.05,
      actions: [
        const Icon(Icons.menu, color: Colors.black,),
        Container(width: size.width*0.05,)
      ],
    );
  }

  Widget mainbody() {
    return Container(
      width: size.width,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          profile(),
          Container(height: size.height*0.05,),
          Container(height: 2, color: Colors.black12,),
          posts()
        ],
      ),
    );
  }

  Widget profile() {
    return Container(
      padding: EdgeInsets.only(left: size.width*0.02, right: size.width*0.02, top: size.height*0.05, bottom: size.height*0.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  width: size.width*0.2,
                  height: size.width*0.2,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(100), // 반지름의 절반을 사용하여 원 모양에 적용
                      child: Image.memory(_image),
                  )
              ),
              Container(height: 5,),
              Text("$_nickname", style: const TextStyle(fontFamily: "HanM", color: Colors.black),textScaleFactor: 1,)
            ],
          ),
          Container(
            width: size.width*0.05,
          ),
          Container(
              width: size.width*0.15,
              height: size.width*0.2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("-", style: TextStyle(fontFamily: _trannum != 0? "HanB" : "HanM", color: _trannum != 0? Colors.black : Colors.black54),textScaleFactor: 1, ),
                  Container(height: 5,),
                  const Text("포인트", style: TextStyle(fontFamily: "HanM", color: Colors.black87),textScaleFactor: 1.1, )
                ],
              )
          ),
          Container(
            width: size.width*0.05,
          ),
          Container(
              width: size.width*0.15,
              height: size.width*0.2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(totalpage.toString(), style: TextStyle(fontFamily: totalpage != 0? "HanB" : "HanM", color: totalpage != 0? Colors.black : Colors.black54),textScaleFactor: 1, ),
                  Container(height: 5,),
                  const Text("게시물", style: TextStyle(fontFamily: "HanM", color: Colors.black87),textScaleFactor: 1.1, )
                ],
              )
          ),
          Container(
            width: size.width*0.05,
          ),
          Container(
              width: size.width*0.15,
              height: size.width*0.2,
              child: GestureDetector(
                onTap: (){},
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("-", style: TextStyle(fontFamily: totallikenum != 0? "HanB" : "HanM", color: totallikenum != 0? Colors.black : Colors.black54),textScaleFactor: 1, ),
                    Container(height: 5,),
                    const Text("좋아요", style: TextStyle(fontFamily: "HanM", color: Colors.black87),textScaleFactor: 1.1, )
                  ],
                ),
              )
          ),
        ],
      ),
    );
  }

  Widget posts() {
    return _data.isEmpty
        ? no_post()
        : RefreshIndicator(
      onRefresh: () async {
        await refreshData1();
        await fetchData1().then((_) {});
      },
      child: Container(
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
            return const CircularProgressIndicator(
              color: Colors.black26,
            );
          }
        },
      ),
    );
  }

  Widget no_post()
  {
    return Container(
      child: Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(CupertinoIcons.camera_circle, size: size.width*0.2, color: Colors.black54),
              Container(height: size.height*0.01,),
              const Text("게시물이 없습니다.", style: TextStyle(fontFamily: "HanB", color: Colors.black54),textScaleFactor: 2, )
            ],
          ),
        ),

      ),
    );
  }
}
