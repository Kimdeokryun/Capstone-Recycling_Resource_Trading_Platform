import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:path_provider/path_provider.dart';
import 'package:soundpool/soundpool.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../server/http_post.dart';
import '../user/User.dart';
import 'package:path/path.dart';
import 'package:get/get.dart';
import 'photoview.dart';
import 'third.dart';
import 'photo.dart';
import 'dart:async';
import 'dart:io';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class NavController extends GetxController {
  void changeNavigationBarColor() {
    SystemUiOverlayStyle overlayStyle = const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(overlayStyle);
    });
  }
}

class _CameraPageState extends State<CameraPage> {
  Soundpool pool = Soundpool(streamType: StreamType.alarm);
  String alert_text = "모든 자원을 다 촬영하면 '완료' 버튼을 눌러주세요.";
  late Size size;
  late int soundId;
  late final Directory dir;
  late bool servercond;
  List<String> _imagePaths = [];
  final NavController cameranavController = NavController();
  PhotoStack photostack = PhotoStack();


  void playSound() async {
    soundId = await rootBundle
        .load("assets/sound/camera_shutter.mp3")
        .then((ByteData soundData) {
      return pool.load(soundData);
    });
  }

  void tempdir() async {
    dir = await getTemporaryDirectory();
  }

  Future<void> nextpage(where) async {
    if (where == "close") {
      Get.back();
    }
    else if(where == "preview"){
      Get.to(() => ImageGallery(), arguments: photostack);
    }
    else{
      _imagePaths = photostack.getlist();
      if (_imagePaths.isEmpty){
        print("이미지 없음");
        setState(() {
          alert_text = "사진을 한 장 이상 찍고 '완료' 버튼을 눌러 주세요.";
          Future.delayed(Duration(milliseconds: 2000), () {
            setState(() {
              alert_text = "모든 자원을 다 촬영하면 '완료' 버튼을 눌러주세요.";
            });
          },);
        });
      }
      else{
        Get.off(() => images_modeling(), arguments: photostack);
      }
    }
  }


  @override
  void initState() {
    super.initState();
    playSound();
    tempdir();
  }

  @override
  void dispose() {
    cameranavController.changeNavigationBarColor();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    const SystemUiOverlayStyle overlayStyle = SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(overlayStyle);
    });
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 0,
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: isloading ? const Center(child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Color(0xff47ABFF),),
      )) : SafeArea(child: cameraUI()),
    );
  }

  Widget cameraUI() {
    return CameraAwesomeBuilder.awesome(
      saveConfig: SaveConfig.photo(
        pathBuilder: () async {
          await pool.play(soundId);
          final String filename = '${DateTime.now()}.jpg';
          final String filepath = '${dir.path}/$filename';
          photostack.push(filepath);
          return filepath;
        },
      ),

      enablePhysicalButton: false,
      flashMode: FlashMode.auto,
      aspectRatio: CameraAspectRatios.ratio_1_1,
      previewFit: CameraPreviewFit.fitWidth,
      enableAudio: true,
      progressIndicator: Expanded(
        child: Container(
            color: Colors.black,
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )),
      ),
      theme: AwesomeTheme(),
      topActionsBuilder: (state) {
        return Container(
          color: Colors.black,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Padding(
                  padding: EdgeInsets.only(left: size.width * 0.05),
                  child: AwesomeFlashButton(state: state),
                ),
              ),
              Container(
                child: Padding(
                  padding: EdgeInsets.only(right: size.width * 0.05),
                  child: IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.close), // 플래쉬 버튼 on off 기능 추가.
                    onPressed: () {
                      nextpage("close");
                    },
                  ),
                ),
              )
            ],
          ),
        );
      },
      middleContentBuilder: (state) {
        return Column(
          children: [
            const Spacer(),
            // Use a Builder to get a BuildContext below AwesomeThemeProvider widget
            Builder(builder: (context) {
              return Container(
                // Retrieve your AwesomeTheme's background color
                color: AwesomeThemeProvider.of(context)
                    .theme
                    .bottomActionsBackgroundColor,
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 10, top: 10),
                    child: Text(
                      alert_text,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "HanM",
                      ),
                      textScaleFactor: 1,
                    ),
                  ),
                ),
              );
            }),
          ],
        );
      },
      bottomActionsBuilder: (state) => AwesomeBottomActions(
        state: state,
        captureButton: AwesomeCaptureButton(
          state: state,
        ),
        left: Container(
          width: size.width * 0.15,
          height: size.width * 0.15,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100)
          ),
          child: SizedBox(
            child: StreamBuilder<MediaCapture?>(
              stream: state.captureState$,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                } else {
                  return SizedBox(
                    child: photostack.isEmpty
                        ? Container()
                        : AwesomeMediaPreview(
                      mediaCapture: snapshot.data,
                      onMediaTap: (MediaCapture mediaCapture) {
                        nextpage("preview");
                      },
                    ),
                  );
                }
              },
            ),
          )
        ),
        right: Container(
          width: size.width * 0.15,
          height: size.width * 0.1,
          child: TextButton(
            onPressed: () {
              nextpage("");
            },
            child: Text("완료",
                style: TextStyle(color: Colors.white, fontFamily: "NSB"),
                textScaleFactor: 1.3),
          ),
        ),
      ),
    );
  }
}