import 'package:flutter/material.dart';
import 'package:promed/Screens/Subject/components/body.dart';
import 'package:promed/components/the_app_bar.dart';
import 'package:promed/components/the_drawer.dart';
import '../../constants.dart';

class SubjectScreen extends StatefulWidget {
  final List<String> libraries ;
  final int id;
  SubjectScreen({required this.id, required this.libraries});

  @override
  _SubjectScreenState createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    size = Size(size.width,kAppBarHeight);
    return Scaffold(
      body: Body(id: widget.id,libraries: widget.libraries),
      appBar: PreferredSize(
        child: TheAppBar(),
        preferredSize: size,
      ),
      drawer: TheAppDrawer(libraries: widget.libraries,),
    );
  }
}
