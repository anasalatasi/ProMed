import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:promed/Screens/Login/login_screen.dart';
import 'package:promed/components/rounded_button.dart';
import 'package:promed/components/rounded_input_field.dart';
import '../../../constants.dart';
import 'package:http/http.dart' as http;

Future<http.Response> sendCode(
    {required String userName, required String verifyCode}) {
  return http.post(
    Uri.parse(serverIP + '/main/verify_email/'),
    body: {
      'verify_code': verifyCode,
      'username': userName,
    },
  );
}

class Body extends StatelessWidget {
  final String userName;
  const Body({
    required this.userName,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String verifyCode = '';
    Size size = MediaQuery.of(context).size;
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
                'assets/images/email_verification.png',
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
                hasInst: false,
                hintText: "رمز التحقق",
                onChanged: (value) {
                  verifyCode = value;
                },
                inputFormatters: [],
              ),
              RoundedButton(
                pressable: true,
                text: "تحقق",
                press: () async {
                  print(verifyCode);
                  http.Response response = await sendCode(
                      userName: userName, verifyCode: verifyCode);
                  print(response.statusCode);
                  print(response.body);
                  if (response.statusCode == 202) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return LoginScreen();
                        },
                      ),
                    );
                  }
                  if (response.statusCode == 406) {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Error'),
                        content: Text(
                          'رمز التحقق الذي أدخلته غير صحيح',
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
                  SizedBox(width: size.width * 0.03),
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
