import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:promed/components/teacher_button.dart';
import 'package:promed/components/the_app_bar.dart';
import 'package:promed/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class TeachersScreen extends StatefulWidget {
  const TeachersScreen({Key? key}) : super(key: key);

  @override
  _TeachersScreenState createState() => _TeachersScreenState();
}

class _TeachersScreenState extends State<TeachersScreen> {
  Future<http.Response> fetchTeachers() {
    return http.get(Uri.parse(serverIP + '/main/authors/'));
  }
  Future<List<Teacher>> _getTeachers() async {
    var data = await fetchTeachers();
    var jsonData = json.decode(utf8.decode(data.bodyBytes));
    List <Teacher> teachers = [] ;

    for (var T in jsonData){
      Teacher teacher = Teacher(T["id"], T["name"], T["description"], T["image"]);
      teachers.add(teacher);
    }
    print (teachers);
    return teachers;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    size = Size(size.width, kAppBarHeight);
    return Scaffold(
      body:FutureBuilder(
        future: _getTeachers(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.data == null ){
            return Container(
              child: Center(
                child: Text("Lodaing..."),
              ),
            );
          }else{
          return ListView.builder(
            itemCount: snapshot.data.length ,
              itemBuilder: (BuildContext context, int index){
                return TeacherButton(name: snapshot.data[index].name, id: snapshot.data[index].id, info: snapshot.data[index].description , image: snapshot.data[index].image);
              }

          );
        }},
      )
      , appBar: PreferredSize(
        child: TheAppBar(),
        preferredSize: size,
      ),
    );
  }
}

class Teacher{
  final int id ;
  final String name ;
  final String description ;
  final String image ;
  Teacher(this.id, this.name, this.description, this.image );
}