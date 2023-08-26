import 'package:flutter/material.dart';
import 'package:promed/Screens/TransferFromLibrary/components/body.dart';

class LibraryTransferScreen extends StatelessWidget {
  final List<String> libraries;
  LibraryTransferScreen(this.libraries);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LTBody(items: libraries,),
    );
  }
}
