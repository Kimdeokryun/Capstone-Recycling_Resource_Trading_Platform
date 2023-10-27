import 'package:flutter/material.dart';

class CounterButton extends StatefulWidget {
  @override
  _CounterButtonState createState() => _CounterButtonState();
}

class _CounterButtonState extends State<CounterButton> {
  int counter = 1;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Row(
        children:[
          ElevatedButton(
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
                elevation: MaterialStateProperty.all(0),
                shape: MaterialStateProperty.all<CircleBorder>(
                    const CircleBorder(
                      side: BorderSide(color: Color(0xff47ABFF), width: 1),
                    )
                )
            ),
            onPressed: () {
              setState(() {
                if (counter > 1) { // 카운터 값이 1보다 작아지지 않도록 함.
                  counter--;
                }
                print(counter);
              });
            },
            child: const Text('-', style: TextStyle(fontFamily: "HanM"),textScaleFactor: 1.2,),
          ),
          SizedBox(width:size.width*0.01), //버튼 사이의 공간 설정
          Text(counter.toString()),
          SizedBox(width:size.width*0.01), //버튼 사이의 공간 설정
          ElevatedButton(
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
                elevation: MaterialStateProperty.all(0),
                shape: MaterialStateProperty.all<CircleBorder>(
                    const CircleBorder(
                      side: BorderSide(color: Color(0xff47ABFF), width: 1),
                    )
                )
            ),
            onPressed: () {
              setState(() {
                counter++;
                print(counter);
              });
            },
            child: const Text('+', style: TextStyle(fontFamily: "HanM"),textScaleFactor: 1.2,),
          )
        ]
    );
  }
}
