import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:promed/Screens/Teachers/teachers_screen.dart';
import 'package:promed/Screens/Transfer/transfer_screen.dart';
import 'package:promed/Screens/TransferFromLibrary/library_transfer_screen.dart';
import 'package:promed/Screens/Welcome/welcome_screen.dart';
import 'package:promed/constants.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class TheAppDrawer extends StatefulWidget {
  final List<String> libraries;
  const TheAppDrawer({Key? key, required this.libraries}) : super(key: key);

  @override
  State<TheAppDrawer> createState() => _TheAppDrawer();
}

class _TheAppDrawer extends State<TheAppDrawer> {
  IconData myArrow = Icons.arrow_right;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.75,
      child: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: <Color>[Colors.white, kPrimaryColor]),
              ),
              child: Center(
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(300),
                      child: Image.asset(
                        'assets/images/default-profile-pic.jpeg',
                        height: size.height * 0.1,
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Expanded(
                      child: FutureBuilder<Widget>(
                        future: getUsername(),
                        builder: (BuildContext context, AsyncSnapshot<Widget?> snapshot) {
                          if (snapshot.hasData) {
                            return snapshot.data!;
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        },
                      ),
                    ),
                    Expanded(
                      child: FutureBuilder<Widget>(
                        future: getPoints(),
                        builder: (BuildContext context, AsyncSnapshot<Widget?> snapshot) {
                          if (snapshot.hasData) {
                            return snapshot.data!;
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            /*
            MenuWidget(
              Icons.contacts_outlined,
              'معلومات الحساب',
              onTap: () {},
            ),
            */
            Padding(
              padding: EdgeInsets.all(0),
              child: ExpansionTile(
                title: Padding(
                  padding: EdgeInsets.all(0),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Row(
                      children: [
                        Padding(padding: const EdgeInsets.all(3.0), child: Icon(Icons.credit_card, color: kPrimaryColor)),
                        SizedBox(
                          width: 8.0,
                        ),
                        Text("تعبئة رصيد", style: TextStyle(fontSize: size.width * 0.040, color: Colors.black)),
                      ],
                    ),
                  ]),
                ),
                onExpansionChanged: (bool expanding) {
                  setState(() {
                    print(expanding);
                    if (expanding) {
                      myArrow = Icons.arrow_drop_down;
                    } else
                      myArrow = Icons.arrow_right;
                  });
                },
                trailing: Icon(
                  myArrow,
                  color: kPrimaryColor,
                ),
                children: [
                  ListTile(
                    title: Text('عن طريق الهرم'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return TransferScreen();
                          },
                        ),
                      );
                    },
                  ),
                  ListTile(
                    title: Text('عن طريق مكتبات معتمدة'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return LibraryTransferScreen(widget.libraries);
                          },
                        ),
                      );
                    },
                  ),
                ],
                //expandedAlignment: Alignment(1,1),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: MenuWidget(
                Icons.info_outline,
                'لمحة عن الأساتذة',
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => TeachersScreen(),
                  ));
                },
                arrow: true,
              ),
            ),
            /*
            MenuWidget(
              Icons.mail_outline,
              'شكاوى',
              onTap: () {},
            ),
            */
            Padding(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: MenuWidget(
                Icons.logout_rounded,
                'تسجيل خروج',
                onTap: () {
                  storage.deleteAll();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => WelcomeScreen(),
                      ),
                      (Route<dynamic> route) => false);
                },
                arrow: true,
              ),
            ),
            SizedBox(height: size.height * 0.02),
            Container(
              height: 1,
              width: double.infinity,
              color: Colors.grey,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Container(
                    height: size.height * 0.041,
                    child: Text(
                      'تواصل معنا',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: size.width * 0.04,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: 1,
              width: double.infinity,
              color: Colors.grey,
            ),
            MenuWidget(
              FontAwesomeIcons.facebookSquare,
              'Facebook',
              onTap: () async {
                await launch('https://www.facebook.com/%D9%85%D9%86%D8%B5%D8%A9-ProMed-%D8%A7%D9%84%D8%AA%D8%B9%D9%84%D9%8A%D9%85%D9%8A%D8%A9-104913855273045/');
              },
              arrow: false,
            ),
            MenuWidget(
              FontAwesomeIcons.whatsappSquare,
              'WhatsApp',
              onTap: () async {
                await launch('https://wa.me/message/F43XCLXMLXD5I1');
              },
              arrow: false,
            ),
            MenuWidget(
              FontAwesomeIcons.telegramPlane,
              'Telegram',
              onTap: () async {
                await launch('https://t.me/ProMedplatform');
              },
              arrow: false,
            ),
            Container(
              height: 1,
              width: double.infinity,
              color: Colors.grey,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Container(
                    height: size.height * 0.041,
                    child: Text(
                      'مشاركة',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: size.width * 0.04,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: 1,
              width: double.infinity,
              color: Colors.grey,
            ),
            MenuWidget(
              Icons.share,
              'شارك التطبيق',
              onTap: () async {
                http.Response response = await http.get(
                  Uri.parse(serverIP + '/main/share/'),
                );
                var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
                Share.share(jsonResponse['link']);
              },
              arrow: false,
            ),
          ],
        ),
      ),
    );
  }

  Future<Widget> getUsername() async {
    String? username = await storage.read(key: 'username');
    return AutoSizeText(
      username!,
      maxFontSize: 17,
      style: TextStyle(fontWeight: FontWeight.bold),
    );
  }

  Future<Widget> getPoints() async {
    String? token = await storage.read(key: 'access');
    http.Response response = await http.get(Uri.parse(serverIP + '/main/points/'), headers: {'Authorization': 'Token ' + token!});
    var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
    return AutoSizeText(
      'الرصيد : ' + jsonResponse['points'].toString() + ' ل.س',
      maxFontSize: 15,
    );
  }
}

class MenuWidget extends StatelessWidget {
  const MenuWidget(this.icons, this.text, {required this.onTap, required this.arrow});

  final IconData icons;
  final String text;
  final VoidCallback onTap;
  final bool arrow;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Icon(
                    icons,
                    color: kPrimaryColor,
                  ),
                ),
                SizedBox(
                  width: 8.0,
                ),
                Text(text, style: TextStyle(fontSize: size.width * 0.040, color: Colors.black)),
              ],
            ),
            if (arrow)
              Icon(
                Icons.arrow_right,
                color: kPrimaryColor,
              ),
          ],
        ),
      ),
    );
  }
}
