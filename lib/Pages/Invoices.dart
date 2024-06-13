import 'package:flutter/material.dart';
import '../common/SidebarDrawer.dart';
import 'Invoice.dart';
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

//dynamic invoices list screen

class Invoices extends StatefulWidget {
  const Invoices({super.key});

  @override
  _InvoicesState createState() => _InvoicesState();
}

class _InvoicesState extends State<Invoices> {
  final ScrollController _scrollController = ScrollController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String token = '';
  String currentPage = '1';
  List<dynamic> invoices = [];
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
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        appBar: const AppBarButton(title: 'My Invoices'),
        drawer: const SidebarDrawer(),
        body: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
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
              // listview with pagination
              Expanded(
                child: ListView.separated(
                  // physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  controller: _scrollController,
                  itemCount: invoices.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 15),
                  itemBuilder: (context, index) {
                    var status = invoices[index]['status'] == 1
                        ? "( Unpaid )"
                        : "( Paid )";

                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Invoice(id: invoices[index]['id']),
                          ),
                        );
                      },
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.blue,
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
                                    Icons.receipt,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, top: 2, bottom: 2),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Invoice #${invoices[index]['id']}"),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 5,
                                        width: 5,
                                        margin:
                                            const EdgeInsets.only(top: 5, bottom: 5),
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Text(
                                          status,
                                          style: TextStyle(
                                            color:
                                                invoices[index]['status'] == 1
                                                    ? Colors.red
                                                    : Colors.green,
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
                              padding: const EdgeInsets.only(top: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                      '${"Amount : " + invoices[index]['currency']['symbol']}${invoices[index]['total']} ' + invoices[index]['currency']['code']),
                                  const SizedBox(height: 2),
                                  Text(invoices[index]['duedate'])
                                ],
                              ),
                            )
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

  Future<void> getData(token) async {
    try {
      //get data from api
      Response response = await get(
          Uri.parse(
              '${ApiConstants.baseUrl}/client-v1/invoices?page=$currentPage'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          });
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print(data);
        if (data['success'] == true) {
          setState(() {
            invoices.addAll(data['invoices']['data']);
          });
        } else {
          if (data['message'] == 'Unauthenticated.') {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.remove('token');
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const LoginPage()));
          }
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
