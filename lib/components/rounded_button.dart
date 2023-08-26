import 'package:flutter/material.dart';
import 'package:promed/constants.dart';

class RoundedButton extends StatefulWidget {
  final String text;
  final press;
  final Color color, textColor;
  final bool pressable;
  const RoundedButton({
    Key? key,
    required this.text,
    required this.press,
    this.color = kPrimaryColor,
    this.textColor = Colors.white,
    required this.pressable,
  }) : super(key: key);

  @override
  _RoundedButtonState createState() => _RoundedButtonState();
}

class _RoundedButtonState extends State<RoundedButton> {
  get pressable => widget.pressable;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 40),
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: widget.color,
            ),
            onPressed: pressable ? widget.press : () {},
            child: Text(
              widget.text,
              style: TextStyle(color: widget.textColor),
            ),
          ),
        ),
      ),
    );
  }
}
