import 'package:ecocycle/collection/resource_transaction.dart';
import 'package:ecocycle/collection/resource_transaction_page.dart';
import 'package:ecocycle/user/User.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ecocycle/collection/photo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import '../main/mainpage.dart';
import '../server/http_post.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'dart:io';
import '../customlibrary/textanimation.dart';
import '../user/User_Storage.dart';


Future<List<Map<String, String>>> Imagesinfo(List<List<String>> args) async {
  List<String> imagespath = args[0];
  List<String> imageinfo = args[1];

  List<Map<String,String>> resizedImagesInfo = [];
  for (int i = 0; i < imagespath.length; i++) {
    File resizedImage = File(imagespath[i]);
    print("=======================================");
    print("filesize: ${(await resizedImage.length()/1024/1024).toStringAsFixed(2)} MB");
    print("=======================================");
    resizedImagesInfo.add({
      'path': resizedImage.path,
      'info': imageinfo[i],
    });
  }
  return resizedImagesInfo;
}

Future<List<String>> predictImages(List<File> _images, dynamic _interpreter) async {
  late String predict_class;
  List<String> predict_result = [];
  late double maxValue;
  late int maxIndex;

  List<String> _classNames = [
    '나무류',
    '종이류',
    '플라스틱류',
    '스티로폼류',
    '페트병류',
    '캔류',
    '유리병류',
    '의류',
    '비닐류'
  ];

  for (var imageFile in _images) {
    try {
      // 이미지 전처리
      final img.Image imageInput =
      img.decodeImage(imageFile.readAsBytesSync())!;
      img.Image resizedImg =
      img.copyResize(imageInput, width: 224, height: 224);

      var imgBytes = resizedImg.getBytes();
      var imgAsList = imgBytes.buffer.asUint8List();

      Uint8List data = imgAsList.buffer
          .asUint8List(imgBytes.offsetInBytes, imgBytes.lengthInBytes);
      data = data.buffer.asUint8List();

      List<List<List<List<double>>>> input4D = convertTo4DList(data);

      var outputData = List.filled(1 * 9, 0).reshape([1, 9]);

      print("=============================================");
      print(input4D.shape);
      print(outputData.shape);
      print("=============================================");
      _interpreter.run(input4D, outputData);

      print("모델 예측");
      print("=============================================");

      var outputs = outputData[0];
      maxValue = outputs[0];
      maxIndex = 0;

      for (int i = 1; i < outputs.length; i++) {
        if (outputs[i] > maxValue) {
          maxValue = outputs[i];
          maxIndex = i;
        }
      }
      print("=============================================");
    } catch (e) {
      print('Failed to predict image: $e');
    }

    if(maxValue > 0.6){
      predict_class = _classNames[maxIndex];
    }
    else{
      predict_class = "";
    }
    predict_result.add(predict_class);
    //_textControllers.add(TextEditingController(text: predict_class));
  }
  return predict_result;
}

List<List<List<List<double>>>> convertTo4DList(Uint8List inputList) {
  List<List<List<List<double>>>> outputList = List.generate(
    1,
        (i) =>
        List.generate(
          224,
              (j) =>
              List.generate(224, (k) {
                int index = i * 224 * 224 * 3 + j * 224 * 3 + k * 3;
                double value1 = inputList[index] / 255;
                double value2 = inputList[index + 1] / 255;
                double value3 = inputList[index + 2] / 255;
                return [value1, value2, value3];
              }),
        ),
  );
  return outputList;
}

class images_modeling extends StatefulWidget {
  @override
  _images_modeling createState() => _images_modeling();
}

class _images_modeling extends State<images_modeling> {
  late Size size;
  late PhotoStack photos;

  late var _interpreter;
  late List<String> _imagePaths;

  late final TextEditingController _descriptionController;
  late final TextEditingController _countController;
  late final ScrollController _scrollController;
  late PageController _pageController;

  List<File> _images = [];
  List<TextEditingController> _textControllers = [];
  List<bool> _textedit = [];

  int phase = 1;
  String _label1 = "정보 입력";

  int _currentPageIndex = 0;
  bool isloading = true;

  bool ispredict = false;
  bool istab = false;
  late double paddingsize;

  void nextpage() async {
    List<String> resource_info = _textControllers.map((controller) => controller.text).toList();
    List<String> resized_images = [];
    setState(() {
      isloading = true;
      ispredict = true;
    });
    for (int i = 0; i < _imagePaths.length; i++) {
      File resizedImage = await FlutterNativeImage.compressImage(
        _imagePaths[i],
        quality: 70, // 이미지 품질 (0-100)
        targetWidth: 800, // 이미지 가로 크기
        targetHeight: 800, // 이미지 세로 크기
      );
      print("image size: ${resizedImage.length()}");
      resized_images.add(resizedImage.path);
    }

    List<Map<String,String>> resultpath = await compute(Imagesinfo, [resized_images, resource_info]);
    bool post_success = await sent_trash_image(await getUserData(), svaddress.get(), resultpath);

    if(post_success){
      await addToSalePage(resultpath, svaddress.get());
      setState(() {
        isloading = false;
        ispredict = false;
      });
      Get.offAll(() => mainpage());
      Get.to(transactionpage());
      Get.to(transactiondetailpage(), arguments: [0, resultpath, svaddress.get()]);
    }
    else{
      setState(() {
        isloading = false;
        ispredict = false;
      });
      print("오류");
    }
  }
  void onTapFunc(double val) async {
    _scrollController.animateTo(100, duration: Duration(milliseconds: 100), curve: Curves.linear);
  }

  Future<void> initializePages() async {
    _images.clear();
    _textControllers.clear();
    _textedit.clear();
  }

  convertfile(List<String> imagespath) {
    for (int i = 0; i < imagespath.length; i++) {
      setState(() {
        _images.add(File(imagespath[i]));
      });
    }
  }

  void _deletePhoto(int index) {
    setState(() {
      _images.removeAt(index);
      _imagePaths.removeAt(index);
      if(!_textControllers.isEmpty){
        var textcon = _textControllers[index];
        _textControllers.removeAt(index);
        _textedit.removeAt(index);
        textcon.dispose();
      }
      if (_currentPageIndex >= _images.length) {
        _currentPageIndex = _images.length - 1;
      }
    });
    print("==============================================");
    print(photos.getlist());
    print("==============================================");
  }

  Future<void> loadmodel() async {
    _interpreter = await Interpreter.fromAsset(
        'assets/model/EfficientNet_optimize0.tflite');
  }
  @override
  void initState() {
    super.initState();
    photos = Get.arguments;
    _imagePaths = photos.getlist();
    print("image length : ${_imagePaths.length}");
    convertfile(_imagePaths);
    loadmodel();
    _pageController = PageController(initialPage: 0);
    _descriptionController = TextEditingController();
    _countController = TextEditingController();
    _scrollController = ScrollController();
    isloading = false;
  }

  @override
  void dispose() {
    _interpreter.close();
    _pageController.dispose();
    _descriptionController.dispose();
    _countController.dispose();
    _scrollController.dispose();
    for (var controller in _textControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery
        .of(context)
        .size;
    paddingsize = size.height*0.02;
    const SystemUiOverlayStyle overlayStyle = SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(overlayStyle);
    });
    return GestureDetector(
        onTap: () {
      FocusScope.of(context).unfocus();
      setState(() {
        istab = false;
      });
    },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            '자원 정보 입력',
            style: TextStyle(color: Colors.black, fontFamily: "HanB"),
            textScaleFactor: 1,
          ),
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        body: isloading
            ? Center(
            child: BouncingTextAnimation())
            : SafeArea(
          child: _buildPhotoViewer(),
        ),
        bottomNavigationBar: bottomnav(),

        floatingActionButton: actionbutton(),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      ),
    );
  }

  Widget _buildPhotoViewer() {
    return _images.isEmpty
        ? Center(
      child: Text('사진이 없습니다.', style: TextStyle(color: Colors.black54, fontFamily: "HanM"), textScaleFactor: 2,),
    )
        : PageView.builder(
      controller: _pageController,
      itemCount: _images.length,
      onPageChanged: (index){
        setState(() {
          _currentPageIndex = index;
        });
      },
      itemBuilder: (context, index) {
        return SingleChildScrollView(
          controller: _scrollController,
          child: Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            padding: EdgeInsets.all(size.width*0.03),
            child: Column(
              children: [
                Image.file(_images[index]),
                Container(height: paddingsize),
                phase == 1 ? Container() :
                ispredict ?  Center(child: BouncingTextAnimation(),):
                TextFormField(
                  controller: _textControllers[index],
                  enabled: _textedit[index],
                  onEditingComplete: (){
                    setState(() {
                      istab = false;
                    });
                    FocusScope.of(context).unfocus();
                  },
                  onTap: (){
                    setState(() {
                      istab = true;
                      onTapFunc(_scrollController
                          .position
                          .maxScrollExtent);
                    });
                  },
                  decoration: InputDecoration(
                    labelText: '자원명',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xff47ABFF),
                        width: 3.0,
                      ), borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(10)
                    )
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || value == "") {
                      return '자원명을 입력해주세요.';
                    }
                    return null;
                  },
                ),
                istab ? Container(height: size.width) : Container()
              ],
            ),
          ),
        );
      },
    );
  }

  Widget bottomnav() {
    return BottomAppBar(
      color: Colors.white,
      height: size.height*0.1,
      // this creates a notch in the center of the bottom bar
      shape: const CircularNotchedRectangle(),
      notchMargin: 2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              IconButton(
                icon: Icon(CupertinoIcons.delete),
                splashColor: Colors.transparent,
                onPressed: _images.isEmpty | ispredict? null : () {
                  _deletePhoto(_currentPageIndex);
                },
              ),
              Text("삭제", style: TextStyle(color: _images.isEmpty | ispredict ? Colors.black38 : Colors.black, fontFamily: "HanM"),textScaleFactor: 1)
            ],
          ),
          const SizedBox(
            width: 20,
          ),
          Column(
            children: [
              IconButton(
                icon: const Icon(CupertinoIcons.refresh_thin),
                splashColor: Colors.transparent,
                onPressed: ispredict? null : () async {
                  setState(() {
                    initializePages();
                    phase = 1;
                    _label1 = "정보 입력";
                    _imagePaths = photos.getlist();
                    print(_imagePaths);
                    convertfile(_imagePaths);
                    print(_images);
                    _currentPageIndex = 0;
                    _pageController.initialPage;
                    _pageController.initialScrollOffset;
                  });
                },
              ),
              Text("초기화", style: TextStyle(color: ispredict ? Colors.black38 : Colors.black,fontFamily: "HanM"),textScaleFactor: 1,)
            ],
          )
          ,
        ],
      ),
    );
  }



  Widget actionbutton() {
    return ElevatedButton(

      onPressed: ispredict || _images.isEmpty ? null : () async {
        if(phase == 1) {
          setState(() {
            phase = 2;
            ispredict = true;
            paddingsize = size.height * 0.05;
          });
          Future.delayed(Duration(milliseconds: 1000), () async {
            List<String> result = await predictImages(_images, _interpreter);
            setState(() {
              for (var value in result) {
                _textControllers.add(TextEditingController(text: value));
                _textedit.add(false);
              }
              _label1 = "    편집    ";
              ispredict = false;
              paddingsize = size.height*0.02;
            });
          },);
        }
        else if(phase == 2){
          setState(() {
            phase = 3;
            for (int idx = 0 ; idx < _textedit.length; idx++) {
              _textedit[idx] = !_textedit[idx];
            }
            _label1 = "    완료    ";
          });
        }
        else{
          nextpage();
        }
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100), // 버튼의 모서리 반경 설정
        ),
        backgroundColor: Color(0xff47ABFF),
        padding: EdgeInsets.all(size.width * 0.04), // 버튼의 내부 padding 설정
        elevation: 3, // 그림자 효과 설정
        // 원하는 스타일 속성 추가
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('${_currentPageIndex+1} / ${_images.length}', style: TextStyle(color: Colors.white, fontFamily: "HanM"), textScaleFactor: 1),
          Container(width: size.width * 0.02, height: size.width*0.04,), // 아이콘과 텍스트 사이의 간격을 위해 SizedBox 추가
          Text(_label1,
              style: TextStyle(color: Colors.white, fontFamily: "HanM"), textScaleFactor: 1),
        ],
      ),
    );
  }
}