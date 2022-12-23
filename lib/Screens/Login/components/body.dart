import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:promed/Screens/EmailVer/email_ver_screen.dart';
import 'package:promed/Screens/ForgotPassword/forgot_password_screen.dart';
import 'package:promed/Screens/Login/components/background.dart';
import 'package:promed/Screens/Signup/signup_screen.dart';
import 'package:promed/Screens/Home/home_screen.dart';
import 'package:promed/components/already_have_an_account_acheck.dart';
import 'package:promed/components/rounded_button.dart';
import 'package:promed/components/rounded_input_field.dart';
import 'package:promed/components/rounded_password_field.dart';
import 'package:promed/components/text_field_container.dart';
import 'package:promed/constants.dart';
import 'package:http/http.dart' as http;

Future<http.Response> sendData({
  required String login,
  required String password,
}) {
  return http.post(
    Uri.parse(serverIP + '/main/login/'),
    headers: {
      'Accept': 'application/json; version =' + version,
    },
    body: {
      'username': login,
      'password': password,
    },
  );
}
class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool isLoading = false ;
  final userController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  void initState() {

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    String login = '';
    String password = '';
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: size.height * 0.03),
            Image.asset(
              "assets/images/Logo.jpg",
              height: size.height * 0.35,
            ),
            SizedBox(height: size.height * 0.03),

            TextFieldContainer(
              child: TextField(
                  controller: userController,
                  textAlign: TextAlign.right,
                  onChanged: (value) {
                    login = value;
                  },
                  cursorColor: kPrimaryColor,
                  decoration: InputDecoration(
                    hintText: "اسم المستخدم أو البريد الإلكتروني",
                    hintStyle: TextStyle(
                      fontSize: 14,
                    ),
                    suffixIcon: Icon(
                      Icons.person,
                      color: kPrimaryColor,
                    ),
                    border: InputBorder.none,
                  ),
                  inputFormatters: []),
            ),

            TextFieldContainer(
              child: TextField(
                  controller: passwordController,
                  textAlign: TextAlign.right,
                  onChanged: (value) {
                    password = value;
                  },
                  obscureText: true,
                  cursorColor: kPrimaryColor,
                  decoration: InputDecoration(
                    hintText: "كلمة السر",
                    hintStyle: TextStyle(
                      fontSize: 14,
                    ),
                    suffixIcon: Icon(
                      Icons.lock,
                      color: kPrimaryColor,
                    ),
                    border: InputBorder.none,
                  ),
                  inputFormatters: []),
            ),

            RoundedButton(
                pressable: true,
                text: "تسجيل الدخول",
                press: () async {
                  setState(() {
                    isLoading = true;
                  });
                  final response =
                      await sendData(login: login, password: password);
                  var jsonResponse =
                      jsonDecode(utf8.decode(response.bodyBytes));
                  print ("login : ${response.statusCode}");
                  if (response.statusCode == 200) {
                    await storage.write(
                        key: 'access', value: jsonResponse['access']);
                    await storage.write(
                        key: 'username', value: jsonResponse['username']);
                    setState(() {
                      isLoading = false ;
                    });
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(),
                        ),
                        (Route<dynamic> route) => false);
                  } else if (response.statusCode == 400) {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        content: Text(
                          'اسم المستخدم أو كلمة المرور غير صحيحة.\n حاول مرة أخرى أو أعد ضبط كلمة المرور.\n في حال واجهتك مشاكل احذف اسم المستخدم وكلمة السر وأعد ادخالهما',
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
                        //title: const Text('AlertDialog Title'),
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
                  }else if(password.length<1 || login.length<1) {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('توجد حقول فارغة'),
                        content: Text(
                          'عذرا, تأكد من ملأ خانة اسم المستخدم و كلمة المرور.',
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              print(jsonResponse.toString());
                              Navigator.pop(context);
                            },
                            child: const Text('رجوع'),
                          ),
                        ],
                      ),
                    );

                    /* }
                    else if (response.statusCode == 400) {
                    print('unverified if is on');
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('حساب غير موثق'),
                        content: Text(
                          'عذرا, لم تقم بتوثيق حسابك من خلال البريد الالكتروني.',
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              print(jsonResponse.toString());
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return EmailVerScreen(
                                        userName: jsonResponse['username']);
                                  },
                                ),
                              );
                            },
                            child: const Text('توثيق'),
                          ),
                        ],
                      ),
                    );*/
                  }
                  setState(() {
                    userController.clear();
                    passwordController.clear();
                    isLoading=false;
                  });
                }),
            Visibility(visible: isLoading, child: CircularProgressIndicator(color: kPrimaryColor,)),
            SizedBox(height: size.height * 0.04),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AlreadyHaveAnAccountCheck(
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return SignUpScreen();
                        },
                      ),
                    );
                  },
                ),
                Container(
                  height: size.height * 0.03,
                  width: 1,
                  color: kPrimaryColor,
                  margin: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return ForgotPasswordScreen();
                        },
                      ),
                    );
                  },
                  child: Text(
                    'نسيت كلمة السر',
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                        color: kPrimaryColor, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
