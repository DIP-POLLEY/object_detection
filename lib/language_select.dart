import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constant.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
class LanguageScreen extends StatefulWidget {
  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {


  String selectedLanguage = 'ENGLISH';
  // String selectedLanguage;


  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in langList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(newItem);
    }
    void _changelang(String s) async{
      SharedPreferences pf1 = await SharedPreferences.getInstance();
      pf1.setString('lang', s);
    }
    return DropdownButton<String>(
      value: selectedLanguage,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedLanguage = value;
          _changelang(value);
          print(value);
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];
    for (String currency in langList) {
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        print(selectedIndex);
        setState(() {
          selectedLanguage = langList[selectedIndex];
        });
      },
      children: pickerItems,
    );
  }
  void _checklan()async{
    SharedPreferences pf1 = await SharedPreferences.getInstance();
    String lcode = pf1.getString('lang');
    if(lcode!=Null)
      {
        setState(() {
          selectedLanguage = lcode;
        });
      }
    else
      {
        setState(() {
          selectedLanguage = 'ENGLISH';
          pf1.setString('lang', 'ENGLISH');
        });
      }
  }
  @override
  void initState() {
    super.initState();
    _checklan();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.red,
    ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.white,
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),

    );
  }
}
