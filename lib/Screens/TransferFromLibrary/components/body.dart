import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:promed/Screens/Login/components/background.dart';
import 'package:promed/components/rounded_button.dart';
import 'package:promed/components/text_field_container.dart';
import 'package:promed/constants.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class LTBody extends StatefulWidget {
  List<String> items = [];
  LTBody({Key? key, required this.items}) : super(key: key);

  @override
  _LTBodyState createState() => _LTBodyState();
}

class _LTBodyState extends State<LTBody> {
  Future<http.Response> sendTransfer({
    required String lib_name,
    required String amount,
  }) async {
    final String? token = await storage.read(key: 'access');
    return http.post(
      Uri.parse(serverIP + '/main2/librarytransfer/'),
      headers: {'Authorization': 'Token ' + token!},
      body: {'amount': amount, 'library': lib_name},
    );
  }

  final controller = TextEditingController();
  bool loading = false;
  Future<http.Response> fetchLibraries() {
    return http.get(Uri.parse(serverIP + '/main2/libraries/'));
  }

  Future<List<String>> _getLibraries() async {
    var data = await fetchLibraries();
    var jsonData = json.decode(utf8.decode(data.bodyBytes));
    List<String> libraries = [];

    for (var T in jsonData) {
      libraries.add(T["name"]);
    }
    return libraries;
  }

  String selected = " ";

  @override
  void initState() {
    selected = widget.items[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String amount = '';
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: size.height * 0.05),
            Container(
              width: size.width * 0.8,
              child: Column(
                children: [
                  Container(
                      margin: const EdgeInsets.all(10.0),
                      padding: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          border: Border.all(
                            color: kPrimaryColor,
                            width: 3,
                          )),
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Directionality(
                          textDirection: TextDirection.ltr,
                          child: Text(
                            "تعبئة رصيد عن طريق مكتبات معتمدة",
                            style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 24),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )),
                  SizedBox(
                    height: size.height * 0.03,
                  )
                ],
              ),
            ),
            Text(
              "قم باختيار المكتبة",
              style: TextStyle(color: kPrimaryColor),
            ),
            /*FutureBuilder<List<String>>(
                  future: _getLibraries(),
                  builder: (context, snapShot) {
                    if (snapShot.connectionState == ConnectionState.waiting)
                      return CircularProgressIndicator();
                    if (snapShot.connectionState == ConnectionState.done) {
                      if (snapShot.hasError)
                        return Center(
                          child: Text("error"),
                        );
                      if (snapShot.data != null) {
                        final items = snapShot.data;
                        Provider.of<Libraries>(context, listen: false)
                            .changeLibrary(items![0]);
                        return Consumer<Libraries>(builder: (BuildContext context, lib, _) {
                          return DropdownButton<String>(
                                /*selectedItemBuilder: (BuildContext context){
                                  return items.map((value) {
                                    return Container(
                                        alignment: Alignment.centerRight,
                                        child: Padding (
                                          padding: EdgeInsets.fromLTRB(2, 2, 15, 2),
                                          child :Directionality(textDirection: TextDirection.rtl, child: AutoSizeText(
                                            value.name ,
                                            style:
                                            TextStyle(color:  kPrimaryColor),
                                          ),),)
                                    );
                                  }).toList();
                                },*/
                                //dropdownColor: kPrimaryColor,
                                //iconEnabledColor: kPrimaryColor,
                                //iconDisabledColor: kPrimaryColor,
                                //icon: Icon(Icons.local_library_outlined),
                                isExpanded: true,
                                underline: Container(),
                                value: Provider.of<Libraries>(context).lib,
                                items: items.map((value) {
                                  return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                          value ,
                                          style:
                                              TextStyle(color: kPrimaryColor),
                                        ),);
                                }).toList(),
                                onChanged: (val) {
                                  print("onChange : ");
                                  return Provider.of<Libraries>(context,
                                          listen: false)
                                      .changeLibrary(val!);
                                },
                              );
                        });
                      } else {
                        return Center(
                          child: Text("no data"),
                        );
                      }
                    }

                    return Container();
                  }),
            */

            Container(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 4.5),
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(29),
              ),
              child: DropdownButton<String>(
                icon: Icon(
                  Icons.local_library_outlined,
                  color: Colors.white,
                ),
                /*selectedItemBuilder: (BuildContext context){
                                  return items.map((value) {
                                    return Container(
                                        alignment: Alignment.centerRight,
                                        child: Padding (
                                          padding: EdgeInsets.fromLTRB(2, 2, 15, 2),
                                          child :Directionality(textDirection: TextDirection.rtl, child: AutoSizeText(
                                            value.name ,
                                            style:
                                            TextStyle(color:  kPrimaryColor),
                                          ),),)
                                    );
                                  }).toList();
                                },*/
                dropdownColor: kPrimaryColor,
                focusColor: kPrimaryColor,
                iconEnabledColor: kPrimaryColor,
                iconDisabledColor: kPrimaryLightColor,
                isExpanded: true,
                underline: Container(),
                value: selected,
                items: widget.items.map((value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Container(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(2, 2, 15, 2),
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: AutoSizeText(
                              value,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )),
                  );
                }).toList(),
                onChanged: (val) {
                  print("onChange : ");
                  setState(() {
                    selected = val!;
                  });
                },
              ),
            ),
            SizedBox(height: size.height * 0.03),
            TextFieldContainer(
              child: TextField(
                  controller: controller,
                  textAlign: TextAlign.right,
                  onChanged: (value) {
                    amount = value;
                  },
                  cursorColor: kPrimaryColor,
                  decoration: InputDecoration(
                    hintText: "المبلغ",
                    hintStyle: TextStyle(
                      fontSize: 14,
                    ),
                    suffixIcon: Icon(
                      FontAwesomeIcons.coins,
                      color: kPrimaryColor,
                    ),
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
            ),
            Consumer<Libraries>(builder: (context, lib, _) {
              return RoundedButton(
                text: loading ? ' . . .جاري التحويل' : "تحويل",
                pressable: !loading,
                press: () async {
                  var response;
                  setState(() {
                    loading = true;
                  });
                  response = await sendTransfer(amount: amount, lib_name: selected);
                  setState(() {
                    loading = false;
                    amount = "";
                  });
                  controller.clear();
                  print(response.statusCode);
                  var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
                  if (response.statusCode == 200) {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        //title: const Text('AlertDialog Title'),
                        content: Text(
                          jsonResponse['Response'] + 'خلال مدة أقصاها 48 ساعة.',
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, 'موافق');
                            },
                            child: const Text('موافق'),
                          ),
                        ],
                      ),
                    );
                    //Navigator.pop(context);
                  } else {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        content: Text(
                          "${jsonResponse['library'] == null ? "" : jsonResponse['library'].toString().replaceFirst("[", "").replaceFirst("]", "")}\n ${jsonResponse['amount'] == null ? "" : jsonResponse['amount'].toString().replaceFirst("[", "").replaceFirst("]", "")}"
                                  '\n' +
                              'عذرا, لم تتم عملية التحويل.تأكد من البيانات المدخلة وحاول مرة أخرى.',
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'موافق'),
                            child: const Text('موافق'),
                          ),
                        ],
                      ),
                    );
                  }
                },
              );
            }),
            SizedBox(height: size.height * 0.1),
          ],
        ),
      ),
    );
  }

  Future<Widget> getDescription() async {
    String? token = await storage.read(key: 'access');
    http.Response response = await http.get(Uri.parse(serverIP + '/main2/transferdescription/'), headers: {'Authorization': 'Token ' + token!});
    var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
    return AutoSizeText(
      jsonResponse['description'],
      maxFontSize: 15,
    );
  }
}

class Libraries extends ChangeNotifier {
  String lib = "";

  void changeLibrary(String newLibrary) {
    lib = newLibrary;
    notifyListeners();
  }
}
