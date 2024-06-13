import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'dart:async';
import '../Auth/Login.dart';
import 'TicketReply.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../constants.dart';
import 'Tickets.dart';
import '../widgets/bottombar.dart';
import '../widgets/floatingbutton.dart';
import '../widgets/appbar.dart';

class Ticket extends StatefulWidget {
  final dynamic id;

  const Ticket({super.key, required this.id});

  @override
  _TicketState createState() => _TicketState();
}

class _TicketState extends State<Ticket> {
  dynamic ticket;
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
          Uri.parse('${ApiConstants.baseUrl}/client-v1/tickets/${widget.id}'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          });
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print(data);
        if (data['success'] == true) {
          setState(() {
            ticket = data['ticket'];
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
        appBar: const AppBarButton(title: 'Ticket Details'),
        // drawer: const SidebarDrawer(),
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              ticket == null
                  ? const CircularProgressIndicator()
                  : Column(
                      children: [
                        const SizedBox(height: 20),
                        Card(
                          child: ListTile(
                            title: Text(
                                "${'# ' + ticket['id'].toString() + " (" + ticket['priority']}) - " +
                                    ticket['department']['name']),
                            subtitle: Text(
                                "Subject : ${ticket['subject']}, At : " +
                                    ticket['created_at']),
                          ),
                        ),
                        Card(
                          child: ListTile(
                            title: HtmlWidget('Message : ' + ticket['message']),
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        TicketReply(id: ticket['id'])),
                              );
                            },
                            child: const Text('Reply')),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Tickets()),
                              );
                            },
                            child: const Text('Back to Tickets')),
                      ],
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
