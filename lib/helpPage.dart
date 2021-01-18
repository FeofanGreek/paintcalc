import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'main.dart';



class helpPage extends StatefulWidget {

  @override
  _helpPageScreenState createState() => _helpPageScreenState();
}


class _helpPageScreenState extends State<helpPage> {

  @override
  void initState() {
    super.initState();
  }//initState


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xFFffffff),
      appBar:AppBar(
        elevation: 0.0,
        title:Text("Как пользоваться", style: TextStyle(fontSize: 18.0, color: Colors.white, fontFamily: 'Ubuntu', fontWeight: FontWeight.bold)),
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
                    CupertinoPageRoute(builder: (context) => mainScreen()));
              }, // button pressed
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.arrow_back_outlined, size: 18.0, color: Colors.white), // icon
                  Text("Назад", style: TextStyle(color: Colors.white,fontSize: 9.0)), // text
                ],
              ),
            ),
          ),
        ),
      ),
      body:SingleChildScrollView(
          physics: ScrollPhysics(),
          child:Center(

              child: Column(
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
                    //SizedBox(height: 20.0),
                    Container(
                        padding: EdgeInsets.fromLTRB(20,10,20,20),
                        child:
                        RichText(
                          textAlign: TextAlign.justify,
                          text: TextSpan(

                            text: ' Расчет состоит из двух блоков. \n\n'+
                                ' Первый определяет теоретический расход краски на 1 квадратный метр окрашиваемой поверхности.\n\n'+
                                ' Второй помогает определить, сколько потребуется порошка для окраски определенной партии деталей.\n\n'+
                                ' Для удобства все поля уже заполнены усредненными данными, но для получения актуальных данных вам разумеется нужно ввести свои значения.\n\n'+
                                ' В блоке ',
                            style: TextStyle(fontSize: 16.0, color: Colors.black, fontFamily: 'Ubuntu', ),
                            children: <TextSpan>[
                              TextSpan(text: '“Исходные данные”', style: TextStyle(fontSize: 16.0, color: Colors.black, fontFamily: 'Ubuntu',fontWeight: FontWeight.bold)),
                              TextSpan(text: ' нужно внести вашу ', style: TextStyle(fontSize: 16.0, color: Colors.black, fontFamily: 'Ubuntu',)),
                              TextSpan(text: 'закупочную цену ', style: TextStyle(fontSize: 16.0, color: Colors.black, fontFamily: 'Ubuntu',fontWeight: FontWeight.bold)),
                              TextSpan(text: 'на краску в рублях. Многие ориентируются на цены в евро, которые обычно укладываются в диапазон от 2 до 10 евро за килограмм.'+
                                  ' Далее введите ', style: TextStyle(fontSize: 16.0, color: Colors.black, fontFamily: 'Ubuntu',)),
                              TextSpan(text: 'удельный вес ', style: TextStyle(fontSize: 16.0, color: Colors.black, fontFamily: 'Ubuntu',fontWeight: FontWeight.bold)),

                              TextSpan(text: ' порошка. Этот параметр можно найти в паспорте на краску, иногда он указывается и на упаковке. Обычно значение лежит в диапазоне от 1,3 до 1,6 г/см3.\n\n', style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'Ubuntu',)),

                              TextSpan(text: ' Теперь введите требуемую ', style: TextStyle(fontSize: 16.0, color: Colors.black, fontFamily: 'Ubuntu',)),
                              TextSpan(text: 'толщину покрытия', style: TextStyle(fontSize: 16.0, color: Colors.black, fontFamily: 'Ubuntu',fontWeight: FontWeight.bold)),
                              TextSpan(text: '. Лучше всего взять ваше среднее значение из практики. Либо воспользоваться рекомендациями производителя, которые указываются в паспорте на порошок или на упаковке. Средний диапазон 60-80 мкм, но бывают значительные специфические отклонения.\n\n'+
                                  ' Самый сложный параметр - ', style: TextStyle(fontSize: 16.0, color: Colors.black, fontFamily: 'Ubuntu',)),
                              TextSpan(text: 'эффективность системы', style: TextStyle(fontSize: 16.0, color: Colors.black, fontFamily: 'Ubuntu',fontWeight: FontWeight.bold)),
                              TextSpan(text: '. Точно его можно определить только экспериментально, так как влияет множество факторов:\n\n'+
                                  '   - эффективность первичного переноса - насколько эффективно ваш пистолет осаждает краску на деталь;\n\n'+
                                  '   - наличие и эффективность системы рекуперации краски;\n\n'+
                                  '   - плотность завески изделий на конвейер окрасочной линии.\n\n'+
                                  ' Для получения идеальных теоретических значений данный\n\n'+
                                  ' параметр можно оставить равным 100%\n', style: TextStyle(fontSize: 16.0, color: Colors.black, fontFamily: 'Ubuntu',)),
                              //TextSpan(text: '”Не учитывать”', style: TextStyle(fontSize: 14.0, color: Colors.black, fontFamily: 'Ubuntu',fontWeight: FontWeight.bold)),
                              TextSpan(text: '.\n\n'+
                                  ' Расчет данного коэффициента доступен в профессиональной версии калькулятора. ', style: TextStyle(fontSize: 16.0, color: Colors.black, fontFamily: 'Ubuntu',)),
                            ],
                          ),
                        )
                    ),
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


                  ]))),

    );
  }
}

callClient(url) async {
  if (await canLaunch('$url')) {
    await launch('$url');
  } else {
    throw 'Невозможно набрать номер $url';
  }
  print('пробуем позвонить');
}



