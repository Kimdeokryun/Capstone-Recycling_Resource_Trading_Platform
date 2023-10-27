import 'dart:io';
import 'package:ecocycle/collection/photo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import 'package:image/image.dart' as img;
import 'dart:ui';



class ImageGallery extends StatefulWidget {
  @override
  _ImageGalleryState createState() => _ImageGalleryState();
}

class NavController extends GetxController {
  void changeNavigationBarColor() {
    SystemUiOverlayStyle overlayStyle = const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(overlayStyle);
    });
  }
}

class _ImageGalleryState extends State<ImageGallery>{
  late PhotoStack photos;
  late List<String> _imagePaths;
  late PageController _pageController;
  late Size size;
  late TransformationController _transformationController;
  late int _currentIndex;
  final NavController photoviewnavController = NavController();

  Map<int, bool> _zoomStates = {};

  void initzoom() {
    for (int i = 0; i < _imagePaths.length; i++) {
      _zoomStates[i] = false;
    }
  }

  String formatDateTime(DateTime dateTime) {
    var formatter = DateFormat('yyyy년 MM월 dd일 HH:mm');
    return formatter.format(dateTime);
  }

  @override
  void initState() {
    super.initState();
    photos = Get.arguments;
    _imagePaths = photos.getlist();
    _currentIndex = _imagePaths.length-1;
    _pageController = PageController(initialPage: _imagePaths.length - 1);
    _transformationController = TransformationController();
    initzoom();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _transformationController.dispose();
    photoviewnavController.changeNavigationBarColor();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery
        .of(context)
        .size;
    const SystemUiOverlayStyle overlayStyle = SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(overlayStyle);
    });
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: AppBar(
            title: Text(
              '미리 보기',
              style: TextStyle(fontFamily: "HanM", color: Colors.black),
            ),
            backgroundColor: Colors.white,
            iconTheme: const IconThemeData(
              color: Colors.black, //change your color here
            ),
            elevation: 0,
          ),
        ),
        body: PageView.builder(
          controller: _pageController,
          itemCount: _imagePaths.length,
          physics: _zoomStates[_currentIndex]!
              ? NeverScrollableScrollPhysics()
              : AlwaysScrollableScrollPhysics(),
          onPageChanged: (index) {
            setState(() {
              _zoomStates[_currentIndex] = false;
              _currentIndex = index;
              print(_currentIndex);
              print(_imagePaths[_currentIndex]);
            });
            // 페이지 전환 시 호출되는 콜백 함수
            // 원하는 동작을 여기에 구현
          },
          itemBuilder: (context, index) {
            return GestureDetector(
              onDoubleTap: () {
                setState(() {
                  print("doubletap");
                  _zoomStates[index] = !_zoomStates[index]!;
                });
              },
              child: InteractiveViewer(
                  scaleEnabled: true,
                  minScale: 1,
                  maxScale: 3,
                  transformationController: _transformationController,
                  child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
              child: Image.file(
                File(_imagePaths[index]),
                fit: _zoomStates[index]! ? BoxFit.cover : BoxFit.contain,
              ),
            ),)
            ,
            );
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.black54,
          unselectedItemColor: Colors.black54,
          currentIndex: 0,
          backgroundColor: Colors.white,
          onTap: (int index) {
            if(index == 0){
              print(_imagePaths[_currentIndex]);
              Share.shareFiles([_imagePaths[_currentIndex]],text: "보낼 text");
            }
            else{
              detailview(File(_imagePaths[_currentIndex]));
            }
          },
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.share),
              label: '공유',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.more_vert),
              label: '상세정보',
            ),
          ],
        ));
  }

  Future detailview(File file) async {
    int fileSize = await file.length();
    DateTime lastModified = await file.lastModified();
    String date = formatDateTime(lastModified);
    final img.Image imageInput = img.decodeImage(file.readAsBytesSync())!;
    var w = imageInput.width;
    var h = imageInput.height;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('상세 정보', style: TextStyle(fontFamily: "HanB"), textScaleFactor: 1,),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('날짜: $date', style: TextStyle(fontFamily: "HanM"), textScaleFactor: 1,),
              Text(''),
              Text('${(fileSize/1024/1024).toStringAsFixed(2)} MB     $w x $h', style: TextStyle(fontFamily: "HanM", color: Colors.black54), textScaleFactor: 0.9,),
            ],
          ),
          actions: [
            TextButton(
              child: Text('닫기', style: TextStyle(fontFamily: "HanM"), textScaleFactor: 1),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
