import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import '/customlibrary/hashtagcontroller.dart';
import '/customlibrary/dialog.dart';
import '/challenge/challengemainpage.dart';
import 'challenge_http.dart';

Future pickImages() async {
  final picker = ImagePicker();
  List<File> _images = [];
  final pickedImages = await picker.pickMultiImage();

  print(pickedImages.length);
  print(pickedImages);

  for (var pickedImage in pickedImages) {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedImage.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: '사진 편집',
            toolbarColor: Colors.white,
            toolbarWidgetColor: Colors.black,
            statusBarColor: Colors.white,
            showCropGrid: true,
            cropGridColor: Colors.black,
            cropFrameColor: Colors.black,
            cropGridStrokeWidth: 1,
            cropFrameStrokeWidth: 5,
            activeControlsWidgetColor: Colors.deepOrange,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: '사진 편집',
        )
      ],
    );

    if (croppedFile != null) {
      _images.add(File(croppedFile.path));
    }
  }

  // next page로 이동 후,   해시태그 및 제목 달기.
  if (_images.isNotEmpty) {
    Get.to(() => Upload(),
        transition: Transition.downToUp, arguments: [_images]);
  } else {
    return;
  }
}


class Upload extends StatefulWidget {
  @override
  _Upload createState() => _Upload();
}

class _Upload extends State<Upload> {
  late Size size;
  late PageController _pageController;

  late TextEditingController _hashtagcontroller;
  late TextEditingController _titlecontroller;

  List<File> _images = [];
  int currentimagepage = 0;

  bool isloading = true;

  Future<void> getdata() async {
    _images = Get.arguments[0];
  }

  // upload하고 event_point 갱신.
  Future<void> uploadImages() async {
    int _increment_val = 100;
    String _phonenum = userinfo.getphonenum();
    String _nickname = userinfo.getnickname();
    print(_titlecontroller.text);
    print(_hashtagcontroller.text);

    if(await sent_event_data(_nickname, _phonenum, _titlecontroller.text, _hashtagcontroller.text, _images))
    {
      if(await make_post(_phonenum))
      {
        await update_event_point(_phonenum, _increment_val);
        Get.back();
      }
      else
      {
        Othererror("업로드 실패", "게시물 업로드가 실패하였습니다.").showErrorDialog(context);
      }
    }
    else
    {
      Othererror("업로드 실패", "게시물 업로드가 실패하였습니다.").showErrorDialog(context);
    }

  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _hashtagcontroller = HashtagEditingController();
    _titlecontroller = TextEditingController();
    getdata().then((_) {
      setState(() {
        isloading = false;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _titlecontroller.dispose();
    _hashtagcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: mainappbar(),
        body: mainbody(),
      ),
    );
  }

  AppBar mainappbar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
        // 이 부분이 뒤로 가기 버튼 아이콘을 변경하는 부분입니다.
        onPressed: () => Navigator.of(context).pop(),
      ),
      toolbarHeight: size.height * 0.05,
      centerTitle: true,
      title: const Text(
        "새 게시물",
        style: TextStyle(fontFamily: "HanM", color: Colors.black),
        textScaleFactor: 1,
      ),
      actions: [
        TextButton(
          onPressed: () {
            uploadImages();
          },
          child: const Text(
            "공유",
            style: TextStyle(fontFamily: "HanM", color: Color(0xff47ABFF)),
            textScaleFactor: 1,
          ),
        ),
        Container(
          width: size.width * 0.05,
        )
      ],
    );
  }

  Widget mainbody() {
    return Container(
      width: size.width,
      height: size.height,
      color: Colors.white,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: size.height * 0.05,
            ),
            mainimage(),
            Container(
              height: size.height * 0.05,
            ),
            title(),
            Container(
              height: size.height * 0.05,
            ),
            hashtag(),
            Container(
              height: size.height * 0.05,
            ),
          ],
        ),
      ),
    );
  }

  Widget mainimage() {
    return Container(
        width: size.width,
        height: size.width,
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: _images.length, // 페이지 개수를 1로 설정
              onPageChanged: (value) {
                setState(() {
                  currentimagepage = value;
                });
              },
              itemBuilder: (context, index) {
                return Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        // 이미지 주변에 테두리 추가
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    child: Image.file(
                      _images[index],
                      fit: BoxFit.contain,
                    ));
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
                        text: (currentimagepage + 1).toString(),
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
                        text: _images.length.toString(),
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

  // 해시태그, 제목 넣을 수 있도록 삽입.
  Widget title() {
    return TextField(
      controller: _titlecontroller,
      keyboardType: TextInputType.multiline,
      cursorColor: Colors.indigo,
        decoration: InputDecoration(
          hintText: "제목",
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontFamily: "HanM",
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[200],
          focusColor: Colors.white,
          prefixIcon: const Icon(Icons.title, color: Colors.indigo),
          contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
        ),
    );
  }

  Widget hashtag() {
    return TextField(
      controller: _hashtagcontroller,
      keyboardType: TextInputType.multiline,
      cursorColor: Colors.indigo,
      decoration: InputDecoration(
        hintText: "해시태그",
        hintStyle: TextStyle(
          color: Colors.grey[400],
          fontFamily: "HanM",
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[200],
        focusColor: Colors.white,
        prefixIcon: const Icon(Icons.tag, color: Colors.indigo),
        contentPadding: const EdgeInsets.symmetric(vertical: 1.0),
      ),
    );
  }
}
