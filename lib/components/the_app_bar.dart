import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:promed/constants.dart';

class TheAppBar extends StatefulWidget {
  const TheAppBar({
    Key? key,
  }) : super(key: key);

  @override
  _TheAppBarState createState() => _TheAppBarState();
}

class _TheAppBarState extends State<TheAppBar> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AppBar(
      backgroundColor: kPrimaryLightColor,
      foregroundColor: kPrimaryLightColor,
      title: Align(
        alignment: Alignment.bottomRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AutoSizeText(
              'ProMed',
              maxFontSize: 20,
              style: TextStyle(
                color: kPrimaryColor,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: size.width * 0.03,
            ), /*
            FutureBuilder<Widget>(
              future: getPoints(),
              builder: (BuildContext context, AsyncSnapshot<Widget?> snapshot) {
                if (!snapshot.hasData) {
                  return SizedBox.shrink();
                } else {
                  return snapshot.data!;
                }
              },
            ),*/
          ],
        ),
      ),
      actions: <Widget>[],
      iconTheme: IconThemeData(color: kPrimaryColor),
    );
  }
}

class Year {
  final int id;
  final String yearName;
  Year({required this.yearName, required this.id});
}

class Years with ChangeNotifier {
  Year selectedYear = Year(yearName: 'جميع السنوات', id: 10);

  void changeYear(Year newYear) {
    selectedYear = newYear;
    notifyListeners();
  }
}
