import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:promed/components/lecture_button.dart';
import 'package:promed/constants.dart';
import 'package:http/http.dart' as http;

Future<http.Response> fetchLectures(int id) async {
  String? token = await storage.read(key: 'access');
  http.Response response =
      await http.post(Uri.parse(serverIP + '/main/lectures/'), headers: {
    'Authorization': 'Token ' + token!,
  }, body: {
    'course': id.toString(),
  });
  return response;
}

Future<Widget> decodeLectures(int id , List<String> libraries) async {
  http.Response response = await fetchLectures(id);
  var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
  List<LectureButton> courses = [];
  for (var map in jsonResponse) {
    courses.add(LectureButton(
      libraries : libraries,
      lectureName: map['name'],
      price: map['price'],
      id: map['id'],
      open: map['open'],
    ));
  }
  if (courses.isEmpty) {
    return Center(
      child: Text('لا يوجد محاضرات بعد'),
    );
  }
  return SingleChildScrollView(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: courses,
    ),
  );
}

class SubjectTabs extends StatefulWidget {
  final int id;
  final List<String> libraries ;
  SubjectTabs({required this.id,required this.libraries, Key? key}) : super(key: key);

  @override
  _SubjectTabsState createState() => _SubjectTabsState();
}

class _SubjectTabsState extends State<SubjectTabs>
    with TickerProviderStateMixin {
  int get id => widget.id;

  static const List<Tab> myTabs = <Tab>[
    Tab(
      text: 'محاضرات',
    ),
    Tab(
      text: 'اختبارات',
    ),
    Tab(
      text: 'مواد مرفقة',
    ),
  ];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: kAppBarHeight,
        bottom: TabBar(
          indicatorColor: kPrimaryLightColor,
          indicatorWeight: 5,
          controller: _tabController,
          tabs: myTabs,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          FutureBuilder<Widget>(
            future: decodeLectures(id,widget.libraries),
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
          ),
          //Center(child: Text('fuck you')),
          Center(
            child: Text(
              'coming soon',
              style: TextStyle(
                color: kPrimaryColor,
                fontSize: 20,
              ),
            ),
          ),
          Center(
            child: Text(
              'coming soon',
              style: TextStyle(
                color: kPrimaryColor,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
