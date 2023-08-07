import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

class PhotoStack {
  List<String> _stack = [];

  void push(String value) {
    _stack.add(value);
  }

  String? pop() {
    if (_stack.isNotEmpty) {
      return _stack.removeLast();
    }
    return null;
  }

  String peek() {
    return _stack.last;
  }

  bool get isEmpty => _stack.isEmpty;

  int get length => _stack.length;

  List<String> getlist() {
    return List.from(_stack);
  }



  void clear() => _stack.clear();

  void remove(int removeindex) => {
    _stack.removeAt(removeindex)
  };
}

class cachedelete {

}


Future<String> convert_file (String base64String) async {
  Uint8List bytes = base64.decode(base64String);
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String appDocPath = appDocDir.path;
  print(appDocPath);
  String imagePath = '$appDocPath/image.jpg';
  File imageFile = File(imagePath);
  await imageFile.writeAsBytes(bytes);
  return imagePath;
}


