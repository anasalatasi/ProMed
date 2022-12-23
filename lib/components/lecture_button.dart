import 'package:flutter/material.dart';
import 'package:promed/Screens/Home/home_screen.dart';
import 'package:promed/Screens/Videos/videos_screen.dart';
import 'package:promed/constants.dart';
import 'package:http/http.dart' as http;

Future<http.Response> purchase(int id) async {
  String? token = await storage.read(key: 'access');
  http.Response response = await http
      .post(Uri.parse(serverIP + '/main/purchase_lecture/'), headers: {
    'Authorization': 'Token ' + token!,
  }, body: {
    'lecture': id.toString(),
  });
  return response;
}

class LectureButton extends StatefulWidget {
  final List<String> libraries ;
  final lectureName;
  final price;
  final id;
  bool open;
  LectureButton({
    Key? key,
    required this.libraries,
    required this.lectureName,
    required this.price,
    required this.id,
    required this.open,
  }) : super(key: key);

  @override
  _LectureButtonState createState() => _LectureButtonState();
}

class _LectureButtonState extends State<LectureButton> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        if (widget.open) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return VideosScreen(id: widget.id,libraries: widget.libraries);
              },
            ),
          );
        } else {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('طلب شراء'),
              content: Text(
                'السعر: ' +
                    widget.price.toString() +
                    " ل.س\n عندما تقوم بشراء المحاضرة فأنت تقوم بشراء ترخيص المشاهدة لمدة سنة واحدة فقط",
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    http.Response response = await purchase(widget.id);
                    if (response.statusCode == 202) {
                      print('set state');
                      Navigator.pop(context, 'شراء');
                      setState(() {
                        widget.open = true;
                      });
                    } else {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Error'),
                          content: Text(
                            'عذرا لم تتم عملية الشراء.',
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'موافق'),
                              child: const Text('موافق'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: const Text('شراء'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, 'إلغاء'),
                  child: const Text('إلغاء'),
                ),
              ],
            ),
          );
        }
      },
      child: Container(
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.all(8),
        height: size.height * 0.10,
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 30.0 - 4.5 * toDouble(widget.open)),
              child: Image.asset(
                "assets/images/lock" + toStringNum(widget.open) + ".png",
                height: size.height * 0.1,
                width: size.width * 0.1,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child :Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    widget.lectureName,
                    style: TextStyle(
                  //this is old fontSize    fontSize: ((size.height + size.width) / 2.0) * 0.035,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                )
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'السعر : ' + widget.price.toString() + ' ل.س',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontSize: ((size.height + size.width) / 2.0) * 0.025,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String toStringNum(bool open) {
    if (open)
      return '1';
    else
      return '0';
  }

  double toDouble(bool open) {
    if (open)
      return 1.0;
    else
      return 0.0;
  }
}
