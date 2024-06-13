import 'package:flutter/material.dart';
import '../common/SidebarDrawer.dart';
import 'Order.dart';
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

//dynamic orders list screen
class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  final ScrollController _scrollController = ScrollController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String token = '';
  String currentPage = '1';
  List<dynamic> orders = [];
  String loginError = '';
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
        if (loginError == 'Unauthenticated') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        }
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
        appBar: const AppBarButton(title: 'My Orders'),
        drawer: const SidebarDrawer(),
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
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
              Expanded(
                child: ListView.separated(
                  // physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  controller: _scrollController,
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      height: 10,
                    );
                  },
                  itemCount: orders.length,
                  itemBuilder: (BuildContext context, int index) {
                    var status = orders[index]['status'];
                    //status first letter in capital
                    status = status[0].toUpperCase() + status.substring(1);
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Order(
                              id: orders[index]['id'],
                            ),
                            settings: RouteSettings(
                              arguments: orders[index],
                            ),
                          ),
                        );
                      },
                      child: Container(
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 3, vertical: 2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: SizedBox(
                                width: 50,
                                height: 50,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.blue,
                                  ),
                                  child: const Icon(
                                    Icons.shopping_cart,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Order #: ${orders[index]['id']}"),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 5,
                                        width: 5,
                                        margin: const EdgeInsets.only(
                                            top: 5, bottom: 5),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.green,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Text(
                                          status,
                                          style: TextStyle(
                                            color: status == 'Pending'
                                                ? Colors.orange
                                                : status == 'Completed'
                                                    ? Colors.green
                                                    : Colors.blue,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${orders[index]['users']['currency']?['symbol'] ?? '\$'}${orders[index]['total']} ${orders[index]['users']['currency']?['code'] ?? 'USD'}',
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    orders[index]['created_at'],
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
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

  // dialog seach box
  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Search'),
          content: const TextField(
            decoration: InputDecoration(hintText: 'Search'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Search'),
            ),
          ],
        );
      },
    );
  }

  Future<void> getData(token) async {
    try {
      Response response = await get(
        Uri.parse('${ApiConstants.baseUrl}/client-v1/orders?page=$currentPage'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );
      // print(response);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print(data);
        if (data['success'] == true) {
          setState(() {
            orders.addAll(data['orders']['data']);
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
        if (response.statusCode == 401) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.remove('token');
          setState(() {
            loginError = 'Unauthenticated';
          });
        }
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
