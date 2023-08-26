import 'package:flutter/material.dart';
import 'package:promed/constants.dart';

class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool login;
  final VoidCallback press;
  const AlreadyHaveAnAccountCheck({
    Key? key,
    this.login = true,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: press,
          child: Text(
            login ? "إنشاء حساب" : "تسجيل دخول",
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
          login ? "ليس لديك حساب؟" : "لديك حساب؟",
          style: TextStyle(color: kPrimaryColor),
        )
      ],
    );
  }
}
