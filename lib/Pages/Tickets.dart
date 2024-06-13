import 'package:flutter/material.dart';
import '../common/SidebarDrawer.dart';
import 'TicketReply.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../Auth/Login.dart';
import '../common/SmarterDialog.dart';
import '../constants.dart';
import '../widgets/bottombar.dart';
import '../widgets/floatingbutton.dart';
import '../widgets/appbar.dart';

//dynamic tickets list screen

class Tickets extends StatefulWidget {
  const Tickets({super.key});

  @override
  _TicketsState createState() => _TicketsState();
}

class _TicketsState extends State<Tickets> {
  final ScrollController _scrollController = ScrollController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String token = '';
  String currentPage = '1';
  List<dynamic> tickets = [];

  @override
  void initState() {
    _scrollController.addListener(_loadMoreData);
    super.initState();
    _prefs.then((SharedPreferences prefs) {
      setState(() {
        token = prefs.getString('token') ?? '';
      });
      SmarterDialog.show(context, "Loading", "Please wait...");
      getData(token).then((value) {
        SmarterDialog.hide(context);
      });
    });
  }

  void _loadMoreData() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      setState(() {
        currentPage = (int.parse(currentPage) + 1).toString();
      });
      SmarterDialog.show(context, "Loading", "Please wait1...");
      getData(token).then((value) {
        SmarterDialog.hide(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        appBar: const AppBarButton(title: 'Tickets'),
        drawer: const SidebarDrawer(),
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Search',
                    hintText: 'Search',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ListView.separated(
                controller: _scrollController,
                shrinkWrap: true,
                itemCount: tickets.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TicketReply(
                                  id: tickets[index]['id'],
                                )),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 30,
                            width: 30,
                            padding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 2),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Icon(
                              Icons.support_agent,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16, left: 2),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Ticket #${tickets[index]['id']}"),
                                const SizedBox(height: 5),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 5,
                                      width: 5,
                                      margin: const EdgeInsets.only(
                                          top: 5, bottom: 5),
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Text(
                                        tickets[index]['department']['name']
                                            .toString(),
                                        style: const TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          const Spacer(),
                          Padding(
                              padding: const EdgeInsets.only(top: 5, bottom: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 1),
                                    child: Text('${tickets[index]['subject']}'),
                                  ),
                                  const SizedBox(
                                    height: 1,
                                  ),
                                  Text(tickets[index]['created_at'])
                                ],
                              ))
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(height: 10);
                },
              )
            ],
          ),
        ),
        bottomNavigationBar: const BottomBarButtons(),
        floatingActionButton: const FloatingButton(),
      ),
    );
  }

  Future<void> getData(token) async {
    try {
      //get data from api
      Response response = await get(
          Uri.parse(
              '${ApiConstants.baseUrl}/client-v1/tickets?page=$currentPage'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          });
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print(data);
        if (data['success'] == true) {
          setState(() {
            tickets.addAll(data['tickets']['data']);
          });
        } else {
          if (data['message'] == 'Unauthenticated.') {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.remove('token');
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const LoginPage()));
          }
        }
      } else {
        if (response.statusCode == 401) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.remove('token');
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const LoginPage()));
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
