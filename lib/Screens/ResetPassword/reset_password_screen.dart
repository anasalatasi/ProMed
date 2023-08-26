import 'package:flutter/material.dart';
import 'package:promed/Screens/ResetPassword/components/body.dart';

class ResetPasswordScreen extends StatelessWidget {
  final String email;
  ResetPasswordScreen({required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(email: email),
    );
  }
}
