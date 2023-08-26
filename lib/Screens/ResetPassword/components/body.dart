import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:promed/Screens/Login/login_screen.dart';
import 'package:promed/components/rounded_button.dart';
import 'package:promed/components/rounded_input_field.dart';
import 'package:promed/components/rounded_password_field.dart';
import '../../../constants.dart';
import 'package:http/http.dart' as http;

Future<http.Response> sendData({
  required String email,
  required String password,
  required String password2,
  required String verifyCode,
}) {
  return http.post(
    Uri.parse(serverIP + '/main/reset_password/'),
    body: {
      'email': email,
      'password': password,
      'password2': password2,
      'verify_code': verifyCode,
    },
  );
}

class Body extends StatelessWidget {
  final String email;
  const Body({
    required this.email,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String verifyCode = '';
    String password = '';
    String password2 = '';
    return Container(
      width: double.infinity,
      height: size.height,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/forgotpasswordicon.jpg',
                height: size.height * 0.35,
              ),
              SizedBox(height: size.height * 0.03),
              Text(
                'تم إرسال رمز التحقق إلى بريدك الإلكتروني',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: size.height * 0.03),
              RoundedInputField(
                inputFormatters: [],
                hasInst: false,
                hintText: "رمز التحقق",
                onChanged: (value) {
                  verifyCode = value;
                },
              ),
              RoundedPasswordField(
                hasInst: false,
                hintText: 'كلمة السر الجديدة',
                onChanged: (value) {
                  password = value;
                },
              ),
              RoundedPasswordField(
                hasInst: false,
                hintText: 'تأكيد كلمة السر الجديدة',
                onChanged: (value) {
                  password2 = value;
                },
              ),
              RoundedButton(
                pressable: true,
                text: "تحقق",
                press: () async {
                  final response = await sendData(email: email, password: password, password2: password2, verifyCode: verifyCode);
                  var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
                  if (response.statusCode == 200) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return LoginScreen();
                        },
                      ),
                    );
                  } else if (response.statusCode == 400) {
                    print(jsonResponse.toString());
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        //title: const Text('AlertDialog Title'),
                        content: Text(
                          jsonResponse.toString(),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      "إعادة الإرسال",
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.03,
                  ),
                  Text(
                    "لم يصلك الرمز؟",
                    style: TextStyle(color: kPrimaryColor),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
