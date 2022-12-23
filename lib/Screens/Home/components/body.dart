import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:promed/components/subject_button.dart';
import 'package:promed/constants.dart';
import 'package:http/http.dart' as http;

Future<http.Response> fetchSubjects() {
  return http.get(Uri.parse(serverIP + '/main/subjects/'));
}

Future<Widget> decodeSubjects(int selected,List<String> libraries) async {
  http.Response response = await fetchSubjects();
  var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
  List<SubjectButton> subjects = [];
  for (var map in jsonResponse) {
    var image = map['icon'];
    if (image.toString() == '') {
      image = (await rootBundle.load('assets/images/subjectIcon.jpg'))
          .buffer
          .asUint8List();
    } else {
      image = base64Decode(map['icon']);
    }
    subjects.add(SubjectButton(
      libraries: libraries,
      selected : selected ,
      subjectName: map['name'],
      lecturerName: map['author'],
      id: map['id'],
      image: image,
        year : map['year']

    ));
  }
  return SingleChildScrollView(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: subjects,
    ),
  );
}
class Body extends StatefulWidget {
  final int selected ;
  final List<String> libraries;
  const Body({required this.selected ,required this.libraries ,Key? key}) : super(key: key);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: decodeSubjects(widget.selected,widget.libraries),
      builder: (BuildContext context, AsyncSnapshot<Widget?> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              color: kPrimaryColor,
            ),
          );
        } else {
          return snapshot.data!;
        }
      },
    );
  }
}
