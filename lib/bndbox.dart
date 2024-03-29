import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';
import 'constant.dart';

class BndBox extends StatelessWidget {
  final FlutterTts flutterTts = FlutterTts();
  final obj = GoogleTranslator();

  final List<dynamic> results;
  final int previewH;
  final int previewW;
  final double screenH;
  final double screenW;

  BndBox(
    this.results,
    this.previewH,
    this.previewW,
    this.screenH,
    this.screenW,
  );
  String k;
  Future _speaker() async
  {
    SharedPreferences pf1 = await SharedPreferences.getInstance();
    String lcode = pf1.getString('lang');
    // await flutterTts.setLanguage('en');
    // await flutterTts.speak(k);
    k = "This is a "+k;
    var trans = await obj.translate(k,to: klan[lcode]);
    String query = trans.toString();
    print(query);
    await flutterTts.setLanguage(klan[lcode]);
    await flutterTts.speak(query);
    // print("speaking ${klan[lcode]}");
  }
  // Future<String> _bi(String s)async
  // {
  //   final obj = GoogleTranslator();
  //   var trans = await obj.translate(s,to: 'hi');
  //   String query = trans.toString();
  //   print("Here printing lcode $query");
  //   return query;
  // }

  @override
  Widget build(BuildContext context) {
    List<Widget> _renderBox() {
      return results.map((re) {
        var _x = re["rect"]["x"];
        var _w = re["rect"]["w"];
        var _y = re["rect"]["y"];
        var _h = re["rect"]["h"];
        // var wd = _bi(re["detectedClass"]).toString();
        var scaleW, scaleH, x, y, w, h;

        if (screenH / screenW > previewH / previewW) {
          scaleW = screenH / previewH * previewW;
          scaleH = screenH;
          var difW = (scaleW - screenW) / scaleW;
          x = (_x - difW / 2) * scaleW;
          w = _w * scaleW;
          if (_x < difW / 2) w -= (difW / 2 - _x) * scaleW;
          y = _y * scaleH;
          h = _h * scaleH;
        } else {
          scaleH = screenW / previewW * previewH;
          scaleW = screenW;
          var difH = (scaleH - screenH) / scaleH;
          x = _x * scaleW;
          w = _w * scaleW;
          y = (_y - difH / 2) * scaleH;
          h = _h * scaleH;
          if (_y < difH / 2) h -= (difH / 2 - _y) * scaleH;
        }

        return Positioned(
          left: math.max(0, x),
          top: math.max(0, y),
          width: w,
          height: h,
          child: GestureDetector(
            child: Container(
              padding: EdgeInsets.only(top: 5.0, left: 5.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color.fromRGBO(37, 213, 253, 1.0),
                  width: 3.0,
                ),
              ),
              child: Text(
                "${re["detectedClass"]} ${(re["confidenceInClass"] * 100).toStringAsFixed(0)}%",
                // _bi(re["detectedClass"]).toString(),
                // wd,

                style: TextStyle(
                  color: Color.fromRGBO(37, 213, 253, 1.0),
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            onTap: (){
              k = re["detectedClass"];
              print("This is ${re["detectedClass"]}");
              _speaker();
            },
          ),
        );
      }).toList();
    }

    return Stack(
      children: _renderBox(),
    );
  }
}
