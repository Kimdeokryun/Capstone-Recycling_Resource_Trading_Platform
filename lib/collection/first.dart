import 'package:flutter/material.dart';
import '../customlibrary/textanimation.dart';
import '../server/http_post.dart';
import '../main/mainpage.dart';
import 'package:get/get.dart';
import '../user/User.dart';
import '../user/User_Storage.dart';
import './second.dart';
import 'dart:async';

Future<String> getAddress() async {
  late String _result;
  List<dynamic>? addresslist = await getAddressData();
  Map<String, dynamic> address = addresslist![0];
  print(address);
  _result = "${address['address1']} ${address['address2']} ${address['address3']} ${address['address4']}";
  return _result;
}

class collection1 extends StatefulWidget {
  @override
  _collection1 createState() => _collection1();
}

class _collection1 extends State<collection1> {
  late Size size;
  String _address = "";
  bool _isLoading = true;

  Future<void> address() async {
    _address = await getAddress();
  }

  void move(where){
    if(where == "home"){
      Get.offAll(() => mainpage());
    }
    if(where == "camera"){
      //collection2_main();
      svaddress.set(_address);
      Get.to(() => CameraPage());
    }
  }

  @override
  void initState() {
    super.initState();
    address().then((_) {
      setState(() {
        _isLoading = false; // 로딩 완료 플래그 설정
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
    return isloading ? Center(child: BouncingTextAnimation(),) : Scaffold(
      appBar: appbar(),
      body: _mainpage(),
    );
  }

  AppBar appbar(){
    return AppBar(
      toolbarHeight: size.height*0.05,
      backgroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15)
        ),
      ),
      iconTheme: const IconThemeData(
        color: Colors.black, //change your color here
      ),
      title: Text("자원 등록", style: TextStyle(color: Colors.black, fontFamily: "HanM"),textScaleFactor: 1.2),
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(size.height*0.05),
        child: Container(
          child: TextButton(
            onPressed: () {

            },                       //서버에서 가져온 값
            style: ButtonStyle(
                overlayColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    return Colors.transparent;
                  },
                )
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_address, style: TextStyle(color: Colors.black, fontFamily: "HanM"),textScaleFactor: 1),   //서버에서 가져온 최상위 값
                Icon(Icons.arrow_drop_down, color:Color(0xff47ABFF))
              ],
            ),
          ),
        ),
      ),
      actions: <Widget>[
        Padding(
            padding: EdgeInsets.only(right: size.width * 0.06),
            child: IconButton(
                onPressed: () {
                  move("home");
                },
                icon: Icon(Icons.home),
                color: Colors.black))
      ],
    );
  }
  
  Widget _mainpage() {
    return Container(
      width: size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: size.width*0.8,
            height: size.height*0.6,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, 1.0), //(x,y)
                  blurRadius: 1,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: size.height*0.05),
            width: size.width*0.8,
            height: size.height*0.125,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Color(0xff47ABFF),
              ),
              child: TextButton(
                onPressed: (){
                  move("camera");
                },
                child: Text(
                  "자원 사진 찍기", style: TextStyle(color: Colors.white, fontFamily: "HanM"),textScaleFactor: 1.5,
                ),
              ),
            ),
            
          )
        ],
      ),
    );
  }
}
