import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:promed/Screens/EmailVer/email_ver_screen.dart';
import 'package:promed/Screens/Login/login_screen.dart';
import 'package:promed/components/already_have_an_account_acheck.dart';
import 'package:promed/components/rounded_button.dart';
import 'package:promed/components/rounded_input_field.dart';
import 'package:promed/components/rounded_password_field.dart';
import 'package:promed/constants.dart';
import 'package:http/http.dart' as http;

Future<http.Response> sendData({
  required String firstName,
  required String lastName,
  required String userName,
  required String mobileNumber,
  required String email,
  required String password,
  required String password2,
}) {
  return http.post(
    Uri.parse(serverIP + '/main/registration/'),
    headers: {
      'Accept': 'application/json; version =' + version,
    },
    body: {
      'email': email,
      'username': userName,
      'first_name': firstName,
      'last_name': lastName,
      'password': password,
      'password2': password2,
      'phone': mobileNumber,
    },
  );
}

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    String firstName = '';
    String lastName = '';
    String userName = '';
    String mobileNumber = '';
    String email = '';
    String password = '';
    String password2 = '';
    Size size = MediaQuery.of(context).size;
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: size.height * 0.03),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RoundedInputField(inputFormatters: [],
                  small: true,
                  hasInst: false,
                  hintText: "الكنية",
                  onChanged: (value) {
                    lastName = value;
                  },
                ),
                RoundedInputField(inputFormatters: [],
                  small: true,
                  hasInst: false,
                  hintText: "الاسم",
                  onChanged: (value) {
                    firstName = value;
                  },
                ),
              ],
            ),
            RoundedInputField(inputFormatters: [],
              hintText: "اسم المستخدم",
              instructions:
                  'يجب أن يتكون اسم المستخدم من حروف وأرقام والرموز التالية _ @ + . - وألا يحتوي على فراغات',
              onChanged: (value) {
                userName = value;
              },
            ),
            RoundedInputField(inputFormatters: [],
              hintText: "رقم الموبايل",
              instructions:
                  'أدخل رقم الموبايل مع الرمز الدولي.\n مثال: 9639XXXXXXXX+',
              onChanged: (value) {
                mobileNumber = value;
              },
              icon: Icons.phone,
            ),
            RoundedInputField(inputFormatters: [],
              hintText: "البريد الإلكتروني",
              instructions: 'مثال: user@example.com',
              onChanged: (value) {
                email = value;
              },
              icon: Icons.email,
            ),
            RoundedPasswordField(
              hintText: "كلمة السر",
              instructions:
                  'يجب أن تحتوي كلمة السر على ثمانية محارف على الاقل وأن تستوفي شرطين من الشروط التالية على الأقل: ان تحتوي على محرف صفير, مرحف كبير, رقم محرف خاص',
              onChanged: (value) {
                password = value;
              },
            ),
            RoundedPasswordField(
              hintText: "تأكيد كلمة السر",
              instructions: 'أعد ادخال كلمة السر للتأكد',
              onChanged: (value) {
                password2 = value;
              },
            ),
            RoundedButton(
                pressable: true,
                text: "إنشاء حساب",
                color: kPrimaryColor,
                press: () async {
                  final response = await sendData(
                      firstName: firstName,
                      lastName: lastName,
                      userName: userName,
                      mobileNumber: mobileNumber,
                      email: email,
                      password: password,
                      password2: password2);
                  var jsonResponse =
                      jsonDecode(utf8.decode(response.bodyBytes));
                  String errorMessage = '';
                  jsonResponse.forEach(
                      (k, v) => errorMessage = errorMessage + '$k: $v' + '\n');
                  if (response.statusCode == 201) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return LoginScreen();
                        },
                      ),
                    );
                  } else if (response.statusCode == 400) {
                    //: make it simple tool tip next to each field with a problem
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Error'),
                        content: Text(
                          errorMessage,
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
                  } else if (response.statusCode == 406) {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Error'),
                        content: SelectableText(
                          jsonResponse['version'],
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
                }),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              },
            ),
            SizedBox(height: size.height * 0.03)
          ],
        ),
      ),
    );
  }
}
