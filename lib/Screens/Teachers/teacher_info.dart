import 'dart:convert';

import 'package:flutter/material.dart';

class TeacherInfo extends StatelessWidget {
  final String image;
  final String info;
  final int id;
  const TeacherInfo({Key? key, required this.image, required this.info, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.05),
              Material(
                elevation: 10,
                child: Image.memory(base64.decode(image)),
              ),
              SizedBox(height: size.height * 0.05),
              Container(
                width: size.width * 0.9,
                alignment: Alignment.topRight,
                color: Colors.white,
                child: Text(
                  info,
                  maxLines: 20,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    color: Colors.black,
                    fontSize: size.height * 0.02,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
