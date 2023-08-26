import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:promed/components/text_field_container.dart';
import 'package:promed/constants.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final String instructions;
  final IconData icon;
  final bool small;
  final bool hasInst;
  final ValueChanged<String> onChanged;
  final TextInputType keyboardType ;
  final List<TextInputFormatter> inputFormatters;
  //final TextEditingController controller;
  const RoundedInputField({
    Key? key,
    required this.hintText,
    this.icon = Icons.person,
    required this.onChanged,
    this.small = false,
    this.hasInst = true,
    this.instructions = "",
    this.keyboardType = TextInputType.text ,
    required this.inputFormatters ,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (small) {
      return TextFieldContainer(
        child: TextField(
          textAlign: TextAlign.right,
          onChanged: onChanged,
          cursorColor: kPrimaryColor,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 14,
            ),
            suffixIcon: Icon(
              icon,
              color: kPrimaryColor,
            ),
            border: InputBorder.none,
          ),
        ),
        small: small,
      );
    }
    return TextFieldContainer(
      child: TextField(
        textAlign: TextAlign.right,
        onChanged: onChanged,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 14,
          ),
          prefixIcon: Visibility(
            replacement: Opacity(opacity: 0.0, child: SizedBox.shrink()),
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
            icon,
            color: kPrimaryColor,
          ),
          border: InputBorder.none,
        ),
        keyboardType: keyboardType,
        inputFormatters:inputFormatters
      ),
      small: small,
    );
  }
}
