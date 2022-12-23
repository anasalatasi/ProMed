import 'package:flutter/material.dart';
import 'package:promed/components/SubjectTabs.dart';
import 'package:promed/components/subject_ticket.dart';

class Body extends StatefulWidget {
  final int id;
  final List<String> libraries ;
  Body({required this.id,required this.libraries});

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SubjectTicket(id: widget.id),
        Expanded(
          child: SubjectTabs(id: widget.id, libraries : widget.libraries),
        ),
      ],
    );
  }
}
