import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:promed/components/video_button.dart';
import 'package:promed/constants.dart';
import 'package:http/http.dart' as http;

Future<http.Response> fetchVideos(int id) async {
  String? token = await storage.read(key: 'access');
  return http.post(Uri.parse(serverIP + '/main/lecture/'), headers: {
    'Authorization': 'Token ' + token!
  }, body: {
    'lecture': id.toString(),
  });
}

Future<Widget> decodeVideos(int id) async {
  http.Response response = await fetchVideos(id);
  var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
  print(response.statusCode);
  List<VideoButton> videos = [];
  for (var map in jsonResponse) {
    videos.add(VideoButton(
      videoName: map['name'],
      id: map['id'],
    ));
  }
  return SingleChildScrollView(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: videos,
    ),
  );
}

class Body extends StatelessWidget {
  final int id;
  Body({required this.id});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: decodeVideos(id),
      builder: (BuildContext context, AsyncSnapshot<Widget?> snapshot) {
        if (!snapshot.hasData) {
          return Center(
              child: CircularProgressIndicator(
            color: kPrimaryColor,
          ));
        } else {
          return snapshot.data!;
        }
      },
    );
  }
}
