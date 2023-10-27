import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Progressindicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      child: Center(
        child: CupertinoActivityIndicator(radius: 15.0), // iOS 스타일의 로딩 인디케이터
      ),
    );
  }
}
