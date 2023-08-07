import 'package:ecocycle/customlibrary/textanimation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../user/Trans_grade.dart';
import '../user/User_Storage.dart';

class buildCircularProgressIndicator extends StatefulWidget {
  @override
  _buildCircularProgressIndicator createState() => _buildCircularProgressIndicator();
}

class _buildCircularProgressIndicator extends State<buildCircularProgressIndicator> {
  late Map<String, dynamic> _transdata;
  late List<String> ecoGrade;
  late Size size;
  late double percent;
  bool isloading = true;

  void getData() async {
    _transdata = (await getTransData())!;
    int _trannum = _transdata['sales'] + _transdata['buy'];
    _trannum = 13;
    ecoGrade = getEcoGrade(_trannum);
    percent = (_trannum % 10) / 10;
    setState(() {
      isloading = false;
    });
  }
  
  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size * 0.1;
    return isloading
        ? BouncingTextAnimation()
        : DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Container
        (
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white
        ),
        child: CircularPercentIndicator(
          radius: size.width * 0.6,
          lineWidth: size.height * 0.06,
          animation: true,
          animationDuration: 1000,
          percent: percent,
          progressColor: Color(0xff47ABFF),
          backgroundColor: Colors.black12,
          fillColor: Colors.transparent,
          circularStrokeCap: CircularStrokeCap.round,
          center: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: "${ecoGrade[0]}\n",
                  style: TextStyle(color: Colors.black, fontFamily: 'HanM'),
                ),
                TextSpan(
                  text: " ${(percent * 100).toStringAsFixed(0)}%",
                  style: TextStyle(color: Colors.black, fontFamily: 'HanM'),
                ),
              ],
            ),
            textScaleFactor: 1,
          ),
        ),
      ),
    );
  }
}