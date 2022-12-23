import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:promed/Screens/Home/components/body.dart';
import 'package:promed/components/the_app_bar.dart';
import 'package:promed/components/the_drawer.dart';
import 'package:promed/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int intSelected =0;
  String selected = "جميع السنوات";
  List<String> libraries =[];

  Future<http.Response> fetchLibraries() {
    return http.get(Uri.parse(serverIP + '/main2/libraries/'));
  }

  Future<List<String>> _getLibraries() async {
    var data = await fetchLibraries();
    var jsonData = json.decode(utf8.decode(data.bodyBytes));

    for (var T in jsonData) {
      libraries.add(T["name"]);
    }
    return libraries;
  }

  @override
  void initState() {
    _getLibraries();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    size = Size(size.width, kAppBarHeight);
    List<String> items =[
      "جميع السنوات","السنة التحضيرية","السنة الثانية","السنة الثالثة","السنة الرابعة","السنة الخامسة","السنة السادسة",
    ];
    List<Map<String,int>> itemsMap = [
      {"جميع السنوات" : 0 },
      {"السنة التحضيرية" : 1 },
      {"السنة الثانية" : 2 },
      {"السنة الثالثة" : 3 },
      {"السنة الرابعة" : 4 },
      {"السنة الخامسة" : 5 },
      {"السنة السادسة" : 6 },
      ];

    return Scaffold(
      body: Body(selected: intSelected,libraries : libraries),
      appBar: PreferredSize(
        child: AppBar(
          backgroundColor: kPrimaryLightColor,
          foregroundColor: kPrimaryLightColor,
          title: Align(
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AutoSizeText(
                  'ProMed',
                  maxFontSize: 20,
                  style: TextStyle(
                    color: kPrimaryColor,
                  ),
                  textAlign: TextAlign.right,
                ),
                SizedBox(
                  width: size.width * 0.03,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Container(
              padding:EdgeInsets.fromLTRB(8,0,8,0),
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 4.5),
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(29),
              ),
            child :
            DropdownButton<String>(
              dropdownColor: kPrimaryColor,
              focusColor: kPrimaryColor,
              iconEnabledColor: kPrimaryColor,
              iconDisabledColor: kPrimaryLightColor,

              iconSize: 20,
              value: selected,
              items: items.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(color:Colors.white, fontWeight: FontWeight.bold),
                  ),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  selected = val ??"جميع السنوات";
                    if(selected=='جميع السنوات')
                      intSelected = 0 ;
                    else if(selected=='السنة التحضيرية')
                      intSelected = 1 ;
                  else if(selected=='السنة الثانية')
                  intSelected = 2 ;
                  else if(selected=='السنة الثالثة')
                      intSelected = 3 ;
                  else if(selected=='السنة الرابعة')
                      intSelected = 4 ;
                  else if(selected=='السنة الخامسة')
                      intSelected = 5 ;
                  else  if(selected=='السنة السادسة')
                      intSelected = 6 ;
                });
              },
            icon: Icon(Icons.filter_list_rounded,color:Colors.white,),
              underline: Container(),

            ),)


          ],
          iconTheme: IconThemeData(color: kPrimaryColor),

        ),
        preferredSize: size,
      ),
      drawer: TheAppDrawer(libraries: libraries,),
    );
  }
}
class Year{
   String yearName ;
   int id;

  Year({required this.yearName,required this.id});
}