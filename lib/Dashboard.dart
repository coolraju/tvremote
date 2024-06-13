import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:vpnpanel/Pages/Invoices.dart';
import 'package:vpnpanel/Pages/Orders.dart';
import 'package:vpnpanel/Pages/Services.dart';
import 'package:vpnpanel/Pages/TicketReply.dart';
import 'package:vpnpanel/Pages/Tickets.dart';
import 'common/SidebarDrawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets/bottombar.dart';
import 'widgets/floatingbutton.dart';
import 'widgets/appbar.dart';
import 'dart:convert';
import 'Auth/Login.dart';
import 'common/SmarterDialog.dart';
import '../constants.dart';

//dashboard screen with welcome msg and drawer left side bar
class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String token = '';
  String firstname = '';
  List<dynamic> gridItems = ['0', '0', '0', '0'];
  List<dynamic> tickets = [];
  String loginError = '';
  @override
  void initState() {
    super.initState();
    _prefs.then((SharedPreferences prefs) {
      setState(() {
        token = prefs.getString('token') ?? '';
        firstname = prefs.getString('firstname') ?? 'User';
      });
      //show loader
      SmarterDialog.show(context, "Loading", "Please wait...");
      getData(token).then((value) {
        //hide loader
        SmarterDialog.hide(context);
        if (loginError == 'Unauthenticated') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //grids name in array
    List<String> gridNames = [
      'My Orders',
      'Invoices',
      'Services',
      'Tickets'
      // 'My Credits'
    ];
    // print("dashboarddata: $gridItems");
    //dashboad tiles array
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        appBar: const AppBarButton(title: 'My Dashboard'),
        drawer: const SidebarDrawer(),
        body: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        // search box
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
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 20);
                          },
                          itemCount: gridItems.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                if (index == 0) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Orders()),
                                  );
                                }
                                if (index == 1) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Invoices()),
                                  );
                                }
                                if (index == 2) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Services()),
                                  );
                                }
                                if (index == 3) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Tickets()),
                                  );
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(20),
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Card(
                                      clipBehavior: Clip.antiAlias,
                                      elevation: 0,
                                      margin: const EdgeInsets.all(0),
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        padding: const EdgeInsets.all(0),
                                        child: Icon(Icons.notifications,
                                            color: Colors.white),
                                        decoration: BoxDecoration(
                                          color: Color(0xff8381ff),
                                          borderRadius:
                                              BorderRadius.circular(17),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            left: 12, top: 14, bottom: 9),
                                        child: Text(gridNames[index])),
                                    const Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 14),
                                      child: Text(
                                        gridItems[index],
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 2),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Column(
                                      children: [
                                        Text(
                                          'Recent Tickets',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                            width: 10,
                                            child: Divider(
                                              color: Colors.blue,
                                            )),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const Tickets()),
                                          );
                                        },
                                        child: const Text('View All'),
                                      ),
                                    ),
                                    // const SizedBox(height: 20),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(0),
                                child: ListView.separated(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(height: 10);
                                  },
                                  itemCount: tickets.length,
                                  itemBuilder: (context, index) {
                                    var ticketsubject =
                                        tickets[index]['subject'].toString();
                                    var ticketid = tickets[index]['id'];
                                    var ticketstatus =
                                        tickets[index]['status'] == 0
                                            ? 'open'
                                            : 'closed';
                                    return Container(
                                      padding: const EdgeInsets.all(10),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Ticket # $ticketid',
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                'Subject: $ticketsubject',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                              Text(
                                                'Status: $ticketstatus',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          TicketReply(
                                                              id: ticketid)));
                                            },
                                            child: const Text('View'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
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

  //get data from api
  Future<void> getData(token) async {
    try {
      Response response = await get(
        Uri.parse('${ApiConstants.baseUrl}/client-v1/dashboard/dashcount'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print(data['data']['tickets']);
        if (data['success'] == true) {
          setState(() {
            gridItems = [
              data['data']['orders'].toString(),
              data['data']['invoicecount'].toString(),
              data['data']['servicecount'].toString(),
              data['data']['ticketcount'].toString(),
            ];
            tickets.addAll(data['data']['tickets']);
          });
        } else {
          if (data['message'] == 'Unauthenticated.') {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.remove('token');
            setState(() {
              loginError = 'Unauthenticated';
            });
          }
        }
      } else {
        // print(response.statusCode == 401);
        if (response.statusCode == 401) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.remove('token');
          setState(() {
            loginError = 'Unauthenticated';
          });
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
