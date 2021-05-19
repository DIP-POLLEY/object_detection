import 'package:eyes/language_select.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;

import 'camera.dart';
import 'bndbox.dart';

const String ssd = "SSD MobileNet";
const String yolo = "Tiny YOLOv2";

class HomePage extends StatefulWidget {
  final List<CameraDescription> cameras;

  HomePage(this.cameras);

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> _recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;
  String _model = "";

  @override
  void initState() {
    super.initState();
  }

  loadModel() async {
    String res;
    if(_model == yolo)
      {
        res = await Tflite.loadModel(

            model: "assets/yolov2_tiny.tflite",
            labels: "assets/yolov2_tiny.txt"
        );
      }
    else
      {
        res = await Tflite.loadModel(

            model: "assets/ssd_mobilenet.tflite",
            labels: "assets/ssd_mobilenet.txt"
        );
      }


    print("This is printed : $res");
  }

  onSelect(model) {
    setState(() {
      _model = model;
    });
    loadModel();
  }

  setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

  // onPressed: () => onSelect(ssd),
  // onPressed: () => onSelect(yolo),

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              setState(() {
                _model = "";
              });
            }),
        actions:<Widget>[
          IconButton(
              icon: Icon(Icons.add_alert_sharp),
              onPressed: () {
                Navigator.pushNamed(context, 'language_screen');
              }
              ),
        ],
      ),
      backgroundColor: Colors.white,
      body: _model == ""
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      flex:1,
                      child: GestureDetector(
                        child: Container(
                          color: Colors.amberAccent,

                          ),
                        onTap: () => onSelect(ssd),
                      ),

                  ),
                  Expanded(
                      flex:1,
                      child: GestureDetector(
                        child: Container(
                          color: Colors.lightGreenAccent,

                        ),
                        onTap: () => onSelect(yolo),
                      )

                  )
                ],
              ),
            )
          : Stack(
              children: [
                Camera(
                  widget.cameras,
                  _model,
                  setRecognitions,
                ),
                BndBox(
                  _recognitions == null ? [] : _recognitions,
                  math.max(_imageHeight, _imageWidth),
                  math.min(_imageHeight, _imageWidth),
                  screen.height,
                  screen.width,
                ),
              ],
            ),
    );
  }
}
