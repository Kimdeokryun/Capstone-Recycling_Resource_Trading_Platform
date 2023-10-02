import 'package:ecocycle/collection/resource_transaction.dart';
import 'package:flutter/material.dart';
import '../customlibrary/textanimation.dart';
import '../server/http_post.dart';
import '../main/mainpage.dart';
import 'package:get/get.dart';
import '../user/User_Storage.dart';
import 'dart:async';
import '../customlibrary/dialog.dart';
import './buy_page.dart';

Future<String> getAddress() async {
  late String _result;
  List<dynamic>? addresslist = await getAddressData();
  Map<String, dynamic> address = addresslist![0];
  print(address);
  _result =
      "${address['address1']} ${address['address2']} ${address['address3']} ${address['address4']}";
  return _result;
}

class make_buy_page extends StatefulWidget {
  @override
  _make_buy_page createState() => _make_buy_page();
}

class _make_buy_page extends State<make_buy_page> {
  late Size size;
  late bool graphloading = false;

  late bool isblank;

  Map<String, String> select_category = {
    "0": "PE",
    "1": "PET",
    "2": "PP",
    "3": "알루미늄캔",
    "4": "철스크랩",
    "5": "철캔",
    "6": "갈색 유리병",
    "7": "백색 유리병",
    "8": "청녹색 유리병",
    "9": "ABS",
    "10": "F PE",
    "11": "F PET 무색",
    "12": "F PET 복합",
    "13": "F PET 유색",
    "14": "F PP",
    "15": "F PS",
    "16": "F PVC",
    "17": "기타"
  };

  Map<String, bool> category_press = {};

  late TextEditingController name_controller;
  Map<String, TextEditingController> number_controllers = {};
  Map<String, TextEditingController> price_controllers = {};

  Map<String, String> name_data = {};
  Map<String, String> number_data = {};
  Map<String, String> price_data = {};

  String _temp_name = "";
  String _temp_number = "";
  String _temp_price = "";

  void Add_Text_Controller(key)
  {
    number_controllers[key] = TextEditingController();
    price_controllers[key] = TextEditingController();
  }

  void move(where) {
    if (where == "home") {
      Get.offAll(() => mainpage(), arguments: [2]);
    }
    if (where == "registration") {
      isblank = false;
      for(var key in category_press.keys)
      {
        if(category_press[key] == true)
        {
          if(key == "17")
          {
            _temp_name = name_controller.text;

            if(_temp_name == "")
            {
              setState(() {
                isblank = true;
              });
              break;
            }

            name_data[key] = _temp_name;
          }
          else
          {
            name_data[key] = select_category[key]!;
          }
          _temp_number = number_controllers[key]!.text;
          _temp_price = price_controllers[key]!.text;

          if(_temp_number == "" && _temp_price == "")
          {
            setState(() {
              isblank = true;
            });
            break;
          }

          number_data[key] = _temp_number;
          price_data[key] = _temp_price;
        }
      }
      if(!isblank)
      {
        if(name_data.isEmpty)
        {
          Othererror("입력 오류" ,"편집하기를 통해\n자원을 추가해주세요.").showErrorDialog(context);
        }
        else{
          Get.offAll(() => mainpage());
          Get.to(transactionpage());
          Get.to(buy_page(), arguments: [0, name_data, number_data, price_data]);
        }

      }
      else
      {
        Othererror("입력 오류" ,"빈 칸을 모두 채워주세요.").showErrorDialog(context);
      }
    }
  }

  void editfunc() {
    Get.bottomSheet(
      isDismissible: false,
        isScrollControlled: false,
        StatefulBuilder(
          builder: (BuildContext context, StateSetter modalSetState) {
            return Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: size.width,
                height: size.height * 0.6,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                ),
                child: Column(
                  children: [
                    Container(
                      margin:
                      EdgeInsets.only(top: size.height * 0.01, bottom: size.height * 0.01),
                      child:
                      const Center(
                          child: Text("자원 선택", style: TextStyle(color :Colors.black, fontFamily :"HanB"), textScaleFactor :1.5)),
                    ),
                    // 로그인 방법 선택 부분과 거리를 두기 위함.
                    Container(
                        width :size.width,
                        child : selecttable(modalSetState)
                    )
                  ],
                ),
              ),
            );
          },
        )
    );
  }

  Widget selecttable(StateSetter setStateFunc)
  {
    return Container(
      child: Column(
        children: [
          middletitle("압축"),
          row_category1(setStateFunc),
          middletitle("폐금속류"),
          row_category2(setStateFunc),
          middletitle("폐유리병"),
          row_category3(setStateFunc),
          middletitle("플레이크"),
          row_category4(setStateFunc),
          row_category5(setStateFunc),
          row_category6(setStateFunc),
          row_category7(setStateFunc)
        ],
      ),
    );
  }

  Widget middletitle(text)
  {
    return Container(
      child: Text(
        text,
        style: const TextStyle(color: Color(0xff646464), fontFamily: "HanB"),
        textScaleFactor: 1,
      )
    );
  }

  Widget row_category1(StateSetter setStateFunc)
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        category(setStateFunc, "0", "PE"),
        category(setStateFunc, "1", "PET"),
        category(setStateFunc, "2", "PP"),
      ],
    );
  }

  Widget row_category2(StateSetter setStateFunc)
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        category(setStateFunc, "3", "알루미늄캔"),
        category(setStateFunc, "4", "철스크랩"),
        category(setStateFunc, "5", "철캔"),
      ],
    );
  }

  Widget row_category3(StateSetter setStateFunc)
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        category(setStateFunc, "6", "갈색"),
        category(setStateFunc, "7", "백색"),
        category(setStateFunc, "8", "청녹색"),
      ],
    );
  }

  Widget row_category4(StateSetter setStateFunc)
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        category(setStateFunc, "9", "ABS"),
        category(setStateFunc, "10", "PE"),
      ],
    );
  }

  Widget row_category5(StateSetter setStateFunc)
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        category(setStateFunc, "11", "PET무색"),
        category(setStateFunc, "12", "PET복합"),
        category(setStateFunc, "13", "PET유색"),
      ],
    );
  }

  Widget row_category6(StateSetter setStateFunc)
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        category(setStateFunc, "14", "PP"),
        category(setStateFunc, "15", "PS"),
        category(setStateFunc, "16", "PVC"),
      ],
    );
  }
  Widget row_category7(StateSetter setStateFunc)
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        category2(setStateFunc, "17", "기타"),
      ],
    );
  }


  Widget category(StateSetter setStateFunc, key_val, item_name)
  {
    bool selected = category_press[key_val] ?? false;
    return Padding(
      padding: EdgeInsets.all(size.width * 0.02),
      key: Key(key_val),
      child: GestureDetector(
        onTap: () {
          setStateFunc(() { // Use the modal's state setter here
            setState(() {
              category_press[key_val] = !selected;
              if(!selected == true)
              {
                Add_Text_Controller(key_val);
              }
              // false인 경우 category_press에서 해당 key값 삭제
              else
              {
                category_press.remove(key_val);
              }
            });
          });
        },
        child: Container(
          width: size.width * 0.25,
          height: size.height * 0.04,
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: selected ? Color(0xff47ABFF) : Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(100)),
              border: Border.all(color: Color(0xffE2E2E2), width: 1)
          ),
          child: Center(
              child: Text(item_name,
                  style: TextStyle(
                      fontFamily: "HanM",
                      color: selected ? Colors.white : Color(0xff646464),
                      fontSize: size.width * 0.03),
                  textAlign: TextAlign.center)),
        ),
      )
    );
  }

  Widget category2(StateSetter setStateFunc, key_val, item_name)
  {
    bool selected = category_press[key_val] ?? false;
    return Padding(
        padding: EdgeInsets.only(left: size.width * 0.02, right: size.width * 0.02, top:size.width * 0.02),
        key: Key(key_val),
        child: GestureDetector(
          onTap: () {
            setStateFunc(() { // Use the modal's state setter here
              setState(() {
                category_press[key_val] = !selected;
                if(!selected == true)
                {
                  Add_Text_Controller(key_val);
                }
                // false인 경우 category_press에서 해당 key값 삭제
                else
                {
                  category_press.remove(key_val);
                }
              });
            });
          },
          child: Container(
            width: size.width * 0.25,
            height: size.height * 0.04,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: selected ? Color(0xff47ABFF) : Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(100)),
                border: Border.all(color: Color(0xffE2E2E2), width: 1)
            ),
            child: Center(
                child: Text(item_name,
                    style: TextStyle(
                        fontFamily: "HanM",
                        color: selected ? Colors.white : Color(0xff646464),
                        fontSize: size.width * 0.03),
                    textAlign: TextAlign.center)),
          ),
        )
    );
  }



  @override
  void initState() {
    super.initState();
    name_controller = TextEditingController();
  }

  @override
  void dispose() {
    name_controller.dispose();
    for (var controller in number_controllers.values) {
      controller.dispose();
    }
    for (var controller in price_controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return isloading
        ? Center(
            child: BouncingTextAnimation(),
          )
        : GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: appbar(),
        body: _mainpage(),
      ),
    );
  }

  AppBar appbar() {
    return AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15)),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: const Text("구매 자원 등록",
            style: TextStyle(color: Colors.black, fontFamily: "HanM"),
            textScaleFactor: 1.2),
        centerTitle: true);
  }

  Widget _mainpage() {
    return
      SingleChildScrollView(
        child: Container(
          width: size.width,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(height: size.height*0.05),
              buildmenu(),
              editbutton(),
              button(),
            ],
          ),
        )
      );
  }

  Widget buildmenu() {
    List<Widget> selectedCategoryWidgets = [];
    category_press.forEach((key, value) {
      if (value == true) {
        selectedCategoryWidgets.add(
          Container(
            padding: EdgeInsets.only(bottom: size.height*0.01),
            width: size.width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: select_category[key] == "기타" ? size.width*0.2 : size.width*0.4,
                  padding: select_category[key] == "기타" ? const EdgeInsets.all(0) : EdgeInsets.all(size.width*0.05),
                  margin: select_category[key] == "기타" ? EdgeInsets.only(left: size.width*0.05, right: size.width*0.15) : const EdgeInsets.all(0),
                  child: select_category[key] == "기타" ?  TextFormField(
                    key: Key(key),
                    controller: name_controller,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration( // 박스형 디자인 설정
                        border: OutlineInputBorder(), // 테두리 스타일 지정
                        hintText: "품목명"
                    ),
                  ) : Text(select_category[key]!, style: const TextStyle(fontFamily: "HanM", color: Colors.black), textScaleFactor: 1),
                ),
                Container(
                  width: size.width*0.25,
                  child: TextFormField(
                    key: Key(key),
                    controller: number_controllers[key],
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration( // 박스형 디자인 설정
                      border: OutlineInputBorder(), // 테두리 스타일 지정
                      hintText: "개수(무게)"
                    ),
                  ),

                  ),
                Container(
                  width: size.width*0.15,
                ),
                Container(
                  width: size.width*0.15,
                  child: TextFormField(
                    key: Key(key),
                    controller: price_controllers[key],
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration( // 박스형 디자인 설정
                      border: OutlineInputBorder(), // 테두리 스타일 지정
                      hintText: "가격"
                    ),
                  ),
                ),
                Container(
                  width: size.width*0.05,
                ),
              ],
            ),
          ), // Replace this with the widget you want to create for each selected category
        );
      }
      else
      {
        number_controllers[key]?.dispose();
        price_controllers[key]?.dispose();
      }
    });
    return Column(children: selectedCategoryWidgets);
  }

  Widget editbutton() {
    return Container(
      padding: EdgeInsets.all(size.width * 0.01),
      child: TextButton(
        onPressed: () {
          print("편집하기");
          editfunc();
        },
        child: const Text(
          "편집하기",
          style: TextStyle(
              color: Color(0xff646464),
              fontFamily: "HanM",
              decoration: TextDecoration.underline),
          textScaleFactor: 1.5,
        ),
      ),
    );
  }

  Widget button() {
    return Container(
      padding: EdgeInsets.only(top: size.height * 0.02),
      width: size.width * 0.8,
      height: size.height * 0.1,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color(0xff47ABFF),
        ),
        child: TextButton(
          onPressed: () {
            move("registration");
          },
          child: const Text(
            "등록하기",
            style: TextStyle(color: Colors.white, fontFamily: "HanM"),
            textScaleFactor: 1.5,
          ),
        ),
      ),
    );
  }
}
