import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

class Servererror extends GetxController {
  late Size size;
  void loginfunc(BuildContext context)  {
    size = MediaQuery.of(context).size;
    Get.bottomSheet(
        Container(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: size.width,
            height: size.height * 0.35,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40)),
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: size.height * 0.02),
                  child: Center(
                    child: Text(
                      "로그인 방법 선택",
                      style: TextStyle(color: Colors.black, fontFamily: "NSB"),
                      textScaleFactor: 1.2,
                    ),
                  ),
                ),
                // 로그인 방법 선택 부분과 거리를 두기 위함.
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.all(size.height * 0.01),
                        // 간편 로그인 창 부분
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        enterBottomSheetDuration: Duration(milliseconds: 500),
        exitBottomSheetDuration: Duration(milliseconds: 500),
        isDismissible: true,
        barrierColor: Colors.black54);
  }
}