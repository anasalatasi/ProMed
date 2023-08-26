import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:promed/Screens/Video/components/body.dart';
import 'package:promed/components/the_app_bar.dart';
import 'package:promed/constants.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

Future<http.Response> getUrls(int id) async {
  String? token = await storage.read(key: 'access');
  http.Response response = await http.post(Uri.parse(serverIP + '/main/video/'), headers: {
    'Authorization': 'Token ' + token!,
  }, body: {
    'video': id.toString(),
  });
  return response;
}

class VideoScreen extends StatefulWidget {
  final int id;
  VideoScreen({required this.id});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late InAppWebViewController webView;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown, DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);

    Size size = MediaQuery.of(context).size;
    Size prefSize = Size(size.width, kAppBarHeight);
    return Scaffold(
      body: FutureBuilder<http.Response>(
        future: getUrls(widget.id),
        builder: (BuildContext context, AsyncSnapshot<http.Response?> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                color: kPrimaryColor,
              ),
            );
          } else {
            var jsonResponse = jsonDecode(utf8.decode(snapshot.data!.bodyBytes));
            if (jsonResponse.containsKey('embed')) {
              return InAppWebView(
                initialUrlRequest: URLRequest(
                  url: Uri.parse(serverIP + "/main/video_embed_html_page/" + widget.id.toString() + "/"),
                ),
                initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(preferredContentMode: UserPreferredContentMode.DESKTOP),
                ),
              );
            } else {
              return Body(snapshot.data!);
            }
          }
        },
      ),
      appBar: PreferredSize(
        child: TheAppBar(),
        preferredSize: prefSize,
      ), /*
      drawer: TheAppDrawer(),*/
    );
  }
}
