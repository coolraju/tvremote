import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'dart:async';
import '../Auth/Login.dart';
import '../constants.dart';
import '../widgets/bottombar.dart';
import '../widgets/floatingbutton.dart';
import '../widgets/appbar.dart';
import '../common/SidebarDrawer.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final ScrollController _scrollController = ScrollController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String token = '';
  String currentPage = '1';
  List<dynamic> notifications = [];

  @override
  void initState() {
    _scrollController.addListener(_loadMoreData);
    super.initState();
    _prefs.then((SharedPreferences prefs) {
      setState(() {
        token = prefs.getString('token') ?? '';
      });
      getData(token).then((value) {});
    });
  }

  void _loadMoreData() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      setState(() {
        currentPage = (int.parse(currentPage) + 1).toString();
      });
      getData(token).then((value) {});
    }
  }

  Future<void> getData(token) async {
    try {
      //get data from api
      Response response = await get(
          Uri.parse(
              '${ApiConstants.baseUrl}/client-v1/notifications?page=$currentPage'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          });
      print(response.body.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        setState(() {
          notifications.addAll(data['notifications']);
        });
      } else if (response.statusCode == 401) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        appBar: const AppBarButton(title: 'My Notifications'),
        drawer: const SidebarDrawer(),
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  controller: _scrollController,
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      height: 10,
                    );
                  },
                  itemCount: notifications.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 7,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.notifications,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    notifications[index]['data']['message'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    notifications[index]['created_at'],
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const BottomBarButtons(),
        floatingActionButton: const FloatingButton(),
      ),
    );
  }
}
