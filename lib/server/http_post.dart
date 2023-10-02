import 'dart:typed_data';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../collection/photo.dart';
import '../user/User.dart';
import '../user/User_Storage.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'dart:convert';

late String url;
bool isloading = false;

Future<void> settingIP() async {
  try {
    var ipAddress = IpAddress(type: RequestType.json);
    dynamic data = await ipAddress.getIpAddress();
    url = "";
  } on IpAddressException catch (e) {
    print(e.message);
  }
}

Future<void> settingIP2() async {
  try {
    var ipAddress = IpAddress(type: RequestType.json);
    dynamic data = await ipAddress.getIpAddress();
    url = "";
  } on IpAddressException catch (e) {
    print(e.message);
  }
}

Future<bool> check_connect() async {
  late bool connect;

  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    // I am connected to a mobile network.
    connect = true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    // I am connected to a wifi network.
    connect = true;
  } else {
    connect = false;
  }
  print(connectivityResult);
  print(connect);
  return connect;
}

// SplashScreen 서버 연동 부분
Future<String> getcondition() async {
  await settingIP();
  String url1 = url + "/";
  String cond = "false";
  Map appversion = {"appversion": "1.0.0"};
  var body = json.encode(appversion);

  try {
    http.Response response = await http
        .post(Uri.parse(url1),
            headers: {'Content-Type': 'application/json'}, body: body)
        .timeout(const Duration(seconds: 5));
    if (jsonDecode(response.body)["connection"] == "true") {
      cond = "true";
      print("앱 버전 확인 완료");
    } else {
      print(response.statusCode);
      print("앱 버전이 다릅니다.");
    }
  } catch (error) {
    print("서버연결 실패");
    cond = "error";
  }
  return cond;
}

Future<String> post_sms(String data) async {
  await settingIP();
  String url1 = url + "/sms/send";

  late Map smssend;
  String authcode = "";
  print(data);
  smssend = {
    "to": data,
  };

  var body = json.encode(smssend);

  try {
    http.Response response = await http.post(
      Uri.parse(url1),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    authcode = jsonDecode(response.body)["authcode"];
  } catch (e) {
    print(e);
    authcode = "error";
  }
  return authcode;
}

// Signup1 핸드폰 번호 가입 조회 부분
Future<bool> check_signup() async {
  await settingIP();
  String url1 = url + "/search_user";
  bool cond = false;

  Map phonenumber = {
    "type": "0",
    "data": user.phonenumber,
  };

  var body = json.encode(phonenumber);
  try {
    http.Response response = await http.post(
      Uri.parse(url1),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    if (jsonDecode(response.body)["user"] == "false") {
      cond = true;
      print("signup 핸드폰 번호 가입 조회 완료");
    } else {
      cond = false;
    }
  } catch (e) {
    print(e);
    print("signup 핸드폰 번호 가입 조회 실패");
  }
  return cond;
}

// Signup 회원가입 서버 전송 부분
Future<bool> post_signup() async {
  await settingIP();

  String url1 = "$url/signup";
  bool cond = false;

  var request = http.MultipartRequest("POST", Uri.parse(url1));

  Map userinfo = {
    "name": user.name,
    "nickname": user.nickname,
    "birthday": user.birthday,
    "phonenum": user.phonenumber,
    "email": user.email,
    "password": user.password,
  };

  Map addressinfo = {
    "zipcode": user.zipcode,
    "address1": user.address1,
    "address2": user.address2,
    "address3": user.address3,
    "address4": user.address4,
    "address5": user.address5,
    "nickname": user.addressnickname,
  };

  request.fields['userPostDto'] = jsonEncode(userinfo);
  request.fields['addressEntity'] = jsonEncode(addressinfo);

  print(request.fields['userPostDto']);
  print(request.fields['addressEntity']);

  ByteData bytes = await rootBundle.load(user.profile);
  var buffer = bytes.buffer.asUint8List();

  request.files.add(await http.MultipartFile.fromBytes('profile', buffer, filename: "${user.name}.png"));

  try {
    print(request);
    var response = await request.send();
    print(response.statusCode);
    print(response);
    if (200 <= response.statusCode && response.statusCode < 300) {
      print(response.stream.bytesToString());
      if (response.stream.bytesToString() == "true") {
        Future.delayed(
          Duration(seconds: 1),
          () async {
            cond = await post_login(0, user.phonenumber, user.password);
          },
        );
        if (cond == true) {
          user.init();
        }
      }
    }
  } catch (e) {
    print(e);
    print("회원가입 실패");
  }
  return cond;
}

Future<bool> post_login(int type, String userid, String userpw) async {
  await settingIP();
  String url1 = url + "/v11/auth/login";
  bool cond = false;
  late Map logindata;

  logindata = {"username": userid, "password": userpw};

  var body = json.encode(logindata);

  try {
    http.Response response = await http.post(
      Uri.parse(url1),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    if (response.statusCode == 200) {
      if (response.body == "Success") {
        var val1 = jsonEncode(logindata);
        var _token = response.headers['authorization'];

        await storage.write(
          key: 'login',
          value: val1,
        );
        await storage.write(key: 'token', value: _token);
        if(type == 1){
          cond = true;
        }
        else{
          cond = await get_user_data(type, userid, _token!);
        }
        print("로그인 완료");
      }
    }
  } catch (e) {
    print(e);
    print("로그인 실패");
  }
  return cond;
}

Future<bool> get_user_data(int type, String userid, String _token) async {
  await settingIP();
  String url1 = url + "/User/get";
  bool cond = false;
  late Map logindata;

  logindata = {"type": type, "data": userid};

  var body = json.encode(logindata);

  try {
    http.Response response = await http.post(
      Uri.parse(url1),
      headers: {'Content-Type': 'application/json', 'authorization': _token},
      body: body,
    );
    print(response.statusCode);
    if (response.statusCode == 202) {
      var requests = jsonDecode(utf8.decode(response.bodyBytes));
      String imagepath = await convert_file(requests[0]["profile"]);

      String val1 = jsonEncode(Userdata(requests[0]["name"], requests[0]["nickname"], requests[0]["phonenum"], "", imagepath));
      List<Address> val2 = [];
      for (var request in requests) {
        Address address = Address(
            request["addressNickname"],
            request["zipcode"],
            request["address1"],
            request["address1"] + " " + request["address2"] + " " + request["address3"] + " " + request["address4"],
            request["address5"]);
        val2.add(address);
      }
      String val3 = jsonEncode(transaction(0, 0));

      await storage.write(key: 'userdata', value: val1);
      await storage.write(key: 'address', value: jsonEncode(val2));
      await storage.write(key: 'transnum', value: val3);
      cond = true;
    }
  } catch (e) {
    print(e);
    print("로그인 실패");
  }
  return cond;
}

Future<String> post_searchpw(int type, String data) async {
  await settingIP();
  String url1 = url + "/login/searchpw";
  String user_in = "";
  late Map searchpw;

  if (type == 0) {
    searchpw = {
      "type": "0",
      "data": data,
    };
  } else {
    searchpw = {
      "type": "1",
      "data": data,
    };
  }
  var body = json.encode(searchpw);
  try {
    http.Response response = await http.post(
      Uri.parse(url1),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    user_in = jsonDecode(response.body)["user"];
  } catch (e) {
    print(e);
    user_in = "";
  }
  return user_in;
}

Future<String> post_changepw(int type, String data, String userpw) async {
  await settingIP();
  String url1 = url + "/login/changepw";
  late Map changepw;
  String cond = "";
  if (type == 0) {
    changepw = {"type": "0", "data": data, "userpw": userpw};
  } else {
    changepw = {"type": "1", "data": data, "userpw": userpw};
  }
  var body = json.encode(changepw);
  try {
    http.Response response = await http.post(
      Uri.parse(url1),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    cond = jsonDecode(response.body)["change"];
  } catch (e) {
    print(e);
  }
  return cond;
}

Future<bool> sent_trash_image(
    Map<String, dynamic>? userdata, String address, List<Map<String, String>> fileinfo) async {

  await settingIP();

  print(userdata);
  String url1 = url + "/resources2";

  print("----------------------resources2-----------------------");
  print(url1);

  var request = new http.MultipartRequest("POST", Uri.parse(url1));
  String? token = await storage.read(key: "token");
  if (token != null) {
    print(token);
    request.headers["authorization"] = token;
  }

  bool post_from = false;
  bool make_objects = false;
  late List<Map> img_info = [];

  try {
    for (int i = 0; i < fileinfo.length; i++) {
      print("이미지확인용===============================");
      print(fileinfo[i]['path']!);
      print("이미지확인용===============================");
      img_info.add({
        'name': userdata!['nickname'],
        'phonenum': i == 0 ? userdata['phonenumber'] : null,
        'address': address,
        'num': i+1,
        'resourceNum': fileinfo[i]['info'],
      });
      request.files.add(
          await http.MultipartFile.fromPath('images', fileinfo[i]['path']!));
    }
    request.fields['requests'] = jsonEncode(img_info);
    make_objects = true;

    print(request.fields['requests']);

  } catch (e) {
    print(e);
    print("이미지 객체 생성 오류");
  }

  if (make_objects) {
    print("make objects = 성공");
    try {
      var response = await request.send();
      print(response.statusCode);

      if (response.statusCode == 200) {
        var responsedata = response.stream.bytesToString();
        print(responsedata);
        // jsonBody를 바탕으로 data 핸들링
        post_from = true;
      } else {
        // 200 안뜨면 에러
        post_from = false;
      }
    } catch (e) {
      Exception(e);
    }
  }
  return post_from;
}

Future<bool> sent_buy_info(Map<String, dynamic>? userdata, String address, Map<String, String> name_data, Map<String, String> number_data) async {
  await settingIP();

  print(userdata);
  String url1 = url + "/resources3";
  print("----------------------resources3-----------------------");
  print(url1);


  var request = new http.MultipartRequest("POST", Uri.parse(url1));
  String? token = await storage.read(key: "token");
  if (token != null) {
    print(token);
    request.headers["authorization"] = token;
  }

  bool post_from = false;
  bool make_objects = false;
  late List<Map> resources_info = [];
  int i = 0;
  try {
    for (var entry in name_data.entries) {
      print("자원확인용===============================");
      print(entry.value + " " + number_data[entry.key]!);
      print("자원확인용===============================");
      resources_info.add({
        'name': userdata!['nickname'],
        'phonenum': i == 0 ? userdata['phonenumber'] : null,
        'address': address,
        'num': number_data[entry.key],
        'resourceNum': entry.value,
      });
      i++;
    }

    request.fields['requests'] = jsonEncode(resources_info);
    make_objects = true;

    print(request.fields['requests']);

  } catch (e) {
    print(e);
  }

  if (make_objects) {
    print("make objects = 성공");
    try {
      var response = await request.send();
      print(response.statusCode);

      if (response.statusCode == 200) {
        var responsedata = response.stream.bytesToString();
        print(responsedata);
        // jsonBody를 바탕으로 data 핸들링
        post_from = true;
      } else {
        // 200 안뜨면 에러
        post_from = false;
      }
    } catch (e) {
      Exception(e);
    }
  }
  return post_from;
}


Future<http.Response> fetchImage(String imagepath) async {
  await settingIP2();
  String url1 = "$url/get_resource_images/?image_path=$imagepath";
  print(url1);
  return await http.get(Uri.parse(url1));
}

Future<http.Response> fetchGraph(String address, String resource) async {
  await settingIP2();
  String url1 = "$url/get_graph_images/?location=$address&resource=$resource";
  print(url1);
  return await http.get(Uri.parse(url1));
}

Future<Map<String, dynamic>?> Other_Profile(String phonenum) async {
  await settingIP2();
  String url1 = "$url/get_profile/?phonenum=$phonenum";
  print(url1);

  try {
    final response = await http.get(Uri.parse(url1));
    print(response.statusCode);
    print(response.body);
    if (200 <= response.statusCode && response.statusCode < 300) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    }
  } catch (e) {
    print(e);
    return null;
  }
}

Future<Map<String, dynamic>?> Update_point(String phonenum, int point) async {
  await settingIP2();
  String url1 = "$url/update_points/?phonenum=$phonenum&points=$point";
  print(url1);
  try {
    final response = await http.get(Uri.parse(url1));
    print(response.statusCode);
    print(response.body);
    if (200 <= response.statusCode && response.statusCode < 300) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    }
  } catch (e) {
    print(e);
    return null;
  }
}

Future<bool> success_trans_sale(String _id, String _token) async {
  await settingIP();

  bool check = true;

  String url1 = url + "/enrollResources1/$_id";
  print("----------------------enrollResources1-----------------------");
  print(url1);

  try {
    http.Response response = await http.get(Uri.parse(url1), headers: {'Content-Type': 'application/json', 'authorization': _token});
    print(response.statusCode);
    print(response.body);
    if (200 <= response.statusCode && response.statusCode < 300) {
      check = true;
    }
  } catch (e) {
    print(e);

    check = false;
  }

  return check;
}

Future<bool> success_trans_buy(String _id, String _token) async {
  await settingIP();

  bool check = true;

  String url1 = url + "/enrollResources2/$_id";
  print("----------------------enrollResources2-----------------------");
  print(url1);

  late Map<String, String> datas;

  try {
    http.Response response = await http.get(Uri.parse(url1), headers: {'Content-Type': 'application/json', 'authorization': _token});
    if (200 <= response.statusCode && response.statusCode < 300) {
      datas = jsonDecode(utf8.decode(response.bodyBytes));
    }
  } catch (e) {
    print(e);
    datas = {
      "status": "false"
    };
    check = false;
  }
  print(datas);

  return false;
}



Future<Map<String, dynamic>> getSaleResources(
    int page, String _token) async {
  //await settingIP();
  /*
  String phonenum = args[0];
  String address = args[1];
  List<Map<String,String>> fileinfo = args[2];
   */
  await settingIP();

  //String url1 = url + "/getResources";
  String url1 = url + "/getResources?page=$page";

  print("----------------------getResources-----------------------");
  print(url1);

  late Map<String, dynamic> datas;
  try {
    http.Response response = await http.get(
      Uri.parse(url1),
      headers: {'Content-Type': 'application/json', 'authorization': _token},
    );
    if (200 <= response.statusCode && response.statusCode < 300) {
      datas = jsonDecode(utf8.decode(response.bodyBytes));
    }
  } catch (e) {
    print(e);
    datas = {
      "body": [], "pagination": {"page": 0, "size": 10, "cuurentElement": 0, "totalpage": 0, "totalElemnet": 0}
    };
  }
  return datas;
}

Future<Map<String, dynamic>> getBuyResources(int page, String _token) async {
  //await settingIP();
  /*
  String phonenum = args[0];
  String address = args[1];
  List<Map<String,String>> fileinfo = args[2];
   */
  await settingIP();

  String url1 = url + "/getResources3?page=$page";
  print("----------------------getResources3-----------------------");
  print(url1);
  late Map<String, dynamic> datas;
  try {
    http.Response response = await http.get(
      Uri.parse(url1),
      headers: {'Content-Type': 'application/json', 'authorization': _token},
    );
    if (200 <= response.statusCode && response.statusCode < 300) {
      datas = jsonDecode(utf8.decode(response.bodyBytes));
    }
  } catch (e) {
    print(e);
    datas = {
      "body": [], "pagination": {"page": 0, "size": 10, "cuurentElement": 0, "totalpage": 0, "totalElemnet": 0}
    };
  }
  print(datas);

  print(datas["pagination"]);
  return datas;
}

Future<Map<String, dynamic>> getmyUsage(String phonenum, int page, String _token) async {
  await settingIP();

  String url1 = url + "/getMyResources/$phonenum";
  print("----------------------getMyResources-----------------------");
  print(url1);
  late Map<String, dynamic> datas;
  try {
    http.Response response = await http.get(
      Uri.parse(url1),
      headers: {'Content-Type': 'application/json', 'authorization': _token},
    );

    print(response.statusCode);

    if (200 <= response.statusCode && response.statusCode < 300) {
      datas = jsonDecode(utf8.decode(response.bodyBytes));
    }
  } catch (e) {
    print(e);
    datas = {
      "api": {"body": [], "pagination": {"page": 0, "size": 10, "cuurentElement": 0, "totalpage": 0, "totalElemnet": 0}}
    };
  }

  return datas;
}


Future<void> example() async {
  await settingIP();
  String url1 = url + "/example";
  late Map example;

  example = {"name": ""};

  var body = json.encode(example);

  try {
    http.Response response = await http.post(
      Uri.parse(url1),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    print(jsonDecode(response.body));
  } catch (e) {
    print(e);
  }
}
