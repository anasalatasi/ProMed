import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:promed/Screens/ResetPassword/reset_password_screen.dart';
import 'package:promed/components/rounded_button.dart';
import 'package:promed/components/rounded_input_field.dart';
import 'package:http/http.dart' as http;
import 'package:promed/constants.dart';

Future<http.Response> sendData({
  required String username,
}) {
  return http.post(
    Uri.parse(serverIP + '/main/forgot_password/'),
    body: {
      'username': username,
    },
  );
}

class Body extends StatelessWidget {
  const Body({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String username = '';
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
                'سيتم إرسال رمز تحقق إلى بريدك الالكتروني\n لإعادة ضبط كلمة المرور',
                style: TextStyle(
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: size.height * 0.03),
              RoundedInputField(
                inputFormatters: [],
                hasInst: false,
                hintText: "اسم المستخدم أو البريد الإلكتروني",
                onChanged: (value) {
                  username = value;
                },
              ),
              RoundedButton(
                pressable: true,
                text: "إرسال رمز التحقق",
                press: () async {
                  final response = await sendData(username: username);
                  var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
                  print(jsonResponse['email']);
                  if (response.statusCode == 200) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return ResetPasswordScreen(
                            email: jsonResponse['email'],
                          );
                        },
                      ),
                    );
                  } else {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        content: Text(
                          'البريد الإلكتروني أو اسم المستخدم الذي أدخلته غير صحيح',
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
            ],
          ),
        ),
      ),
    );
  }
}
