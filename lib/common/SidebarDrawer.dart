import 'package:flutter/material.dart';
import '../Pages/Orders.dart';
import '../Pages/Invoices.dart';
import '../Pages/Tickets.dart';
import '../Dashboard.dart';
import '../Auth/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Pages/Announcements.dart';
import 'dart:convert';
import 'package:http/http.dart';
import '../constants.dart';
import '../Pages/Contactus.dart';
import '../Pages/Downloads.dart';
import '../Pages/Knowledgebases.dart';
import '../Pages/MyCredits.dart';

//left side bar drawer
class SidebarDrawer extends StatefulWidget {
  const SidebarDrawer({super.key});

  @override
  _SidebarDrawerState createState() => _SidebarDrawerState();
}

class _SidebarDrawerState extends State<SidebarDrawer> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String token = '';
  String firstname = '';
  String mycredits = '';
  String selected = 'Dashboard';
  @override
  void initState() {
    super.initState();
    _prefs.then((SharedPreferences prefs) {
      setState(() {
        token = prefs.getString('token') ?? '';
        firstname = prefs.getString('firstname') ?? 'User';
        selected = prefs.getString('selected') ?? 'Dashboard';
        // getMyCredits(token);
      });
    });
  }

  Future getMyCredits(token) async {
    try {
      Response response = await get(
        Uri.parse('${ApiConstants.baseUrl}/client-v1/getcredits'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print(data);
        if (data['success'] == true) {
          setState(() {
            mycredits = data['credits'].toString();
          });
        }
      }
    } catch (e) {
      print(e.toString());
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(e.toString()),
      //   ),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(color: Color(0xff020143)),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    DrawerHeader(
                      child: Column(
                        children: <Widget>[
                          const Image(
                            image: AssetImage('assets/images/logo.png'),
                            // width: 100,
                            height: 40,
                          ),
                          Text('\nWelcome, $firstname \n',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16)),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: selected == 'Dashboard'
                              ? Color(0xff2723d8)
                              : Colors.transparent),
                      child: ListTile(
                        title: const Text(
                          'Dashboard',
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        ),
                        leading: const Icon(
                          Icons.home,
                          size: 20.0,
                          color: Colors.white,
                        ),
                        onTap: () {
                          // setState(() {
                          // selected = 'Dashboard';
                          _prefs.then((SharedPreferences prefs) {
                            prefs.setString('selected', 'Dashboard');
                          });
                          // });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Dashboard()),
                          );
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: selected == 'Orders'
                              ? Color(0xff2723d8)
                              : Colors.transparent),
                      child: ListTile(
                        title: const Text(
                          'Orders',
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        ),
                        leading: const Icon(
                          Icons.shopping_bag,
                          size: 20.0,
                          color: Colors.white,
                        ),
                        onTap: () {
                          // setState(() {
                          //   selected = 'Orders';
                          // });
                          _prefs.then((SharedPreferences prefs) {
                            prefs.setString('selected', 'Orders');
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Orders()),
                          );
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: selected == 'Invoices'
                              ? Color(0xff2723d8)
                              : Colors.transparent),
                      child: ListTile(
                        title: const Text(
                          'Invoices',
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        ),
                        leading: const Icon(
                          Icons.receipt,
                          size: 20.0,
                          color: Colors.white,
                        ),
                        onTap: () {
                          // setState(() {
                          //   selected = 'Invoices';
                          // });
                          _prefs.then((SharedPreferences prefs) {
                            prefs.setString('selected', 'Invoices');
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Invoices()),
                          );
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: selected == 'Tickets'
                              ? Color(0xff2723d8)
                              : Colors.transparent),
                      child: ListTile(
                        title: const Text(
                          'Tickets',
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        ),
                        leading: const Icon(
                          Icons.support,
                          size: 20.0,
                          color: Colors.white,
                        ),
                        onTap: () {
                          // setState(() {
                          //   selected = 'Tickets';
                          // });
                          _prefs.then((SharedPreferences prefs) {
                            prefs.setString('selected', 'Tickets');
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Tickets()),
                          );
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: selected == 'Announcements'
                              ? Color(0xff2723d8)
                              : Colors.transparent),
                      child: ListTile(
                        title: const Text(
                          'Announcements',
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        ),
                        leading: const Icon(
                          Icons.announcement,
                          size: 20.0,
                          color: Colors.white,
                        ),
                        onTap: () {
                          // setState(() {
                          //   selected = 'Announcements';
                          // });
                          _prefs.then((SharedPreferences prefs) {
                            prefs.setString('selected', 'Announcements');
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Announcements()),
                          );
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: selected == 'Knowledge Base'
                              ? Color(0xff2723d8)
                              : Colors.transparent),
                      child: ListTile(
                        title: const Text(
                          'Knowledge Base',
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        ),
                        leading: const Icon(
                          Icons.book,
                          size: 20.0,
                          color: Colors.white,
                        ),
                        onTap: () {
                          // setState(() {
                          //   selected = 'Knowledge Base';
                          // });
                          _prefs.then((SharedPreferences prefs) {
                            prefs.setString('selected', 'Knowledge Base');
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Knowledgebases()),
                          );
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: selected == 'Contact Us'
                              ? Color(0xff2723d8)
                              : Colors.transparent),
                      child: ListTile(
                        title: const Text(
                          'Contact Us',
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        ),
                        leading: const Icon(
                          Icons.contact_mail,
                          size: 20.0,
                          color: Colors.white,
                        ),
                        onTap: () {
                          // setState(() {
                          //   selected = 'Contact Us';
                          // });
                          _prefs.then((SharedPreferences prefs) {
                            prefs.setString('selected', 'Contact Us');
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Contactus()),
                          );
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: selected == 'My Credits'
                              ? Color(0xff2723d8)
                              : Colors.transparent),
                      child: ListTile(
                        title: const Text(
                          'My Credits',
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        ),
                        leading: const Icon(
                          Icons.credit_score,
                          size: 20.0,
                          color: Colors.white,
                        ),
                        onTap: () {
                          // setState(() {
                          //   selected = 'My Credits';
                          // });
                          _prefs.then((SharedPreferences prefs) {
                            prefs.setString('selected', 'My Credits');
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyCredits()),
                          );
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: selected == 'Downloads'
                              ? Color(0xff2723d8)
                              : Colors.transparent),
                      child: ListTile(
                        title: const Text(
                          'Downloads',
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        ),
                        leading: const Icon(
                          Icons.download,
                          size: 20.0,
                          color: Colors.white,
                        ),
                        onTap: () {
                          // setState(() {
                          //   selected = 'Downloads';
                          // });
                          _prefs.then((SharedPreferences prefs) {
                            prefs.setString('selected', 'Downloads');
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Downloads()),
                          );
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: selected == 'Logout'
                              ? Color(0xff2723d8)
                              : Colors.transparent),
                      child: ListTile(
                        title: const Text(
                          'Logout',
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        ),
                        leading: const Icon(
                          Icons.logout,
                          size: 20.0,
                          color: Colors.white,
                        ),
                        onTap: () {
                          _prefs.then((SharedPreferences prefs) {
                            prefs.remove('token');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()),
                            );
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
                child: const Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Column(
                      children: <Widget>[
                        Divider(),
                        ListTile(
                            leading: Icon(Icons.help),
                            title: Text('Version 0.0.1'))
                      ],
                    ))),
          ],
        ),
      ),
    );
  }
}
