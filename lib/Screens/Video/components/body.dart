import 'package:auto_size_text/auto_size_text.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Body extends StatefulWidget {
  final http.Response response;
  Body(this.response);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late BetterPlayerController _betterPlayerController;
  var jsonResponse;
  @override
  void initState() {
    BetterPlayerConfiguration betterPlayerConfiguration =
        BetterPlayerConfiguration(
      aspectRatio: 16 / 9,
      fit: BoxFit.contain,
    );
    Map<String, String> urls = {};
    jsonResponse = jsonDecode(utf8.decode(widget.response.bodyBytes));
    jsonResponse.forEach((k, v) => urls[k] = v);
    print(urls.toString());
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      urls.values.first,
      resolutions: urls,
    );
    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    _betterPlayerController.setupDataSource(dataSource);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: BetterPlayer(controller: _betterPlayerController),
        ),
        AutoSizeText(
          jsonResponse['name'],
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
/*import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'package:promed/constants.dart';

Future<http.Response> getUrl(int id) async {
  String? token = await storage.read(key: 'access');
  http.Response response =
      await http.post(Uri.parse(serverIP + '/main/video/'), headers: {
    'Authorization': 'Token ' + token!,
  }, body: {
    'video': id.toString(),
  });
  return response;
}

Future<Widget> Video(int id) async {
  http.Response response = await getUrl(id);
  var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));

  final videoPlayerController =
      VideoPlayerController.network(jsonResponse['url']);

  final chewieController = ChewieController(
    videoPlayerController: videoPlayerController,
    autoPlay: true,
    looping: false,
    autoInitialize: true,
  );
  return Center(
    child: Chewie(
      controller: chewieController,
    ),
  );
}

class Body extends StatefulWidget {
  final int id;
  Body({required this.id});

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Future<void> initState() async {
    super.initState();
    //await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: Video(widget.id),
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

  @override
  void dispose() {
    super.dispose();
  }
}
*/
