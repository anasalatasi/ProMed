import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:promed/Screens/Videos/components/body.dart';
import 'package:promed/components/the_app_bar.dart';
import 'package:promed/components/the_drawer.dart';
import 'package:promed/constants.dart';

class VideosScreen extends StatelessWidget {
  final List<String> libraries;
  final int id;
  VideosScreen({required this.id,required this.libraries});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    size = Size(size.width, kAppBarHeight);
    return Scaffold(
      body: Body(id: id),
      appBar: PreferredSize(
        child: TheAppBar(),
        preferredSize: size,
      ),
      drawer: TheAppDrawer(libraries: libraries,),
    );
  }
}
