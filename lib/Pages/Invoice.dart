import 'package:flutter/material.dart';
import '../Auth/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'dart:async';
import '../constants.dart';
import '../widgets/bottombar.dart';
import '../widgets/floatingbutton.dart';
import '../widgets/appbar.dart';
//invoice details screen

class Invoice extends StatefulWidget {
  final int id; // Make the id field final

  const Invoice({super.key, required this.id});

  @override
  _InvoiceState createState() => _InvoiceState();
}

class _InvoiceState extends State<Invoice> {
  dynamic invoice;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String token = '';
  @override
  void initState() {
    super.initState();
    _prefs.then((SharedPreferences prefs) {
      setState(() {
        token = prefs.getString('token') ?? '';
      });
      getData(token);
    });
  }

  Future<void> getData(token) async {
    try {
      //get data from api
      Response response = await get(
          Uri.parse('${ApiConstants.baseUrl}/client-v1/invoice/${widget.id}'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          });
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print(data);
        if (data['success'] == true) {
          setState(() {
            invoice = data['invoice'];
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        appBar: const AppBarButton(title: 'Invoice Details'),
        // drawer: const SidebarDrawer(),
        body: SizedBox(
          width: double.maxFinite,
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Expanded(
                  child: SingleChildScrollView(
                child: invoice == null
                    ? const CircularProgressIndicator()
                    : Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 2),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 2, right: 1),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          children: [
                                            Text("Invoice # ${invoice['id']}"),
                                            SizedBox(
                                              width: 100,
                                              child: Divider(
                                                color: Colors.blue[300],
                                              ),
                                            )
                                          ],
                                        ),
                                        const Spacer(),
                                        const Padding(
                                          padding: EdgeInsets.only(bottom: 5),
                                          child: Icon(Icons.download),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(left: 2),
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 14),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: const Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text("Invoice From"),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text("Smarters Company"),
                                                SizedBox(
                                                  width: double.maxFinite,
                                                  child: Text(
                                                    "D 185, Phase 8B, \nIndustrial Area, Mohali, Punjab, India",
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 14),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: const Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text("Invoice To"),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text("Smarters Company"),
                                                SizedBox(
                                                  width: double.maxFinite,
                                                  child: Text(
                                                    "D 185, Phase 8B, \nIndustrial Area, Mohali, Punjab, India",
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ))
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 2),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 14),
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 2),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: [
                                            const Text("Items"),
                                            SizedBox(
                                              width: 100,
                                              child: Divider(
                                                color: Colors.blue[300],
                                              ),
                                            )
                                          ],
                                        ),
                                        const Spacer(),
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 5),
                                          child: Text(
                                            invoice['status'] == 1 ? 'Unpaid' : 'Paid',
                                            style: TextStyle(
                                                color: invoice['status'] == 1
                                                    ? Colors.red
                                                    : Colors.green),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4, right: 1),
                                    child: ListView.separated(
                                      physics: const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      separatorBuilder: (context, index) {
                                        return const SizedBox(
                                          height: 15,
                                        );
                                      },
                                      itemCount: invoice['invoiceitems'].length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 14),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.only(left: 10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        '${invoice['invoiceitems'][index]['description']}'),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                        '${invoice['currency']['symbol']}'
                                                        '${'${invoice['invoiceitems'][index]['amount']} ' + invoice['currency']['code']}'),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                height: 20,
                                                width: 20,
                                                margin: const EdgeInsets.only(
                                                    top: 7, bottom: 10),
                                                decoration: BoxDecoration(
                                                    color: Colors.grey[200],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    border: Border.all(
                                                        color: Colors.red,
                                                        width: 1)),
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //payment method
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 2),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 14),
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 2),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: [
                                            const Text("Payment Method"),
                                            SizedBox(
                                              width: 100,
                                              child: Divider(
                                                color: Colors.blue[300],
                                              ),
                                            )
                                          ],
                                        ),
                                        const Spacer(),
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 5),
                                          child: Text(
                                            '${invoice['paymentmethod']}',
                                            style:
                                                const TextStyle(color: Colors.green),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  //transaction lists
                                  Container(
                                    margin: const EdgeInsets.only(left: 2),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 14),
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 4, right: 1),
                                            child: ListView.separated(
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              separatorBuilder:
                                                  (context, index) {
                                                return const SizedBox(
                                                  height: 15,
                                                );
                                              },
                                              itemCount: invoice['transactions']
                                                  .length,
                                              itemBuilder: (context, index) {
                                                return Container(
                                                  padding: const EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                      vertical: 14),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                                left: 10),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                                '${invoice['transactions'][index]['created_at']}'),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            Text(
                                                                '${invoice['currency']['symbol']}'
                                                                '${'${invoice['transactions'][index]['amount']} ' + invoice['currency']['code']}'),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        height: 20,
                                                        width: 20,
                                                        margin: const EdgeInsets.only(
                                                            top: 7, bottom: 10),
                                                        decoration: BoxDecoration(
                                                            color: Colors
                                                                .grey[200],
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            border: Border.all(
                                                                color: Colors
                                                                    .green,
                                                                width: 1)),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ]),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
              ))
            ],
          ),
        ),
        bottomNavigationBar: const BottomBarButtons(),
        floatingActionButton: const FloatingButton(),
      ),
    );
  }
}
