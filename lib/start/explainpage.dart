import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../server/http_post.dart';
import 'package:get/get.dart';
import 'welcome.dart';
import 'dart:io';

class explain extends StatefulWidget {
  @override
  _explain createState() => _explain();
}

late PageController? pageController;

Future<void> jumptopage() async {
  pageController!.jumpToPage(0);
}

class _explain extends State<explain> {
  List itemlist = [1, 2, 3, 4];
  int currentpage = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController(
      keepPage: true,
      initialPage: 0,
    );
  }

  @override
  void dispose() {
    pageController!.dispose();
    super.dispose();
  }

  List<Widget> indicators(listLength, currentIndex) {
    return List<Widget>.generate(listLength, (index) {
      return Container(
        margin: EdgeInsets.all(3),
        width: currentIndex == index ? 20 : 10,
        height: 10,
        decoration: BoxDecoration(
            color: currentIndex == index ? Color(0xff47ABFF) : Colors.grey,
            borderRadius: BorderRadius.circular(100)),
      );
    });
  }

  void nextpage() {
    Get.to(() => Welcome(),
        transition: Transition.rightToLeft,
        duration: Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.white, elevation: 0, actions: [
          TextButton(
              onPressed: nextpage,
              child: const Text('Skip',
                  style: TextStyle(fontFamily: 'GmarketM', color: Colors.teal),
                  textScaleFactor: 1))
        ]),
        body: Column(children: <Widget>[
          Container(
            height: size.height * 0.8,
            child: PageView(
                controller: pageController,
                onPageChanged: (page) {
                  setState(() {
                    currentpage = page;
                  });
                },
                children: [
                  explainpage('여러분들의 분리수거 점수는 몇 점인가요?'),
                  explainpage('올바른 분리 배출을 시작해 보는 건 어떤가요?'),
                  explainpage('문 앞에 내놓기만 하면 수거해 가요\n-> 잘 할수록 포인트도?!'),
                  explainglastpage('수거된 재활용 자원은 다시 재탄생하여\n여러분의 곁으로 돌아갑니다')
                ]),
          ),
          indicator()
        ]));
  }

  //1~3번째 설명 페이지
  Widget explainpage(String text) {
    return SizedBox(
      child: Container(
        color: Colors.white,
        child: Center(
          child: Text(
            text,
            textScaleFactor: 1,
          ),
        ),
      ),
    );
  }

  //4번째 설명 페이지
  Widget explainglastpage(String text) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.delta.dx > 1) {
          //print("페이지 전");
          pageController!.previousPage(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut);
        }
        if (details.delta.dx < 0) {
          //print("페이지 넘김");
          nextpage();
        }
      },
      child: SizedBox(
        child: Container(
          color: Colors.white,
          child: Center(
            child: Text(
              text,
              textScaleFactor: 1,
            ),
          ),
        ),
      ),
    );
  }

  //인디케이터
  Widget indicator() {
    return Expanded(
        child: Container(
      color: Colors.white,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: indicators(itemlist.length, currentpage)),
    ));
  }
}
