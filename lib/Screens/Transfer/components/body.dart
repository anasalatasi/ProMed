import 'dart:convert';
import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:promed/Screens/Login/components/background.dart';
import 'package:promed/components/rounded_button.dart';
import 'package:promed/components/rounded_input_field.dart';
import 'package:promed/components/text_field_container.dart';
import 'package:promed/constants.dart';
import 'package:http/http.dart' as http;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:image_capture_field/image_capture_field.dart';
import 'package:image_picker/image_picker.dart';

Future<http.Response> sendTransfer({
  required String receiptNumber,
  required String amount,
}) async {
  final String? token = await storage.read(key: 'access');
  return http.post(
    Uri.parse(serverIP + '/main2/alharamtransfer/'),
    headers: {'Authorization': 'Token ' + token!},
    body: {
      'receipt_number': receiptNumber,
      'amount': amount,
    },
  );
}


class Body extends StatefulWidget {
  Body({
    Key? key,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool loading = false;
  final receiptController = TextEditingController();
  final amountController = TextEditingController();

  var maskFormatter = new MaskTextInputFormatter(filter: { "#": RegExp(r'[0-9]') }, mask: '####-'*4);
  @override
  Widget build(BuildContext context) {
    String name = '';
    String mobileNumber = '';
    String receiptNumber = '';
    String amount = '';
    String image = '';
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
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: Text(
                            "تعليمات الدفع :",
                            style: TextStyle(
                                color: kPrimaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.02,
                        ),
                        Icon(
                          Icons.menu_book,
                          color: kPrimaryColor,
                        ),
                      ]),
                  SizedBox(
                    height: size.height * 0.04,
                  ),
                  FutureBuilder<Widget>(
                    future: getDescription(),
                    builder: (BuildContext context,
                        AsyncSnapshot<Widget?> snapshot) {
                      if (snapshot.hasData) {
                        return snapshot.data!;
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  )
                ],
              ),
            ),
            TextFieldContainer(
              child: TextField(
                  controller: receiptController,
                  textAlign: TextAlign.right,
                  onChanged:(value) {
                    receiptNumber = value;
                  },
                  cursorColor: kPrimaryColor,
                  decoration: InputDecoration(
                    hintText: "رقم الوصل",
                    hintStyle: TextStyle(
                      fontSize: 14,
                    ),
                    suffixIcon: Icon(FontAwesomeIcons.receipt,color: kPrimaryColor,),
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters:[maskFormatter]
              ),
            ),
            TextFieldContainer(
              child: TextField(
                  controller: amountController,
                  textAlign: TextAlign.right,
                  onChanged:(value) {
                    amount = value;
                  },
                  cursorColor: kPrimaryColor,
                  decoration: InputDecoration(
                    hintText: "المبلغ",
                    hintStyle: TextStyle(
                      fontSize: 14,
                    ),
                    suffixIcon: Icon(FontAwesomeIcons.coins,color: kPrimaryColor,),
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters:[FilteringTextInputFormatter.digitsOnly]
              ),
            ),
            /*RoundedInputField(
              inputFormatters: [maskFormatter],
              keyboardType: TextInputType.number,
              hasInst: false,
              hintText: "رقم الوصل",
              onChanged: (value) {
                receiptNumber = value;
              },
            ),
            RoundedInputField(
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly
                ,
              ],
              keyboardType: TextInputType.number,
              hasInst: false,
              hintText: "المبلغ",
              onChanged: (value) {
                amount = value;
              },
            ),*/
            RoundedButton(
              text: loading ? ' . . .جاري التحويل' : "تحويل",
              pressable: !loading,
              press: () async {
                var response;
                setState(() {
                  loading = true;
                });

                response = await sendTransfer(
                  amount: amount,
                  receiptNumber: maskFormatter.getUnmaskedText(),
                );
                print (maskFormatter.getUnmaskedText());
                print(response);
                setState(() {
                  loading = false;
                });
                receiptController.clear();
                amountController.clear();
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
                        "${jsonResponse['receipt_number'] == null ? "" : jsonResponse['receipt_number'].toString().replaceFirst("[", "").replaceFirst("]", "")}\n ${jsonResponse['amount'] == null ? "" : jsonResponse['amount'].toString().replaceFirst("[", "").replaceFirst("]", "")}"
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
            ),
            SizedBox(height: size.height * 0.1),
          ],
        ),
      ),
    );
  }

  Future<Widget> getDescription() async {
    String? token = await storage.read(key: 'access');
    http.Response response = await http.get(
        Uri.parse(serverIP + '/main2/transferdescription/'),
        headers: {'Authorization': 'Token ' + token!});
    var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
    return Directionality(
        textDirection: TextDirection.rtl,
        child: AutoSizeText(
          jsonResponse['description'],
          maxFontSize: 15,
        ));
  }
}
