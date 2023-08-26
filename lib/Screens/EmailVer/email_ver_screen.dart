import 'package:flutter/material.dart';
import 'package:promed/Screens/EmailVer/components/body.dart';

class EmailVerScreen extends StatelessWidget {
  final String userName;
  EmailVerScreen({required this.userName, username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(userName: userName),
    );
  }
}
