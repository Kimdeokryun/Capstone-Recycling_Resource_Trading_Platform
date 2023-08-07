import 'package:ecocycle/start/signup4.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:remedi_kopo/remedi_kopo.dart';
import '../customlibrary/dialog.dart';
import '../customlibrary/textanimation.dart';
import '../user/User.dart';
import '../server/http_post.dart';
import 'package:get/get.dart';

class signup3 extends StatefulWidget {
  @override
  _signup3 createState() => _signup3();
}

class _signup3 extends State<signup3> {
  bool detailv = false;
  bool dwellv = false;
  bool exitv = false;
  bool nextv = false;

  int selnum = 0;
  int line = 0;

  int seldwell = -1;
  int selexit = -1;
  int selev = -1;
  int selpk = -1;

  String textaddress = "";
  String _buildname = "";

  String _zipcode = "";

  String changedetail = "";
  String changenick = "";

  late TextEditingController _address;
  late TextEditingController _addressnick;


  late ScrollController _scrollController;
  late KopoModel model;
  late String address;
  late List<String> addresslist;
  late Size size;

  FocusNode elsedetail = FocusNode();
  FocusNode elsedwell = FocusNode();
  FocusNode elseexit = FocusNode();

  late bool servercondition;

  void enablebutton() {
    if (changenick != "") {
      setState(() {
        nextv = true;
      });
    } else {
      setState(() {
        nextv = false;
      });
    }
  }

  Future<void> nextpage() async {
    bool connect = await check_connect();
    if (connect == false) {
      Connecterror().showErrorDialog(context);
    } else {
      setState(() {
        isloading = true;
      });
      user.init3();
      try {
        address = "";
        user.address1 = addresslist[0];
        user.address2 = addresslist[1];
        user.address3 = addresslist[2];
        user.address4 = addresslist[3];
        for (int i = 4; i < addresslist.length; i++) {
          user.address5 += " ${addresslist[i]}";
        }
      } catch (e) {
        print(e);
      }
      user.zipcode = _zipcode;
      user.address5 += "($_buildname)";
      user.addressnickname = _addressnick.text;
      // 백엔드와 통신 부분.
      Get.to(() => signup4());
    }
  }

  @override
  void initState() {
    super.initState();
    isloading = false;
    _scrollController = ScrollController();
    _address = TextEditingController();
    _addressnick = TextEditingController();
  }

  @override
  void dispose() {
    _address.dispose();
    _addressnick.dispose();
    elsedwell.dispose();
    elseexit.dispose();
    _scrollController.dispose();
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
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: const Text(
                textAlign: TextAlign.center,
                "회원가입",
                style: TextStyle(color: Colors.black, fontFamily: 'NSB'),
                textScaleFactor: 1,
              ),
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: const IconThemeData(
                color: Colors.black, //change your color here
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(size.height * 0.1),
                child: Container(
                    width: size.width * 0.8,
                    height: size.height * 0.1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selnum == 0
                              ? "어디에서\n사용하실 건가요?"
                              : !nextv
                                  ? "별명을\n입력해주세요"
                                  : "다음 버튼을\n눌러주세요.",
                          style:
                              TextStyle(color: Colors.black, fontFamily: "NSB"),
                          textScaleFactor: 1.8,
                        ),
                      ],
                    )),
              ),
            ),
            body: isloading
                ? Center(child: BouncingTextAnimation())
                : SafeArea(
                    child: Container(
                        color: Colors.white,
                        width: double.infinity,
                        child: Column(children: <Widget>[
                          Expanded(
                              child: SingleChildScrollView(
                                  controller: _scrollController,
                                  child: Column(children: [
                                    Container(
                                      margin:
                                          EdgeInsets.all(size.height * 0.01),
                                      width: size.width * 0.9,
                                      child: Column(
                                        children: [
                                          input_address(),
                                        ],
                                      ),
                                    ),
                                    Visibility(
                                        visible: detailv,
                                        child: Container(
                                            width: double.maxFinite,
                                            child: Column(children: [
                                              input_addressnick(),
                                            ])))
                                  ]))),
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
                        ])))));
  }

  Widget input_address() {
    return Container(
        margin: EdgeInsets.all(size.height * 0.01),
        child: GestureDetector(
          onTap: () async {
            //print("눌림");
            model = await Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => RemediKopo()),
            );
            setState(() {
              if (model != null) {
                if (model.zonecode != "" && model.address != "") {
                  address = model.address!;
                  _zipcode = model.zonecode!;
                  addresslist = address.split(" ");
                  if (address.length > 20) {
                    line = 0;
                    int currentline = 0;
                    textaddress = addresslist[0];
                    for (int i = 1; i < addresslist.length; i++) {
                      currentline =
                          ("$textaddress\n${addresslist[i]}").length ~/ 17;
                      if (currentline > line) {
                        line = currentline;
                        textaddress += "\n${addresslist[i]}";
                      } else {
                        textaddress += " ${addresslist[i]}";
                      }
                    }
                  } else {
                    textaddress = address;
                  }
                  if (model.buildingName != "") {
                    textaddress += "\n(${model.buildingName})";
                    line += 1;
                    _buildname = model.buildingName!;
                  }
                  _address = TextEditingController(text: textaddress);
                  detailv = true;
                  selnum = 1;
                }
              }
            });
          },
          child: TextFormField(
            controller: _address,
            enabled: false,
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              labelText: "주소",
            ),
            maxLines: line + 1,
            minLines: 1,
          ),
        ));
  }

  Widget input_addressnick() {
    return Container(
      width: size.width * 0.9,
      margin: EdgeInsets.all(size.height * 0.01),
      child: Container(
        margin: EdgeInsets.all(size.height * 0.01),
        child: TextFormField(
          controller: _addressnick,
          enabled: true,
          onChanged: (val) {
            setState(() {
              changenick = val;
            });
            enablebutton();
          },
          decoration: const InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            labelText: "별명",
            hintText: "집"
          ),
        ),
      ),
    );
  }

  Widget next_button() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Color(0xff47ABFF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      onPressed: nextv
          ? () {
              nextpage();
            }
          : null,
      child: const Text(
        '다음',
        style: TextStyle(fontFamily: "NSB"),
        textScaleFactor: 1.2,
      ),
    );
  }
}
