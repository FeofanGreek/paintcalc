import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;

import 'main.dart';

class launchScreen extends StatefulWidget {

  @override
  _LaunchScreenState createState() => _LaunchScreenState();
}


class _LaunchScreenState extends State<launchScreen> {

  @override
  void initState() {
    super.initState();
    checkLicense();
    //const twentyMillis = const Duration(seconds:3);
    //new Timer(twentyMillis, () => Navigator.pushReplacement (context,
    //    CupertinoPageRoute(builder: (context) => mainScreen())));

  }//initState

  checkLicense() async {

    try {
      var response = await http.post('https://koldashev.ru/checklicense.php',
          headers: {"Accept": "application/json"},
          body: jsonEncode(<String, dynamic>{
            "name" : "technomax",
            "subject" : "license"
          })
      );
      if(response.body == '1'){
        const twentyMillis = const Duration(seconds:3);
        new Timer(twentyMillis, () => Navigator.pushReplacement (context,
            CupertinoPageRoute(builder: (context) => mainScreen())));
      }

    } catch (error) {
      //print(error);
    }
    //setState(() {}); //reBuildWidget

  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return Scaffold(
      backgroundColor: Color(0xFFffffff),
      body:Container(
        height: MediaQuery.of(context).size.height, width: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/launchscreen.png"),
               fit:BoxFit.fitHeight, alignment: Alignment(0.1, 0.0)
          ),
        ),
        child:Column(
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height / 2 + 120, width: MediaQuery.of(context).size.width,
              ),
            Center(
                child:Text('Калькулятор порошковой краски\n', style: TextStyle(fontSize: 20.0, color: Colors.white, fontFamily: 'Ubuntu',fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
            ),
            Center(
              child:Text('PowderCalc\n', style: TextStyle(fontSize: 20.0, color: Colors.white, fontFamily: 'Ubuntu',fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
            ),
            Center(
                child:Text('Версия: 1.26.2\n', style: TextStyle(fontSize: 15.0, color: Colors.white, fontFamily: 'Ubuntu'),textAlign: TextAlign.center,),
            ),
            Center(
              child:Container(
                  width: 15.0,
                  height: 15.0,
                  margin: EdgeInsets.fromLTRB(10,0,0,0),
                  child:CircularProgressIndicator(strokeWidth: 2.0,
                    valueColor : AlwaysStoppedAnimation(Colors.white),)),
            ),
        ]),
      ),
    );
  }
}
