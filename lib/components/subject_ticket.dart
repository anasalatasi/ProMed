import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:promed/constants.dart';
import 'package:http/http.dart' as http;
import 'package:auto_size_text/auto_size_text.dart';

Future<http.Response> getData({
  required int id,
}) {
  return http.get(Uri.parse(serverIP + '/main/subject/' + id.toString() + '/'));
}

Widget getTicket(Size size, int id) {
  return FutureBuilder<http.Response>(
    future: getData(id: id),
    builder: (BuildContext context, AsyncSnapshot<http.Response?> snapshot) {
      if (!snapshot.hasData) {
        return Container(
            color: Colors.white,
            height: size.height * 0.27,
            child: Center(child: CircularProgressIndicator()));
      } else {
        final response = snapshot.data;
        var jsonResponse = jsonDecode(utf8.decode(response!.bodyBytes));
        return Container(
          color: Colors.white,
          height: size.height * 0.27,
          //padding: EdgeInsets.all(3.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
                height: size.height * 0.25,
                width: size.width * 0.35,
                child: Material(
                  elevation: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(180.0),
                    ),
                    child: Image.memory(
                      base64Decode(jsonResponse['image']),
                      //height: size.height * 0.35,
                      //width: size.width * 0.3,
                      fit: BoxFit.fill,
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return Center(
                            child: Text('no image')); //Image.asset('name');
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: AutoSizeText(
                        jsonResponse['name'],
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        maxFontSize: 20,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                        child: AutoSizeText(
                          jsonResponse['description'],
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                          maxLines: 10,
                          maxFontSize: 13,
                          minFontSize: 5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
    },
  );
}

class SubjectTicket extends StatelessWidget {
  final int id;
  const SubjectTicket({required this.id, Key? key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return getTicket(size, id);
  }
}
