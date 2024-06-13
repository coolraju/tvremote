import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'dart:async';
import '../constants.dart';
import 'Tickets.dart';
import '../widgets/bottombar.dart';
import '../widgets/floatingbutton.dart';
import '../widgets/appbar.dart';
import '../common/SidebarDrawer.dart';

class TicketAdd extends StatefulWidget {
  const TicketAdd({super.key});

  @override
  _TicketAddState createState() => _TicketAddState();
}

class _TicketAddState extends State<TicketAdd> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String token = '';
  @override
  void initState() {
    super.initState();
    _prefs.then((SharedPreferences prefs) {
      setState(() {
        token = prefs.getString('token') ?? '';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        appBar: const AppBarButton(title: 'Ticket Details'),
        drawer: const SidebarDrawer(),
        body: SingleChildScrollView(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Form(
            key: _formKey,
            child: SizedBox(
              width: double.maxFinite,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text("Subject", style: TextStyle(fontSize: 20)),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: TextFormField(
                      controller: _subjectController,
                      decoration: InputDecoration(
                        hintText: 'Enter subject',
                        contentPadding: const EdgeInsets.all(10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Icon(Icons.subject),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter subject';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text("Message", style: TextStyle(fontSize: 20)),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: TextFormField(
                      controller: _messageController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Enter message',
                        contentPadding: const EdgeInsets.all(10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter message';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  //department dropdowns
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        hintText: 'Select Department',
                        contentPadding: const EdgeInsets.all(10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Icon(Icons.subject),
                        ),
                      ),
                      items: <String>[
                        'General',
                        'Sales',
                        'Support',
                        'Billing',
                        'Technical',
                        'Other'
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        print(value);
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  //priority dropdowns
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        hintText: 'Select Priority',
                        contentPadding: const EdgeInsets.all(10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Icon(Icons.priority_high),
                        ),
                      ),
                      items: <String>['Low', 'Medium', 'High', 'Urgent']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        print(value);
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  //services dropdown
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        hintText: 'Select Service',
                        contentPadding: const EdgeInsets.all(10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Icon(Icons.settings),
                        ),
                      ),
                      items: <String>[
                        'General',
                        'Sales',
                        'Support',
                        'Billing',
                        'Technical',
                        'Other'
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        print(value);
                      },
                    ),
                  ),
                  //attachment
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: () {},
                      icon: const Icon(Icons.attach_file),
                      label: const Text('Attach File'),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  //submit button
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(fontSize: 20),
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final Map<String, dynamic> data = {
                              'subject': _subjectController.text,
                              'message': _messageController.text,
                            };
                            final Response response = await post(
                              Uri.parse(
                                  '${ApiConstants.baseUrl}/client-v1/tickets/add'),
                              headers: <String, String>{
                                'Content-Type':
                                    'application/json; charset=UTF-8',
                                'Authorization': 'Bearer $token',
                              },
                              body: jsonEncode(data),
                            );
                            print(response.body);
                            if (response.statusCode == 200) {
                              //parse json
                              var jsondata = jsonDecode(response.body);
                              if (jsondata['success'] == false) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('Error: ${jsondata['message']}'),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('Success: ${jsondata['message']}'),
                                  ),
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Tickets(),
                                  ),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Error: ${jsonDecode(response.body)['message']}'),
                                ),
                              );
                            }
                          }
                        },
                        child: const Text('Submit'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: const BottomBarButtons(),
        floatingActionButton: const FloatingButton(),
      ),
    );
  }
}
