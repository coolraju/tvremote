import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Pages/Profile.dart';
import '../Pages/Notifications.dart';

class AppBarButton extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  const AppBarButton({super.key, required this.title});

  @override
  AppBarbuttonState createState() => AppBarbuttonState();

  @override
  Size get preferredSize => const Size(double.infinity, 50);
}

class AppBarbuttonState extends State<AppBarButton> {
  String clientpic = 'assets/images/avatar1.png';
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String profilepic = '';
  @override
  void initState() {
    super.initState();
    _prefs.then((SharedPreferences prefs) {
      setState(() {
        profilepic = prefs.getString('profilepic') ?? '';
      });
    });
  }

  Widget build(BuildContext context) {
    return AppBar(
      title: Text(widget.title),
      // add two buttons in appbar
      actions: [
        Card(
          clipBehavior: Clip.antiAlias,
          elevation: 0,
          margin: const EdgeInsets.all(0),
          // color: Colors.grey[100],
          shape: RoundedRectangleBorder(
            // side: const BorderSide(
            //     color: Colors.red, width: 2),
            borderRadius: BorderRadius.circular(2.0),
          ),
          child: InkWell(
            onTap: () {
              // navigate to
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Notifications()),
              );
            },
            child: Container(
              height: 30,
              width: 30,
              padding: const EdgeInsets.all(0),
              margin: EdgeInsets.only(right: 20),
              child: Icon(Icons.notifications, color: Colors.white),
              decoration: BoxDecoration(
                color: Color(0xff8381ff),
                borderRadius: BorderRadius.circular(17),
              ),

              // child: const Stack(
              //   alignment: Alignment.bottomRight,
              //   children: [Text("Notification Image Here")],
              // ),
            ),
          ),
        ),
        Card(
          clipBehavior: Clip.antiAlias,
          elevation: 0,
          margin: const EdgeInsets.all(0),
          // color: Colors.grey[100],
          shape: RoundedRectangleBorder(
            // side: const BorderSide(
            //     color: Colors.red, width: 2),
            borderRadius: BorderRadius.circular(2.0),
          ),
          child: InkWell(
            onTap: () {
              // navigate to
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Profile()),
              );
            },
            child: Container(
              height: 30,
              width: 30,
              padding: const EdgeInsets.all(10),
              margin: EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                image: profilepic == ''
                    ? DecorationImage(
                        image: AssetImage(clientpic), fit: BoxFit.cover)
                    : DecorationImage(
                        image: NetworkImage(profilepic), fit: BoxFit.cover),
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xffcdcdf2).withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              // child: const Stack(
              //   alignment: Alignment.bottomRight,
              //   children: [Text("Profile Image Here")],
              // ),
            ),
          ),
        ),
      ],
    );
  }
}
