
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:technomax/helpPage.dart';
import 'package:xml2json/xml2json.dart';

import 'LaunchScreen.dart';

final Xml2Json xml2Json = Xml2Json();
var parsedJson;
String curUSD = '0';
String curEuro = '0';
int pricePaint = 300;
double massaPaint = 1.5;
int coat = 75;
double effective1 = 100.00;
int effective = 100;
bool notUse = false;
double square = 0.5;
int tirage = 1000;
int curType = 3;
String curLabel = 'руб.';

void main(){
  runApp(PaintCalc());
}

class PaintCalc extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: launchScreen(),
    );
  }

}

class mainScreen extends StatefulWidget {

  @override
  _mainScreenState createState() => _mainScreenState();
}


class _mainScreenState extends State<mainScreen> {

  @override
  void initState() {
    readCurency();
    super.initState();
  }//initState


  readCurency() async {

    try {
      var response = await http.post('https://www.cbr.ru/scripts/XML_daily.asp');
      var xmlString = response.body;
      xml2Json.parse(xmlString);
      var jsonString = xml2Json.toParker();
      var data = jsonDecode(jsonString);
      var curCount = data['ValCurs']['Valute'].length;
      for (int i = 0; i < curCount; i++) {
        setState(() {
        data['ValCurs']['Valute'][i]['NumCode'] == '840'?
          //curUSD = data['ValCurs']['Valute'][i]['Value']:null;
        curUSD = data['ValCurs']['Valute'][i]['Value'].replaceAll(new RegExp(r','), '.'):null;
        data['ValCurs']['Valute'][i]['NumCode'] == '978' ?
          //curEuro = data['ValCurs']['Valute'][i]['Value']:null;
        curEuro = data['ValCurs']['Valute'][i]['Value'].replaceAll(new RegExp(r','), '.'):null;
        });
      }

    } catch (error) {
      print(error);
    }
    setState(() {}); //reBuildWidget

  }

  @override
  Widget build(BuildContext context) {

   return Scaffold(
      backgroundColor: Color(0xFFffffff),
     appBar:AppBar(
       elevation: 0.0,
       title:Text("PowderCalc 1.26.2", style: TextStyle(fontSize: 15.0, color: Colors.white, fontFamily: 'Ubuntu', fontWeight: FontWeight.bold)),
       centerTitle: true,
       backgroundColor: Color(0xFF4090DB),
       brightness: Brightness.light,
       leading: Container(
         child: Material(
           color: Color(0xFF4090DB), // button color
           child: InkWell(
             splashColor: Colors.green, // splash color
             onTap: () {
               Navigator.pushReplacement(context,
                   CupertinoPageRoute(builder: (context) => helpPage()));
             }, // button pressed
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: <Widget>[
                 //Text('i', style: TextStyle(fontSize: 20.0, color: Colors.black, /*fontFamily: 'Ubuntu',*/fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),textAlign: TextAlign.left,),
                 Icon(Icons.help, size: 18.0, color: Colors.white), // icon
                Text("Помощь", style: TextStyle(color: Colors.white,fontSize: 9.0)), // text
               ],
             ),
           ),
         ),
       ),
       actions: <Widget>[
         Container(
           margin: EdgeInsets.fromLTRB(5,0,15,0),
           child: Material(
             color: Color(0xFF4090DB), // button color
             child: InkWell(
               splashColor: Colors.green, // splash color
               onTap: () {
                 final RenderBox box = context.findRenderObject();
                 Share.share('https://play.google.com/store/apps/details?id=ru.koldashev.technomax',
                     subject: 'Калькулятор порошковой краски PowderCalc 1.26.2',
                     sharePositionOrigin:
                     box.localToGlobal(Offset.zero) &
                     box.size);
               }, // button pressed
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: <Widget>[
                   Icon(Icons.share, size: 18.0, color: Colors.white), // icon
                   Text("Поделиться", style: TextStyle(color: Colors.white,fontSize: 9.0)), // text
                 ],
               ),
             ),
           ),
         ),
       ],

     ),
      body:
      GestureDetector(
            onTap: () {

          FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: SingleChildScrollView(
          physics: ScrollPhysics(),
          //child:Center(

              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.fromLTRB(40,0,40,0),
                        margin: EdgeInsets.fromLTRB(0,0,0,0),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.black
                          ),
                        ),
                        color: Color(0xFFD4D4D4),
                      ),
                      child: Image.asset('images/logo_long.png',  height: 80,),),
                    SizedBox(height: 10.0),
                    Text('   Исходные данные', style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'Ubuntu',fontWeight: FontWeight.bold),textAlign: TextAlign.left,),
                     Center(
                       child:Text('\nВыполнить расчет в валюте\n', style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'Ubuntu',),textAlign: TextAlign.center,),
                     ),
                     Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: <Widget>[
                           FlatButton.icon(
                             icon: Icon(Icons.attach_money, color: curType == 1?Color(0xFF4090DB):Colors.grey ),
                             label: Text(""),
                             onPressed: () {
                               setState(() {
                                 curType = 1;
                                 curLabel = '\$';
                               });
                             },
                           ),
                           FlatButton.icon(
                             icon: Icon(Icons.euro, color: curType == 2?Color(0xFF4090DB):Colors.grey),
                             label: Text(""),
                             onPressed: () {
                               setState(() {
                                 curType = 2;
                                 curLabel = '€';
                               });
                             },
                           ),
                           FlatButton.icon(
                             icon: Text("₽", style: TextStyle(fontSize: 25.0, color: curType == 3?Color(0xFF4090DB):Colors.grey, fontFamily: 'Ubuntu',),textAlign: TextAlign.center),
                              label: Text(""),
                             onPressed: () {
                               setState(() {
                                 curType = 3;
                                 curLabel = 'руб.';
                               });
                             },
                           ),
                         ]),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.fromLTRB(20,0,0,20),
                          padding: EdgeInsets.fromLTRB(0,20,0,0),
                          width: MediaQuery.of(context).size.width - 180,
                           child:Text('Цена краски', style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'Ubuntu',), textAlign: TextAlign.left,),
                        ),
                        /*ButtonTheme(
                            minWidth: 10.0,
                            //height: 100.0,
                            child: FlatButton.icon(
                          onPressed: () {
                            Navigator.push(context,
                                CupertinoPageRoute(builder: (context) => helpPage()));
                          },
                                icon: Icon(Icons.contact_support_rounded),
                                label: Text(""),
                          color: Colors.white,
                          textColor: Colors.black,
                          disabledColor: Colors.white,
                          disabledTextColor: Colors.white,
                          padding: EdgeInsets.fromLTRB(0,0,0,0),
                          splashColor: Colors.white,
                        )),*/
                        Container(
                            width: 60.0,
                            height: 50.0,
                            padding: EdgeInsets.fromLTRB(0,10,0,5),
                         child:TextFormField(
                           enabled: true,

                           keyboardType: TextInputType.number,
                           decoration: InputDecoration(
                             hintText: pricePaint.toString(),
                             contentPadding: EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 2.0),
                             focusedBorder: OutlineInputBorder(
                               borderSide: BorderSide(
                                 color: Colors.blue,
                               ),
                             ),
                             enabledBorder: OutlineInputBorder(
                               borderSide: BorderSide(
                                 color: Colors.grey,
                                 width: 1.0,
                               ),
                             ),),
                           onChanged: (value){
                             setState(() {
                               pricePaint = int.parse(value);
                             });

                             },
                         )),
                      Text(' $curLabel за кг', style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'Ubuntu',), textAlign: TextAlign.left,),
                      ]
                    ),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.fromLTRB(20,0,0,20),
                            padding: EdgeInsets.fromLTRB(0,20,0,0),
                            width: MediaQuery.of(context).size.width - 180,
                              child:
                              Text('Удельный вес краски', style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'Ubuntu',), textAlign: TextAlign.left,),
                          ),
                          /*ButtonTheme(
                              minWidth: 10.0,
                              //height: 100.0,
                              child: FlatButton.icon(
                                onPressed: () {
                                  Navigator.push(context,
                                      CupertinoPageRoute(builder: (context) => helpPage()));
                                },
                                icon: Icon(Icons.contact_support_rounded),
                                label: Text(""),
                                color: Colors.white,
                                textColor: Colors.black,
                                disabledColor: Colors.white,
                                disabledTextColor: Colors.white,
                                padding: EdgeInsets.fromLTRB(0,0,0,0),
                                splashColor: Colors.white,
                              )),*/
                          Container(
                              width: 60.0,
                              height: 50.0,
                              padding: EdgeInsets.fromLTRB(0,10,0,5),
                              //margin: EdgeInsets.fromLTRB(0,10,0,10),
                              child:TextFormField(
                                enabled: true,

                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: massaPaint.toString(),
                                  contentPadding: EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 2.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.blue,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1.0,
                                    ),
                                  ),),
                                onChanged: (value){
                                  setState(() {
                                    massaPaint = double.parse(value);
                                  });

                                },
                              )),
                          Text(' г/см\u00B3', style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'Ubuntu',), textAlign: TextAlign.left,),
                        ]
                    ),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.fromLTRB(20,0,0,20),
                            padding: EdgeInsets.fromLTRB(0,20,0,0),
                            width: MediaQuery.of(context).size.width - 180,
                              child:
                              Text('Толщина покрытия', style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'Ubuntu',), textAlign: TextAlign.left,),
                          ),
                          /*ButtonTheme(
                              minWidth: 10.0,
                              //height: 100.0,
                              child: FlatButton.icon(
                                onPressed: () {
                                  Navigator.push(context,
                                      CupertinoPageRoute(builder: (context) => helpPage()));
                                },
                                icon: Icon(Icons.contact_support_rounded),
                                label: Text(""),
                                color: Colors.white,
                                textColor: Colors.black,
                                disabledColor: Colors.white,
                                disabledTextColor: Colors.white,
                                padding: EdgeInsets.fromLTRB(0,0,0,0),
                                splashColor: Colors.white,
                              )),*/
                          Container(
                              width: 60.0,
                              height: 50.0,
                              padding: EdgeInsets.fromLTRB(0,10,0,5),
                              //margin: EdgeInsets.fromLTRB(0,10,0,10),
                              child:TextFormField(
                                enabled: true,

                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: coat.toString(),
                                  contentPadding: EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 2.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.blue,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1.0,
                                    ),
                                  ),),
                                onChanged: (value){
                                  setState(() {
                                    coat = int.parse(value);
                                  });

                                },
                              )),
                          Text(' мкм', style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'Ubuntu',), textAlign: TextAlign.left,),
                        ]
                    ),
                   // Row(
                   //     crossAxisAlignment: CrossAxisAlignment.center,
                   //     children: <Widget>[
                    Center(
                          child:Container(
                              margin: EdgeInsets.fromLTRB(20,20,0,10),
                              //width:150,
                             // child:
                            //Expanded(
                              child:Text('Эффективность переноса $effective %', style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'Ubuntu',), textAlign: TextAlign.center,),
                            //),
                          ),
                    ),
                             /*ButtonTheme(
                              minWidth: 10.0,
                              //height: 100.0,
                              child: FlatButton.icon(
                                onPressed: () {
                                  Navigator.push(context,
                                      CupertinoPageRoute(builder: (context) => helpPage()));
                                },
                                icon: Icon(Icons.contact_support_rounded),
                                label: Text(""),
                                color: Colors.white,
                                textColor: Colors.black,
                                disabledColor: Colors.white,
                                disabledTextColor: Colors.white,
                                padding: EdgeInsets.fromLTRB(0,0,0,0),
                                splashColor: Colors.white,
                              )),*/
                          /*Container(
                              width: 60.0,
                              height: 50.0,
                              padding: EdgeInsets.fromLTRB(0,10,0,5),
                              //margin: EdgeInsets.fromLTRB(0,10,0,10),
                              child:TextFormField(
                                enabled: true,

                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: effective.toString(),
                                  contentPadding: EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 2.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.blue,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1.0,
                                    ),
                                  ),),
                                onChanged: (value){
                                  effective = int.parse(value);
                                },
                              )),*/
                          //Text(' %', style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'Ubuntu',), textAlign: TextAlign.left,),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: effective<30?Colors.red:effective<70?Colors.orange:Colors.green,
                              inactiveTrackColor: effective<30?Colors.red:effective<70?Colors.orange:Colors.green,
                              trackShape: RoundedRectSliderTrackShape(),
                              trackHeight: 4.0,
                              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                              thumbColor: effective<30?Colors.red:effective<70?Colors.orange:Colors.green,
                              overlayColor: effective<30?Colors.red.withAlpha(32):effective<70?Colors.orange.withAlpha(32):Colors.green.withAlpha(32),
                              overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                              tickMarkShape: RoundSliderTickMarkShape(),
                              activeTickMarkColor: Colors.white,
                              inactiveTickMarkColor: Colors.white,
                              valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                              valueIndicatorColor: effective<30?Colors.red:effective<70?Colors.orange:Colors.green,
                              valueIndicatorTextStyle: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            child: Slider(
                              value: effective1,
                              min: 0,
                              max: 100,
                              divisions: 20,
                              label: effective.round().toString()+' %',
                              onChanged: (value) {
                                setState(
                                      () {
                                        if(value > 0){effective1 = value;
                                        effective = effective1.toInt();}
                                  },

                                );
                                setState(() {

                                });
                              },
                            ),
                          ),

                          /*Checkbox(
                            value: notUse,
                            onChanged: (bool value) {
                              setState(() {
                                notUse = value;
                              });
                            },
                          ),
                          Expanded(
                            child:Text(' Не учитывать', style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'Ubuntu',), textAlign: TextAlign.left,),
                          ),*/
                    //    ]
                   // ),
                    Center(
                      child:ButtonTheme(
                        minWidth: MediaQuery.of(context).size.width-40,
                        child:
                        RaisedButton.icon(
                          onPressed: () {
                            setState(() {
                            });
                          },
                          icon: Icon(Icons.calculate_outlined),
                          label: Text("Рассчитать"),
                          color: Color(0xFFD4D4D4),
                          textColor: Colors.black,
                          disabledColor: Colors.white,
                          disabledTextColor: Colors.white,
                          padding: EdgeInsets.fromLTRB(0,0,0,0),
                          splashColor: Colors.white,
                        ),),),
                    SizedBox(height: 20.0),
                    SizedBox(height: 1.0, width: MediaQuery.of(context).size.width,
                      child: const DecoratedBox(
                        decoration: const BoxDecoration(
                          color: Colors.black,
                        ),
                      ),),
                    SizedBox(height: 20.0),
                    Text('   Результат', style: TextStyle(fontSize: 16.0, color: Color(0xFF4090DB), fontFamily: 'Ubuntu',fontWeight: FontWeight.bold),textAlign: TextAlign.left,),
                    SizedBox(height: 10.0),
                    /*Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.fromLTRB(20,5,0,0),
                            width:150,
                            child:
                            Text('Стоимость покрытия', style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'Ubuntu',), textAlign: TextAlign.left,),
                          ),
                          /*ButtonTheme(
                              minWidth: 10.0,
                              //height: 100.0,
                              child: FlatButton.icon(
                                onPressed: () {
                                  Navigator.push(context,
                                      CupertinoPageRoute(builder: (context) => helpPage()));
                                },
                                icon: Icon(Icons.contact_support_rounded),
                                label: Text(""),
                                color: Colors.white,
                                textColor: Colors.black,
                                disabledColor: Colors.white,
                                disabledTextColor: Colors.white,
                                padding: EdgeInsets.fromLTRB(0,0,0,0),
                                splashColor: Colors.white,
                              )),*/
                          curUSD!='0'?Text('${double.parse((pricePaint/double.parse(curUSD)/(!notUse?1000*1/(coat*massaPaint):1000*(1/100*effective)/(coat*massaPaint))).toStringAsFixed(2))}', style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'Ubuntu',), textAlign: TextAlign.left,)
                          :Container(
                            width: 15.0,
                            height: 15.0,
                            margin: EdgeInsets.fromLTRB(10,0,0,0),
                            child:CircularProgressIndicator(strokeWidth: 2.0,
                            valueColor : AlwaysStoppedAnimation(Colors.blue),)),
                          Text(' \$/м\u00B2', style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'Ubuntu',), textAlign: TextAlign.left,),
                        ]
                    ),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.fromLTRB(20,5,0,0),
                            width:150,
                            child:
                            Text('Стоимость покрытия', style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'Ubuntu',), textAlign: TextAlign.left,),
                          ),
                          /*ButtonTheme(
                              minWidth: 10.0,
                              //height: 100.0,
                              child: FlatButton.icon(
                                onPressed: () {
                                  Navigator.push(context,
                                      CupertinoPageRoute(builder: (context) => helpPage()));
                                },
                                icon: Icon(Icons.contact_support_rounded),
                                label: Text(""),
                                color: Colors.white,
                                textColor: Colors.black,
                                disabledColor: Colors.white,
                                disabledTextColor: Colors.white,
                                padding: EdgeInsets.fromLTRB(0,0,0,0),
                                splashColor: Colors.white,
                              )),*/
                          curEuro!='0'?Text('${double.parse((pricePaint/double.parse(curEuro)/(!notUse?1000*1/(coat*massaPaint):1000*(1/100*effective)/(coat*massaPaint))).toStringAsFixed(2))}', style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'Ubuntu',), textAlign: TextAlign.left,)
                          :Container(
                              width: 15.0,
                              height: 15.0,
                              margin: EdgeInsets.fromLTRB(10,0,0,0),
                              child:CircularProgressIndicator(strokeWidth: 2.0,
                              valueColor : AlwaysStoppedAnimation(Colors.blue),)),
                          Text(' \u20AC/м\u00B2', style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'Ubuntu',), textAlign: TextAlign.left,),
                        ]
                    ),*/
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.fromLTRB(20,0,0,5),
                            padding: EdgeInsets.fromLTRB(0,5,0,0),
                            //width: MediaQuery.of(context).size.width - 180,
                            child:
                            Text('Расход краски ', style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'Ubuntu',), textAlign: TextAlign.left,),
                          ),
                          /*ButtonTheme(
                              minWidth: 10.0,
                              //height: 100.0,
                              child: FlatButton.icon(
                                onPressed: () {
                                  Navigator.push(context,
                                      CupertinoPageRoute(builder: (context) => helpPage()));
                                },
                                icon: Icon(Icons.contact_support_rounded),
                                label: Text(""),
                                color: Colors.white,
                                textColor: Colors.black,
                                disabledColor: Colors.white,
                                disabledTextColor: Colors.white,
                                padding: EdgeInsets.fromLTRB(0,0,0,0),
                                splashColor: Colors.white,
                              )),*/
                          Text('${double.parse((1000/(1000*(1/100*effective)/(coat*massaPaint))).toStringAsFixed(2))}', style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'Ubuntu',fontWeight: FontWeight.bold), textAlign: TextAlign.left,),
                          Text(' г/м\u00B2', style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'Ubuntu',), textAlign: TextAlign.left,),
                        ]
                    ),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.fromLTRB(20,0,0,5),
                            padding: EdgeInsets.fromLTRB(0,5,0,0),
                            //width: MediaQuery.of(context).size.width - 180,
                            child:
                            Text('Укрывистость ', style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'Ubuntu',), textAlign: TextAlign.left,),
                          ),
                          /*ButtonTheme(
                              minWidth: 10.0,
                              //height: 100.0,
                              child: FlatButton.icon(
                                onPressed: () {
                                  Navigator.push(context,
                                      CupertinoPageRoute(builder: (context) => helpPage()));
                                },
                                icon: Icon(Icons.contact_support_rounded),
                                label: Text(""),
                                color: Colors.white,
                                textColor: Colors.black,
                                disabledColor: Colors.white,
                                disabledTextColor: Colors.white,
                                padding: EdgeInsets.fromLTRB(0,0,0,0),
                                splashColor: Colors.white,
                              )),*/
                          Text('${double.parse((1000*(1/100*effective)/(coat*massaPaint)).toStringAsFixed(2))}', style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'Ubuntu',fontWeight: FontWeight.bold), textAlign: TextAlign.left,),
                          Text(' м\u00B2/кг', style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'Ubuntu',), textAlign: TextAlign.left,),
                        ]
                    ),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.fromLTRB(20,0,0,5),
                            padding: EdgeInsets.fromLTRB(0,5,0,0),
                            //width: MediaQuery.of(context).size.width - 180,
                            child:
                            Text('Стоимость покрытия ', style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'Ubuntu',), textAlign: TextAlign.left,),
                          ),
                          /*ButtonTheme(
                              minWidth: 10.0,
                              //height: 100.0,
                              child: FlatButton.icon(
                                onPressed: () {
                                  Navigator.push(context,
                                      CupertinoPageRoute(builder: (context) => helpPage()));
                                },
                                icon: Icon(Icons.contact_support_rounded),
                                label: Text(""),
                                color: Colors.white,
                                textColor: Colors.black,
                                disabledColor: Colors.white,
                                disabledTextColor: Colors.white,
                                padding: EdgeInsets.fromLTRB(0,0,0,0),
                                splashColor: Colors.white,
                              )),*/
                          //Text('${double.parse((pricePaint/(!notUse?1000*1/(coat*massaPaint):1000*(1/100*effective)/(coat*massaPaint))).toStringAsFixed(2))}', style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'Ubuntu',), textAlign: TextAlign.left,),
                          Text('${double.parse((pricePaint/(1000*(1/100*effective)/(coat*massaPaint))).toStringAsFixed(2))}', style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'Ubuntu',fontWeight: FontWeight.bold), textAlign: TextAlign.left,),
                          Text(' $curLabel за м\u00B2', style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'Ubuntu',), textAlign: TextAlign.left,),
                        ]
                    ),
                    SizedBox(height: 20.0),
                    SizedBox(height: 1.0, width: MediaQuery.of(context).size.width,
                      child: const DecoratedBox(
                        decoration: const BoxDecoration(
                          color: Colors.black,
                        ),
                      ),),
                    Text('\n   Расход краски на партию деталей\n', style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'Ubuntu',fontWeight: FontWeight.bold),textAlign: TextAlign.left,),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.fromLTRB(20,0,0,20),
                            padding: EdgeInsets.fromLTRB(0,20,0,0),
                            width: MediaQuery.of(context).size.width - 180,
                            child:Text('Площадь поверхности детали', style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'Ubuntu',), textAlign: TextAlign.left,),
                          ),
                          /*ButtonTheme(
                              minWidth: 10.0,
                              //height: 100.0,
                              child: FlatButton.icon(
                                onPressed: () {
                                  Navigator.push(context,
                                      CupertinoPageRoute(builder: (context) => helpPage()));
                                },
                                icon: Icon(Icons.contact_support_rounded),
                                label: Text(""),
                                color: Colors.white,
                                textColor: Colors.black,
                                disabledColor: Colors.white,
                                disabledTextColor: Colors.white,
                                padding: EdgeInsets.fromLTRB(0,0,0,0),
                                splashColor: Colors.white,
                              )),*/
                          Container(
                              width: 60.0,
                              height: 50.0,
                              padding: EdgeInsets.fromLTRB(0,10,0,5),
                              //margin: EdgeInsets.fromLTRB(0,10,0,10),
                              child:TextFormField(
                                enabled: true,

                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: square.toString(),
                                  contentPadding: EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 2.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.blue,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1.0,
                                    ),
                                  ),),
                                onChanged: (value){
                                  setState(() {
                                    square = double.parse(value);
                                  });

                                },
                              )),
                          Text(' м\u00B2', style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'Ubuntu',), textAlign: TextAlign.left,),
                        ]
                    ),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.fromLTRB(20,0,0,20),
                            padding: EdgeInsets.fromLTRB(0,20,0,0),
                            width: MediaQuery.of(context).size.width - 180,
                            child:
                            Text('Размер партии', style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'Ubuntu',), textAlign: TextAlign.left,),
                          ),
                          /*ButtonTheme(
                              minWidth: 10.0,
                              //height: 100.0,
                              child: FlatButton.icon(
                                onPressed: () {
                                  Navigator.push(context,
                                      CupertinoPageRoute(builder: (context) => helpPage()));
                                },
                                icon: Icon(Icons.contact_support_rounded),
                                label: Text(""),
                                color: Colors.white,
                                textColor: Colors.black,
                                disabledColor: Colors.white,
                                disabledTextColor: Colors.white,
                                padding: EdgeInsets.fromLTRB(0,0,0,0),
                                splashColor: Colors.white,
                              )),*/
                          Container(
                              width: 60.0,
                              height: 50.0,
                              padding: EdgeInsets.fromLTRB(0,10,0,5),
                              //margin: EdgeInsets.fromLTRB(0,10,0,10),
                              child:TextFormField(
                                enabled: true,

                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: tirage.toString(),
                                  contentPadding: EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 2.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.blue,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1.0,
                                    ),
                                  ),),
                                onChanged: (value){
                                  setState(() {
                                    tirage = int.parse(value);
                                  });

                                },
                              )),
                          Text(' шт', style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'Ubuntu',), textAlign: TextAlign.left,),
                        ]
                    ),
                      Center(
                         child:ButtonTheme(
                           minWidth: MediaQuery.of(context).size.width-40,
                             child:
                             RaisedButton.icon(
                              onPressed: () {
                                setState(() {

                                });
                              },
                              icon: Icon(Icons.calculate_outlined),
                              label: Text("Рассчитать"),
                              color: Color(0xFFD4D4D4),
                              textColor: Colors.black,
                              disabledColor: Colors.white,
                              disabledTextColor: Colors.white,
                              padding: EdgeInsets.fromLTRB(0,0,0,0),
                              splashColor: Colors.white,
                            ),),),
                    SizedBox(height: 20.0),
                    SizedBox(height: 1.0, width: MediaQuery.of(context).size.width,
                      child: const DecoratedBox(
                        decoration: const BoxDecoration(
                          color: Colors.black,
                        ),
                      ),),
                    SizedBox(height: 20.0),
                    Text('   Результат', style: TextStyle(fontSize: 16.0, color: Color(0xFF4090DB), fontFamily: 'Ubuntu',fontWeight: FontWeight.bold),textAlign: TextAlign.left,),
                    SizedBox(height: 10.0),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.fromLTRB(20,0,0,5),
                            padding: EdgeInsets.fromLTRB(0,5,0,0),
                            //width: MediaQuery.of(context).size.width - 180,
                            child:
                            Text('Потребуется  ', style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'Ubuntu',), textAlign: TextAlign.left,),
                          ),
                          /*ButtonTheme(
                              minWidth: 10.0,
                              //height: 100.0,
                              child: FlatButton.icon(
                                onPressed: () {
                                  Navigator.push(context,
                                      CupertinoPageRoute(builder: (context) => helpPage()));
                                },
                                icon: Icon(Icons.contact_support_rounded),
                                label: Text(""),
                                color: Colors.white,
                                textColor: Colors.black,
                                disabledColor: Colors.white,
                                disabledTextColor: Colors.white,
                                padding: EdgeInsets.fromLTRB(0,0,0,0),
                                splashColor: Colors.white,
                              )),*/
                          //Text('${double.parse((tirage*square*(1000/(!notUse?1000*1/(coat*massaPaint):1000*(1/100*effective)/(coat*massaPaint)))/1000).toStringAsFixed(2))}', style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'Ubuntu',), textAlign: TextAlign.left,),
                          Text('${double.parse((tirage*square*(1000/(1000*(1/100*effective)/(coat*massaPaint)))/1000).toStringAsFixed(2))}', style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'Ubuntu',fontWeight: FontWeight.bold), textAlign: TextAlign.left,),
                          Text(' кг. краски', style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'Ubuntu',), textAlign: TextAlign.left,),
                        ]
                    ),
                    Row(
                       crossAxisAlignment: CrossAxisAlignment.center,
                       children: <Widget>[
                        Container(
                           margin: EdgeInsets.fromLTRB(20,0,0,5),
                           padding: EdgeInsets.fromLTRB(0,5,0,0),
                            child:Text('Общая cтоимость: ', style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'Ubuntu',), textAlign: TextAlign.left,),
                     ),

                    //Row(
                   //   mainAxisAlignment: MainAxisAlignment.center,
                    //  children: <Widget>[
                        //Text('${double.parse((tirage*square*(1000/(!notUse?1000*1/(coat*massaPaint):1000*(1/100*effective)/(coat*massaPaint)))/1000*pricePaint).toStringAsFixed(2))} руб.', style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'Ubuntu',)),
                        Text('${double.parse((tirage*square*(1000/(1000*(1/100*effective)/(coat*massaPaint)))/1000*pricePaint).toStringAsFixed(2))} ', style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'Ubuntu',fontWeight: FontWeight.bold)),
                        //Text('  ${double.parse((tirage*square*(1000/(!notUse?1000*1/(coat*massaPaint):1000*(1/100*effective)/(coat*massaPaint)))/1000*pricePaint/double.parse(curUSD)).toStringAsFixed(2))}\$', style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'Ubuntu',)),
                        //Text('  ${double.parse((tirage*square*(1000/(!notUse?1000*1/(coat*massaPaint):1000*(1/100*effective)/(coat*massaPaint)))/1000*pricePaint/double.parse(curEuro)).toStringAsFixed(2))}\u20AC', style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'Ubuntu',)),
                   //   ],
                   // ),
                         Text('$curLabel', style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'Ubuntu')),
                       ]),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.fromLTRB(20,0,0,5),
                            padding: EdgeInsets.fromLTRB(0,5,0,0),
                            //width: MediaQuery.of(context).size.width - 180,
                            child:
                            Text('Коробок по 25 кг - ', style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'Ubuntu',), textAlign: TextAlign.left,),
                          ),
                          /*ButtonTheme(
                              minWidth: 10.0,
                              //height: 100.0,
                              child: FlatButton.icon(
                                onPressed: () {
                                  Navigator.push(context,
                                      CupertinoPageRoute(builder: (context) => helpPage()));
                                },
                                icon: Icon(Icons.contact_support_rounded),
                                label: Text(""),
                                color: Colors.white,
                                textColor: Colors.black,
                                disabledColor: Colors.white,
                                disabledTextColor: Colors.white,
                                padding: EdgeInsets.fromLTRB(0,0,0,0),
                                splashColor: Colors.white,
                              )),*/
                          Text('${((tirage*square*(1000/(1000*(1/100*effective)/(coat*massaPaint)))/1000/25)
                              -(tirage*square*(1000/(1000*(1/100*effective)/(coat*massaPaint)))/1000/25).round())
                              >0?
                          (tirage*square*(1000/(1000*(1/100*effective)/(coat*massaPaint)))/1000/25).round()+1
                              :(tirage*square*(1000/(1000*(1/100*effective)/(coat*massaPaint)))/1000/25).round()}', style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'Ubuntu',fontWeight: FontWeight.bold), textAlign: TextAlign.left,),
                          Text(' шт.', style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'Ubuntu',), textAlign: TextAlign.left,),
                        ]
                    ),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.fromLTRB(20,0,0,5),
                            padding: EdgeInsets.fromLTRB(0,5,0,0),
                            //width: MediaQuery.of(context).size.width - 180,
                            child: Text('Коробок по 20 кг - ', style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'Ubuntu',), textAlign: TextAlign.left,),
                          ),
                          /*ButtonTheme(
                              minWidth: 10.0,
                              //height: 100.0,
                              child: FlatButton.icon(
                                onPressed: () {
                                  Navigator.push(context,
                                      CupertinoPageRoute(builder: (context) => helpPage()));
                                },
                                icon: Icon(Icons.contact_support_rounded),
                                label: Text(""),
                                color: Colors.white,
                                textColor: Colors.black,
                                disabledColor: Colors.white,
                                disabledTextColor: Colors.white,
                                padding: EdgeInsets.fromLTRB(0,0,0,0),
                                splashColor: Colors.white,
                              )),*/
                          Text('${((tirage*square*(1000/(1000*(1/100*effective)/(coat*massaPaint)))/1000/20)
                              -
                              (tirage*square*(1000/(1000*(1/100*effective)/(coat*massaPaint)))/1000/20).round())
                              >0?
                          (tirage*square*(1000/(1000*(1/100*effective)/(coat*massaPaint)))/1000/20).round()+1
                              :(tirage*square*(1000/(1000*(1/100*effective)/(coat*massaPaint)))/1000/20).round()}', style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'Ubuntu',fontWeight: FontWeight.bold), textAlign: TextAlign.left,),
                          Text(' шт.', style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'Ubuntu',), textAlign: TextAlign.left,),
                        ]
                    ),
                    SizedBox(height: 20.0),
                    Center(
                      child:ButtonTheme(
                        minWidth: MediaQuery.of(context).size.width-40,
                        child:
                        RaisedButton.icon(
                          onPressed: () {
                            final RenderBox box = context.findRenderObject();
                            Share.share(' Произведен расчет краски по следующим параметрам: \n'+
                                'Цена: ${pricePaint.toString()} $curLabel\n'+
                                'Удельный вес: ${massaPaint.toString()} г/см\u00B3\n'+
                                'Толщина покрытия: ${coat.toString()} мкм\n'+
                                'Эффективность переноса: ${effective.round().toString()}%\n\n'+


                                'Результат:\n'+
                                'Расход краски: ${double.parse((1000/(1000*(1/100*effective)/(coat*massaPaint))).toStringAsFixed(2))}  г/м\u00B2\n'+
                                'Укрывистость: ${double.parse((1000*(1/100*effective)/(coat*massaPaint)).toStringAsFixed(2))} м\u00B2/кг\n'+
                                'Стоимость покрытия: ${double.parse((pricePaint/(1000*(1/100*effective)/(coat*massaPaint))).toStringAsFixed(2))}  $curLabel за м\u00B2\n\n'+

                                'Для площади поверхности детали ${square.toString()} м\u00B2 и размера партии ${tirage.toString()} шт. потребуется ${double.parse((tirage*square*(1000/(1000*(1/100*effective)/(coat*massaPaint)))/1000).toStringAsFixed(2))} кг. краски, общей стоимостью ${double.parse((tirage*square*(1000/(1000*(1/100*effective)/(coat*massaPaint)))/1000*pricePaint).toStringAsFixed(2))} $curLabel.\n\n'+

                                'Колличество коробок по 25 кг - ${((tirage*square*(1000/(1000*(1/100*effective)/(coat*massaPaint)))/1000/25)
                                    -(tirage*square*(1000/(1000*(1/100*effective)/(coat*massaPaint)))/1000/25).round())
                                    >0?
                                (tirage*square*(1000/(1000*(1/100*effective)/(coat*massaPaint)))/1000/25).round()+1
                                    :(tirage*square*(1000/(1000*(1/100*effective)/(coat*massaPaint)))/1000/25).round()} шт, коробок по 20 кг - ${((tirage*square*(1000/(1000*(1/100*effective)/(coat*massaPaint)))/1000/20)
                                    -
                                    (tirage*square*(1000/(1000*(1/100*effective)/(coat*massaPaint)))/1000/20).round())
                                    >0?
                                (tirage*square*(1000/(1000*(1/100*effective)/(coat*massaPaint)))/1000/20).round()+1
                                    :(tirage*square*(1000/(1000*(1/100*effective)/(coat*massaPaint)))/1000/20).round()} шт.\n\n'+
                                'Справочно цена в других валютах: ${curType == 1?('${double.parse((tirage*square*(1000/(1000*(1/100*effective)/(coat*massaPaint)))/1000*pricePaint*double.parse(curUSD)).toStringAsFixed(2))} рублей, ${double.parse((tirage*square*(1000/(1000*(1/100*effective)/(coat*massaPaint)))/1000*pricePaint*double.parse(curUSD)/double.parse(curEuro)).toStringAsFixed(2))} евро.' ):curType == 2?('${double.parse((tirage*square*(1000/(1000*(1/100*effective)/(coat*massaPaint)))/1000*pricePaint*double.parse(curEuro)).toStringAsFixed(2))} рублей, ${double.parse((tirage*square*(1000/(1000*(1/100*effective)/(coat*massaPaint)))/1000*pricePaint*double.parse(curEuro)/double.parse(curUSD)).toStringAsFixed(2))} \$.' ):('${double.parse((tirage*square*(1000/(1000*(1/100*effective)/(coat*massaPaint)))/1000*pricePaint/double.parse(curUSD)).toStringAsFixed(2))} \$, ${double.parse((tirage*square*(1000/(1000*(1/100*effective)/(coat*massaPaint)))/1000*pricePaint/double.parse(curEuro)).toStringAsFixed(2))} евро.')}\n\n'+

                                'Расчет произведен в приложении PowderCalc',
                                subject: 'Калькулятор порошковой краски PowderCalc',
                                sharePositionOrigin:
                                box.localToGlobal(Offset.zero) &
                                box.size);
                          },
                          icon: Icon(Icons.ios_share),
                          label: Text("Отправить результат"),
                          color: Color(0xFFD4D4D4),
                          textColor: Colors.black,
                          disabledColor: Colors.white,
                          disabledTextColor: Colors.white,
                          padding: EdgeInsets.fromLTRB(0,0,0,0),
                          splashColor: Colors.white,
                        ),),),
                    SizedBox(height: 20.0),
                    SizedBox(height: 1.0, width: MediaQuery.of(context).size.width,
                      child: const DecoratedBox(
                        decoration: const BoxDecoration(
                          color: Colors.black,
                        ),
                      ),),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.fromLTRB(10,20,40,5),
                      margin: EdgeInsets.fromLTRB(0,0,0,0),
                      decoration: BoxDecoration(
                        color: Color(0xFF474747),
                      ),
                      /*child:
                      GestureDetector(
                        onTap: () {
                          callClient('https://www.technomax.pro/company');
                        },*/
                        child:Text("Контакты", style: TextStyle(fontSize: 18.0, color: Colors.white, fontFamily: 'Ubuntu', fontWeight: FontWeight.bold),textAlign: TextAlign.left),
                      //),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.fromLTRB(10,20,40,5),
                      margin: EdgeInsets.fromLTRB(0,0,0,0),
                      decoration: BoxDecoration(
                        color: Color(0xFF474747),
                      ),
                      child:
                      GestureDetector(
                        onTap: () {
                          callClient('mailto:info@technomax.pro');
                        },
                        child:Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(Icons.email_outlined, color: Colors.white,),
                          Text(" info@technomax.pro", style: TextStyle(fontSize: 18.0, color: Colors.white, fontFamily: 'Ubuntu', fontWeight: FontWeight.bold),textAlign: TextAlign.start),
                        ]),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.fromLTRB(10,5,40,5),
                      margin: EdgeInsets.fromLTRB(0,0,0,0),
                      decoration: BoxDecoration(
                        color: Color(0xFF474747),
                      ),
                      child:
                      GestureDetector(
                        onTap: () {
                          callClient('https://technomax.pro');
                        },
                        child:
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                          Icon(Icons.language_sharp, color: Colors.white,),
                        Text(" www.technomax.pro", style: TextStyle(fontSize: 18.0, color: Colors.white, fontFamily: 'Ubuntu', fontWeight: FontWeight.bold),textAlign: TextAlign.start),
                        ]),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.fromLTRB(10,5,40,20),
                      margin: EdgeInsets.fromLTRB(0,0,0,0),
                      decoration: BoxDecoration(
                        color: Color(0xFF474747),
                      ),
                      child:
                      GestureDetector(
                        onTap: () {
                          callClient('tel:+74956460568');
                        },
                        child:Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                            Icon(Icons.phone, color: Colors.white,),
                            Text(" +7(495) 646-05-68", style: TextStyle(fontSize: 18.0, color: Colors.white, fontFamily: 'Ubuntu', fontWeight: FontWeight.bold),textAlign: TextAlign.left),
                        ]),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.fromLTRB(40,5,40,30),
                      margin: EdgeInsets.fromLTRB(0,0,0,0),
                      decoration: BoxDecoration(
                        color: Color(0xFF474747),
                      ),
                      child:
                      Image.asset('images/logo_middle.png',  height: 80,),
                    ),

                  ])
      //    )
        ),

      ),
   );
  }
}





