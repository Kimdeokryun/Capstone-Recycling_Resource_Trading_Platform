import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

// storage key: ["login", "token", "userdata", "address", "transnum"]

class Login {
  final String _status;
  Login(this._status);
  Login.fromJson(Map<String, dynamic> json) : _status = json['status'];
  Map<String, dynamic> toJson() => {'status': _status};
}

class Userdata {
  final String _name;
  final String _nickname;
  final String _phonenumber;
  final String _email;
  final String _profile;

  Userdata(this._name, this._nickname, this._phonenumber, this._email,
      this._profile);

  Userdata.fromJson(Map<String, dynamic> json)
      : _name = json['name'],
        _nickname = json['nickname'],
        _phonenumber = json['phonenumber'],
        _email = json['email'],
        _profile = json['profile'];

  Map<String, dynamic> toJson() => {
        'name': _name,
        'nickname': _nickname,
        'phonenumber': _phonenumber,
        'email': _email,
        'profile': _profile,
      };
}

class Address {
  final String nickname;
  final String zipcode;
  final String address1;
  final String address2;
  final String address3;
  final String address4;
  final String address5;

  Address(this.nickname, this.zipcode, this.address1, this.address2, this.address3,
      this.address4, this.address5);

  Address.fromJson(Map<String, dynamic> json)
      : nickname = json['nickname'],
        zipcode = json['zipcode'],
        address1 = json['address1'],
        address2 = json['address2'],
        address3 = json['address3'],
        address4 = json['address4'],
        address5 = json['address5'];

  Map<String, dynamic> toJson() => {
        'nickname' : nickname,
        'zipcode': zipcode,
        'address1': address1,
        'address2': address2,
        'address3': address3,
        'address4': address4,
        'address5': address5
      };
}

class transaction {
  final int _sales;
  final int _buy;

  transaction(this._sales, this._buy);
  transaction.fromJson(Map<String, dynamic> json)
      : _sales = json['sales'],
        _buy = json['buy'];

  Map<String, dynamic> toJson() => {
    'sales' : _sales,
    'buy': _buy,
  };
}


Future<Map<String, dynamic>?> getUserData() async {
  String? jsonString = await storage.read(key: 'userdata');
  if (jsonString != null) {
    Map<String, dynamic>? userdata = jsonDecode(jsonString);
    return userdata;
  }
  return null;
}

Future<List<dynamic>?> getAddressData() async {
  String? jsonString = await storage.read(key: 'address');
  if (jsonString != null) {
    List<dynamic>? addresslist = jsonDecode(jsonString);
    return addresslist;
  }
  return null;
}

Future<Map<String, dynamic>?> getTransData() async {
  String? jsonString = await storage.read(key: 'transnum');
  if (jsonString != null) {
    Map<String, dynamic>? transdata = jsonDecode(jsonString);
    return transdata;
  }
  return null;
}

Future<List<Map>> addressinfo(List<Map<String, String>> addresslist) async {
  List<Map> compile_addresslist = [];
  for (Map<String, String> address in addresslist) {
    print("address");
    compile_addresslist.add({
      'zipcode': address['zipcode'],
      'addresss1': address['addresss1'],
      'addresss2': address['addresss2'],
      'addresss3': address['addresss3'],
      'addresss4': address['addresss4'],
      'addresss5': address['addresss5']
    });
  }
  return compile_addresslist;
}


Future<Userdata?> getUser() async {
  String? jsonString = await storage.read(key: 'address');
  if (jsonString != null) {
    Userdata? addresslist = jsonDecode(jsonString);
    print(addresslist);
    print(addresslist.runtimeType);
  }
}

Future<List<Map<String, dynamic>>?> getAddress() async {
  String? jsonString = await storage.read(key: 'address');
  if (jsonString != null) {
    var addresslist = jsonDecode(jsonString);
    print(addresslist);
    print(addresslist.runtimeType);
  }
}

Future<String> getToken() async {
  String? _token = await storage.read(key: 'token');
  if (_token != null){
    return _token;
  }
  return "";
}

Future<List<dynamic>> getSalePage() async {
  String? existingData = await storage.read(key: 'salepage');
  List<dynamic> decodedata = [];
  if (existingData != null) {
    decodedata = jsonDecode(existingData);
  }
  return decodedata;
}

Future<List<dynamic>> getBuyPage() async {
  String? existingData = await storage.read(key: 'buypage');
  List<dynamic> decodedata = [];
  if (existingData != null) {
    decodedata = jsonDecode(existingData);
  }
  return decodedata;
}

Future<void> addToSalePage(
    List<Map<String, String>> resultPath, String address) async {
  // 기존 데이터 가져오기
  print("============================11");
  String? existingData = await storage.read(key: 'salepage');
  List<Map<String, dynamic>> salePageData = [];
  print("============================12");
  if (existingData != null) {
    var decodedata = jsonDecode(existingData);

    for (int idx = 0; idx < decodedata.length; idx++) {
      salePageData.add(decodedata[idx]);
    }
  }

  print("============================13");
  // 새 데이터 추가
  Map<String, dynamic> newData = {
    'resultPath': jsonEncode(resultPath),
    'address': address,
  };
  print("============================14");
  // 기존 데이터와 새 데이터 병합
  salePageData.add(newData);
  print("============================15");
  // SecureStorage에 저장
  await storage.write(key: 'salepage', value: jsonEncode(salePageData));
  print("============================16");
}

