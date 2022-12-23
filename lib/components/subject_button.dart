import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:promed/Screens/Subject/subject_screen.dart';

class SubjectButton extends StatelessWidget {
  final selected;
  final subjectName;
  final year;
  final lecturerName;
  final int id;
  final image;
  final List <String> libraries ;
  const SubjectButton({
    Key? key,
    required this.selected,
    required this.subjectName,
    required this.lecturerName,
    required this.id,
    required this.libraries,
    required this.image,
    required this.year
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if(selected==year||selected==0)
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return SubjectScreen(id: id,libraries: libraries,);
            },
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.all(8),
        height: size.height * 0.15,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: size.width * 0.6,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 8, 4),
                    child: AutoSizeText(
                      subjectName,
                      maxLines: 2,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 4, 8, 0),
                  child: AutoSizeText(
                    lecturerName,
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 0, 8, 0),
              child: Image.memory(
                image,
                height: size.height * 0.13,
              ),
            ),
          ],
        ),
      ),
    );
    else return Container();
  }
}
