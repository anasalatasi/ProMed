import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:promed/Screens/Teachers/teacher_info.dart';
import 'package:promed/constants.dart';
import 'dart:convert';
import 'dart:typed_data';

class TeacherButton extends StatelessWidget {
  final String name;
  final String info;
  final int id;
  final String image;
  const TeacherButton({
    Key? key,
    required this.name,
    required this.id,
    required this.image,
    required this.info,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return TeacherInfo(
                id: id,
                image: image,
                info: info,
              );
            },
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.all(8),
        height: size.height * 0.17,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AutoSizeText(
                  name,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 20,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Material(
                elevation: 10,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.memory(base64.decode(image)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
