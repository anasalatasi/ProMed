import 'package:flutter/material.dart';
import 'package:promed/components/text_field_container.dart';
import 'package:promed/constants.dart';

class RoundedPasswordField extends StatelessWidget {
  final String hintText;
  final String instructions;
  final ValueChanged<String> onChanged;
  final bool hasInst;
  const RoundedPasswordField({
    Key? key,
    required this.onChanged,
    this.hintText = "",
    this.instructions = "",
    this.hasInst = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      small: false,
      child: TextField(
        textAlign: TextAlign.right,
        obscureText: true,
        onChanged: onChanged,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Visibility(
            visible: hasInst,
            child: IconButton(
              onPressed: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  //title: const Text('AlertDialog Title'),
                  content: Text(
                    instructions,
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
              ),
              icon: Icon(Icons.info_outline),
            ),
          ),
          suffixIcon: Icon(
            Icons.lock,
            color: kPrimaryColor,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
