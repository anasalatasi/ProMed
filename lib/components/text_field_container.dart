import 'package:flutter/material.dart';
import 'package:promed/constants.dart';

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  final bool small;
  const TextFieldContainer({
    Key? key,
    required this.child,
    this.small = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 4.5),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      width: small ? size.width * 0.38 : size.width * 0.8,
      decoration: BoxDecoration(
        color: kPrimaryLightColor,
        borderRadius: BorderRadius.circular(29),
      ),
      child: child,
    );
  }
}
