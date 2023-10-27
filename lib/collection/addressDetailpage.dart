import 'package:ecocycle/collection/resource_transaction.dart';
import 'package:ecocycle/customlibrary/textanimation.dart';
import 'package:ecocycle/main/mainpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:ui';

import '../user/User_Storage.dart';

class addressdetail extends StatefulWidget {
  @override
  _addressdetail createState() => _addressdetail();
}

class _addressdetail extends State<addressdetail> {
  late Size size;
  late final args;
  late TextEditingController addressnicknameForm;


  bool isloading = true;
  String appbarname =  "";

  String searching_building =  "";
  String searching_address =  "";
  String nickname = "";
  String city = "";
  String zipcode = "";

  Future<void> getdata() async {
    args = await Get.arguments;
    appbarname = args[0];

    searching_address = args[1];
    searching_building = args[2];
    zipcode = args[3];

    if(searching_address == ""){
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      String lat = position.latitude.toString();
      String lon = position.longitude.toString();

      //이 부분이 코딩셰프님 영상과 차이가 있다. 플러터 버젼업이 되면서 이 메소드를 써야 제대로 uri를 인식한다.
      var response = await get(
          Uri.parse("https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?request=coordsToaddr&coords=${lon},${lat}&sourcecrs=epsg:4326&orders=roadaddr&output=json"), headers: {
        "X-NCP-APIGW-API-KEY-ID": "pzdsuhnbzy", "X-NCP-APIGW-API-KEY" : "qv6jkCpI4XwalcB3m8hZfgv2NO0tj6ch05ABZjje"});

      // 미리 만들어둔 headers map을 헤더에 넣어준다.
      String jsonData = response.body;
      var addressdata = jsonDecode(jsonData)["results"][0];

      city = addressdata["region"]["area1"]["alias"];
      String city2 = addressdata["region"]["area2"]["name"];
      String road = addressdata["land"]["name"];
      String building1 = addressdata["land"]["number1"];
      String building2 = addressdata["land"]["number2"];

      searching_building = addressdata["land"]["addition0"]["value"];
      zipcode = addressdata["land"]["addition1"]["value"];
      searching_address = "$city $city2 $road $building1-$building2";
    }
    else{
      int firstSpace = searching_address.indexOf(' ');
      city = searching_address.substring(0, firstSpace);
    }

    int lastSpace = searching_address.lastIndexOf(' ');
    if(searching_building != ""){
      searching_building = "${searching_address.substring(lastSpace + 1)}($searching_building)";
    }
    else{
      searching_building = searching_address.substring(lastSpace + 1);
    }
    searching_address = searching_address.substring(0, lastSpace);

    print(zipcode);
    print(city);
    print(searching_address);
    print(searching_building);
  }

  Future<void> setAddress() async {
    List<dynamic> val = await getAddressData2();
    Address address = Address(
        addressnicknameForm.text,
        zipcode,
        city,
        searching_address,
        searching_building);

    val.add(address);

    print(val.length);
    int index = val.length - 1 ;

    await storage.write(key: 'address', value: jsonEncode(val));
    await storage.write(key: 'addressnum', value: index.toString());
  }

  void movepage(){
    Get.offAll(() => mainpage(), arguments: [2]);
    Get.to(() => transactionpage());
  }

  @override
  void initState() {
    super.initState();
    addressnicknameForm = TextEditingController();
    getdata().then((_){
      setState(() {
        isloading = false;
      });
    });
  }

  @override
  void dispose() {
    addressnicknameForm.dispose();
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

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: mainappbar(),
        body: mainbody(),
      ),
    );
  }

  AppBar mainappbar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: const IconThemeData(
        color: Colors.black, //change your color here
      ),
      title: Text(appbarname,
          style: TextStyle(color: Colors.black, fontFamily: "HanM", fontSize: size.width*0.04)),
      centerTitle: true,
    );
  }

  Widget mainbody() {
    return isloading ? Container(
      width: size.width,
      height: size.height,
      color: Colors.white,
      child: BouncingTextAnimation() ,
    ): Container(
      width: size.width,
      height: size.height,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          input_address(),
          input_addressnickname(),
          Expanded(child: Container()),
          SafeArea(
            child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery
                        .of(context)
                        .viewInsets
                        .bottom) +
                    EdgeInsets.only(
                        top: size.height * 0.01,
                        bottom: size.height * 0.01),
                child: SizedBox(
                    width: size.width * 0.9,
                    height: size.height * 0.08,
                    child: next_button()
                )),
          )
        ],
      ),
    );
  }

  Widget input_address() {
    return Container(
        margin: EdgeInsets.all(size.height * 0.02),
        width: size.width*0.8,
        height: size.height*0.1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(searching_address,style: const TextStyle(fontFamily: "HanM", color: Colors.black),textScaleFactor: 1.5,),
            Text(searching_building,style: const TextStyle(fontFamily: "HanM", color: Colors.black54),textScaleFactor: 1.2),
          ],
        ));
  }

  Widget input_addressnickname() {
    return Container(
        margin: EdgeInsets.all(size.height * 0.02),
        child: TextFormField(
          controller: addressnicknameForm,
          enabled: true,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.home_work_outlined, color: Colors.black38),
            hintText: "별칭",
            border: InputBorder.none,
          ),
        ));
  }

  Widget next_button() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Color(0xff47ABFF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      onPressed: () async {
        print("setaddress");
        await setAddress().then((_){
          movepage();
        });
      },
      child: const Text(
        '완료',
        style: TextStyle(fontFamily: "NSB"),
        textScaleFactor: 1.2,
      ),
    );
  }
}
