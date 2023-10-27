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

late String _url;
bool isloading = false;

Future<void> settingIP() async {
  try {
    _url = "";
  } on IpAddressException catch (e) {
    print(e.message);
  }
}

Future<void> settingIP2() async {
  try {
    _url = "";
  } on IpAddressException catch (e) {
    print(e.message);
  }
}

Future<List<dynamic>> get_event_posts(int page) async {
  await settingIP2();
  String? _token = await storage.read(key: "fastapi_token");
  String url1 = "$_url/event_posts?page=$page";

  late List<dynamic> datas;
  try {
    if (_token != null) {
      http.Response response = await http.get(
        Uri.parse(url1),
        headers: {'Content-Type': 'application/json', 'authorization': _token},
      );
      if (200 <= response.statusCode && response.statusCode < 300) {
        datas = jsonDecode(utf8.decode(response.bodyBytes));
      }
    }
  } catch (e) {
    print(e);
    datas = [];
  }
  return datas;
}

Future<List<dynamic>> get_user_posts(String phonenum) async {
  await settingIP2();
  String? _token = await storage.read(key: "fastapi_token");
  String url1 = "$_url/my_event_posts?phonenum=$phonenum";

  late List<dynamic> datas;
  try {
    if (_token != null) {
      http.Response response = await http.get(
        Uri.parse(url1),
        headers: {'Content-Type': 'application/json', 'authorization': _token},
      );
      if (200 <= response.statusCode && response.statusCode < 300) {
        datas = jsonDecode(utf8.decode(response.bodyBytes));
      }
    }
  } catch (e) {
    print(e);
    datas = [];
  }
  return datas;
}

Future<List<dynamic>> get_last_top_10_likes() async {   //지난 주

  await settingIP2();
  String? _token = await storage.read(key: "fastapi_token");
  String url1 = "$_url/likes/last_top10";
  late List<dynamic> datas;
  try {
    if (_token != null) {
      http.Response response = await http.get(
        Uri.parse(url1),
        headers: {'Content-Type': 'application/json', 'authorization': _token},
      );
      if (200 <= response.statusCode && response.statusCode < 300) {
        datas = jsonDecode(utf8.decode(response.bodyBytes));
      }
    }
  } catch (e) {
    print(e);
    datas = [];
  }
  return datas;
}

Future<List<dynamic>> get_last_top10_subinfo() async {   //지난 주

  await settingIP2();
  String? _token = await storage.read(key: "fastapi_token");
  String url1 = "$_url/likes/last_top10_subinfo";

  late List<dynamic> datas;
  try {
    if (_token != null) {
      http.Response response = await http.get(
        Uri.parse(url1),
        headers: {'Content-Type': 'application/json', 'authorization': _token},
      );
      if (200 <= response.statusCode && response.statusCode < 300) {
        datas = jsonDecode(utf8.decode(response.bodyBytes));
      }
    }
  } catch (e) {
    print(e);
    datas = [];
  }
  return datas;
}

Future<List<dynamic>> get_total_top_10_likes() async {  // 역대 가장 많은.

  await settingIP2();
  String? _token = await storage.read(key: "fastapi_token");
  String url1 = "$_url/likes/total_top10";

  late List<dynamic> datas;
  try {
    if (_token != null) {
      http.Response response = await http.get(
        Uri.parse(url1),
        headers: {'Content-Type': 'application/json', 'authorization': _token},
      );
      if (200 <= response.statusCode && response.statusCode < 300) {
        datas = jsonDecode(utf8.decode(response.bodyBytes));
      }
    }
  } catch (e) {
    print(e);
    datas = [];
  }
  return datas;
}

Future<bool> like_post(post_id, phonenum) async {     // 버튼 동작 함수.

  await settingIP2();
  String? _token = await storage.read(key: "fastapi_token");
  String url1 = "$_url/like_post/?post_id=$post_id&phonenum=$phonenum";

  print("----------------------like_post-----------------------");
  print(url1);
  try {
    if (_token != null) {
      http.Response response = await http.get(
        Uri.parse(url1),
        headers: {'Content-Type': 'application/json', 'authorization': _token},
      );
      print("like_post : ${response.statusCode}");
      if (200 <= response.statusCode && response.statusCode < 300) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        if(jsonResponse["status"] == "true"){return true;}        // 좋아요를 눌렀다면 true,  아니라면 false
      }
    }
  } catch (e) {
    print(e);
  }
  return false;
}

Future<bool> if_like_post(post_id, phonenum) async {    // 해당 게시물 좋아요 버튼 search.

  await settingIP2();
  String? _token = await storage.read(key: "fastapi_token");
  String url1 = "$_url/if_like_post/?post_id=$post_id&phonenum=$phonenum";

  print("----------------------if_like_post-----------------------");
  print(url1);
  try {
    if (_token != null) {
      http.Response response = await http.get(
        Uri.parse(url1),
        headers: {'Content-Type': 'application/json', 'authorization': _token},
      );
      print("if_like_post : ${response.statusCode}");
      if (200 <= response.statusCode && response.statusCode < 300) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        print(jsonResponse["status"]);
        if(jsonResponse["status"] == "true"){return true;}        // 좋아요를 눌렀다면 true,  아니라면 false
      }
    }
  } catch (e) {
    print(e);
  }
  return false;
}

Future<List<dynamic>> search_like_post(phonenum) async {      //내가 누른 모든 좋아요 게시물의 수

  await settingIP2();
  String? _token = await storage.read(key: "fastapi_token");
  String url1 = "$_url/search_like_post/?phonenum=$phonenum";
  List<dynamic> result = [];
  print("----------------------search_like_post-----------------------");
  print(url1);
  try {
    if (_token != null) {
      http.Response response = await http.get(
        Uri.parse(url1),
        headers: {'Content-Type': 'application/json', 'authorization': _token},
      );
      if (200 <= response.statusCode && response.statusCode < 300) {
        result = jsonDecode(response.body);
        return result;
      }
    }
  } catch (e) {
    print(e);
  }
  return result;
}

Future<List<dynamic>> search_like_posts_withid(List<String> _id_data) async {      //내가 누른 모든 좋아요 게시물의 정보

  await settingIP2();
  String? _token = await storage.read(key: "fastapi_token");
  String url1 = "$_url/search_like_posts_withid/";
  List<dynamic> result = [];

  try {
    if (_token != null) {
      http.Response response = await http.post(
        Uri.parse(url1),
        headers: {'Content-Type': 'application/json', 'authorization': _token},
        body: jsonEncode({"ids": _id_data})
      );
      if (200 <= response.statusCode && response.statusCode < 300) {
        result = json.decode(utf8.decode(response.bodyBytes));
        return result;
      }
    }
  } catch (e) {
    print(e);
  }
  return result;
}

Future<int> search_posts_likenum(post_id) async {

  await settingIP2();
  String? _token = await storage.read(key: "fastapi_token");
  String url1 = "$_url/total_like_post/?post_id=$post_id";

  try {
    if (_token != null) {
      http.Response response = await http.get(
        Uri.parse(url1),
        headers: {'Content-Type': 'application/json', 'authorization': _token},
      );
      if (200 <= response.statusCode && response.statusCode < 300) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        return jsonResponse["like"];
      }
    }
  } catch (e) {
    print(e);
  }
  return 0;
}


Future<Map<String, dynamic>?> get_event_point(String phonenum) async {
  await settingIP2();
  String url1 = "$_url/get_event_point/?phonenum=$phonenum";
  print(url1);
  try {
    final response = await http.get(Uri.parse(url1));

    if (200 <= response.statusCode && response.statusCode < 300) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    }
  } catch (e) {
    print(e);
    return null;
  }
}

Future<bool> update_event_point(String phonenum, int point) async {
  await settingIP2();
  String url1 = "$_url/update_event_point/?phonenum=$phonenum&increment=$point";
  print(url1);
  String? _token = await storage.read(key: "fastapi_token");
  try {
    if(_token != null)
    {
      final response = await http.get(
        Uri.parse(url1),
        // 헤더에 토큰 추가
        headers: {
          'authorization': _token,
        },
      );

      if (200 <= response.statusCode && response.statusCode < 300) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        if(jsonResponse["status"] == "true"){return true;}
      }
    }
  } catch (e) {
    print(e);
  }
  return false;
}

// Spring boot로 보내기   ->    보낸 이후 받은 id 값을   FastApi로 보내기.
Future<bool> sent_event_data(String _nickname, String _phonenum, String title, String hashtag,List<File> _images) async {
  await settingIP();
  String? _token = await storage.read(key: "fastapi_token");

  //print(_nickname);
  String url1 = _url + "/resources10";
  print("----------------------sent_event_image-----------------------");
  print(url1);

  var request = http.MultipartRequest("POST", Uri.parse(url1));
  String? token = await storage.read(key: "token");

  if (token != null) {
    print(token);
    request.headers["authorization"] = token;
  }

  bool post_from = false;
  bool make_objects = false;
  late List<Map> img_info = [];

  try {
    for (int i = 0; i < _images.length; i++) {
      print("sent_event_image 이미지확인용===============================");
      print("sent_event_image 이미지확인용===============================");
      img_info.add({
        'name': _nickname,
        'phonenum': _phonenum,
        'address': title,
        'num': 0,
        'resourceNum': hashtag,
      });
      request.files.add(
          await http.MultipartFile.fromPath('images', _images[i].path));
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


// Spring boot 이후.
Future<bool> make_post(phonenum) async {

  await settingIP2();
  String? _token = await storage.read(key: "fastapi_token");
  String url1 = "$_url/make_post/?phonenum=$phonenum";

  print("----------------------make post-----------------------");
  print(url1);
  try {
    if (_token != null) {
      http.Response response = await http.get(
        Uri.parse(url1),
        headers: {'Content-Type': 'application/json', 'authorization': _token},
      );
      if (200 <= response.statusCode && response.statusCode < 300) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        if(jsonResponse["status"] == "true"){return true;}
      }
    }
  } catch (e) {
    print(e);
  }
  return false;
}
