import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'dart:async';
import '../Auth/Login.dart';
import 'Invoice.dart';
import '../constants.dart';
import 'Service.dart';
import '../widgets/bottombar.dart';
import '../widgets/floatingbutton.dart';
import '../widgets/appbar.dart';

//order details page

class Order extends StatefulWidget {
  final dynamic id;

  const Order({super.key, required this.id});

  @override
  _OrderState createState() => _OrderState();
}

class _OrderState extends State<Order> {
  dynamic order;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String token = '';
  String loginError = '';
  @override
  void initState() {
    super.initState();
    _prefs.then((SharedPreferences prefs) {
      setState(() {
        token = prefs.getString('token') ?? '';
      });
      getData(token).then((value) {
        if (loginError == 'Unauthenticated') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        }
      });
    });
  }

  Future<void> getData(token) async {
    try {
      //get data from api
      Response response = await get(
          Uri.parse(
              '${ApiConstants.baseUrl}/client-v1/order/edit/${widget.id}'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          });
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print(data);
        if (data['success'] == true) {
          setState(() {
            order = data['order'];
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
        appBar: const AppBarButton(title: 'Order Details'),
        // drawer: const SidebarDrawer(),
        body: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 9,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 11,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: order == null
                      ? const CircularProgressIndicator()
                      : order.length == 0
                          ? const Text('No data found')
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          'Order',
                                          style: TextStyle(
                                            // color: Colors.grey,
                                            fontSize: 20,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 60,
                                          child: Divider(color: Colors.blue),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Order Number:'),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Text(order['order_number']),
                                    ),
                                  ],
                                ),
                                // order date row
                                const SizedBox(
                                  height: 10,
                                ),
                                const Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Order Date:'),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Text(order['created_at']),
                                    ),
                                  ],
                                ),
                                // order status row
                                const SizedBox(
                                  height: 10,
                                ),
                                const Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Order Status:'),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Text(order['status']),
                                    ),
                                  ],
                                ),
                                // order total row
                                const SizedBox(
                                  height: 10,
                                ),
                                const Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Order Total:'),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Text(
                                          '${order['users']['currency']['symbol'] + order['total'].toString() + ' ' + order['users']['currency']['code']}'),
                                    ),
                                  ],
                                ),
                                // order payment status row
                                const SizedBox(
                                  height: 10,
                                ),
                                const Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Payment Method:'),
                                    Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Text(
                                            '${order['paymentmethods'] == null ? 'Credit' : order['paymentmethods']['name']}')),
                                  ],
                                ),
                                // order status
                                const SizedBox(
                                  height: 10,
                                ),
                                const Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Order Status:'),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Text(order['status']),
                                    ),
                                  ],
                                ),
                                // order actions
                                const SizedBox(
                                  height: 10,
                                ),
                                const Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Expanded(child: Text(' Invoice : ')),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: InkWell(
                                        child: order['invoice_id'] == null
                                            ? const Text('No invoice')
                                            : Text(
                                                'Invoice #${order['invoice_id']}',
                                                style: const TextStyle(
                                                    color: Colors.blue)),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Invoice(
                                                    id: order['invoice_id'])),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                // services
                                const SizedBox(
                                  height: 10,
                                ),
                                const Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Expanded(child: Text(' Services : ')),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Column(
                                        children: List.generate(
                                            order['services'].length, (index) {
                                          return InkWell(
                                            child: Text(
                                                order['services'][index]
                                                    ['products']['title'],
                                                style: const TextStyle(
                                                    color: Colors.blue)),
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Service(
                                                            id: order[
                                                                    'services']
                                                                [index]['id'])),
                                              );
                                            },
                                          );
                                        }),
                                      ),
                                    ),
                                  ],
                                ),
                                // back to orders page
                                const SizedBox(
                                  height: 20,
                                ),
                                const Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Back'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: const BottomBarButtons(),
        floatingActionButton: const FloatingButton(),
      ),
    );
  }
}
