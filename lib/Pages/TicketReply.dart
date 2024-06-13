import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'dart:async';
import '../Auth/Login.dart';
import '../constants.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import '../widgets/bottombar.dart';
import '../widgets/floatingbutton.dart';
import '../widgets/appbar.dart';
import 'Tickets.dart';
import 'package:file_picker/file_picker.dart';

class TicketReply extends StatefulWidget {
  final int id;

  const TicketReply({super.key, required this.id});

  @override
  _TicketReplyState createState() => _TicketReplyState();
}

class _TicketReplyState extends State<TicketReply> {
  dynamic ticket;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final TextEditingController replymsgController = TextEditingController();
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

  Future replyTicket(token, id, message) async {
    try {
      //get data from api
      Response response = await post(
          Uri.parse('${ApiConstants.baseUrl}/client-v1/tickets/answer/$id'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'message': message,
          }));
      print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print(data);
        if (data['success'] == true) {
          setState(() {
            getData(token);
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

  Future closeTicket(token, id) async {
    try {
      //get data from api
      Response response = await post(
          Uri.parse('${ApiConstants.baseUrl}/client-v1/tickets/close/$id'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          });
      print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print(data);
        if (data['success'] == true) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const Tickets()));
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
    // Initial Selected Value
    String dropdownvalue = 'Item 1';
    ScrollController controller = ScrollController();

    // List of items in our dropdown menu
    var items = [
      'Item 1',
      'Item 2',
      'Item 3',
      'Item 4',
      'Item 5',
    ];
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        appBar: const AppBarButton(title: 'Ticket Reply'),
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
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: ticket == null
                        ? const CircularProgressIndicator()
                        : Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 17, vertical: 13),
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(5)),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 3),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Ticket #${ticket['id']}"),
                                              Text("Subject : " +
                                                  ticket['subject'])
                                            ],
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 3),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                ticket['status'] == 3
                                                    ? const Text(
                                                        "Closed",
                                                        style: TextStyle(
                                                            color: Colors.red),
                                                      )
                                                    : InkWell(
                                                        onTap: () {
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                  title: const Text(
                                                                      "Close Ticket"),
                                                                  content:
                                                                      const Text(
                                                                          "Are you sure you want to close this ticket?"),
                                                                  actions: [
                                                                    TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child: const Text(
                                                                            "No")),
                                                                    TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                          closeTicket(
                                                                              token,
                                                                              widget.id);
                                                                        },
                                                                        child: const Text(
                                                                            "Yes")),
                                                                  ],
                                                                );
                                                              });
                                                        },
                                                        child: const Text(
                                                          "Close Ticket",
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              decoration:
                                                                  TextDecoration
                                                                      .underline),
                                                        ),
                                                      ),
                                                const SizedBox(height: 3),
                                                Text(ticket['created_at'])
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Divider(),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    HtmlWidget(ticket['message']),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 2),
                                      child: ListView.separated(
                                        controller: controller,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        separatorBuilder: (context, index) {
                                          return const SizedBox(height: 10);
                                        },
                                        itemCount: ticket['replies'].length,
                                        itemBuilder: (context, index) {
                                          // print(ticket['replies']);
                                          var createdby = '';
                                          var createdgroup = '';
                                          var whoreply = '';

                                          if (ticket['replies'][index]
                                                  ['user_id'] ==
                                              0) {
                                            createdby = ticket['replies'][index]
                                                        ['adminuser'] !=
                                                    null
                                                ? ticket['replies'][index]
                                                    ['adminuser']['name']
                                                : 'Support';
                                            whoreply = 'admin';
                                          } else {
                                            createdby =
                                                ticket['user']['firstname'];
                                            whoreply = 'user';
                                          }
                                          return Container(
                                            padding: const EdgeInsets.all(13),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  height: 30,
                                                  width: 30,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 4,
                                                      vertical: 1),
                                                  decoration: BoxDecoration(
                                                    color: Colors.green,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                  ),
                                                  child:
                                                      const Icon(Icons.person),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Text(createdby,
                                                          style:
                                                              const TextStyle(
                                                                  // bold
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      15)),
                                                      const SizedBox(
                                                        height: 2,
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.6,
                                                        child: HtmlWidget(
                                                            ticket['replies']
                                                                    [index]
                                                                ['message']),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(right: 1),
                                                        child: Text(
                                                            ticket['replies']
                                                                    [index]
                                                                ['created_at'],
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .grey)),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    // message text area
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(right: 2),
                                      decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: TextField(
                                        maxLines: 4,
                                        controller: replymsgController,
                                        keyboardType: TextInputType.multiline,
                                        decoration: const InputDecoration(
                                          hintText: 'Type your message here',
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ),
                                    //dropdown departments and priority
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(left: 1),
                                      padding: const EdgeInsets.only(right: 2),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(left: 3),
                                            child: Text("Department"),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 1),
                                            child: DropdownButtonFormField(
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                              ),
                                              // Initial Value
                                              value: dropdownvalue,

                                              // Down Arrow Icon
                                              icon: const Icon(
                                                  Icons.keyboard_arrow_down),

                                              // Array list of items
                                              items: items.map((String items) {
                                                return DropdownMenuItem(
                                                  value: items,
                                                  child: Text(items),
                                                );
                                              }).toList(),
                                              // After selecting the desired option,it will
                                              // change button value to selected value
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  dropdownvalue = newValue!;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(left: 1),
                                      padding: const EdgeInsets.only(right: 2),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(left: 3),
                                            child: Text("Priority"),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 1),
                                            child: DropdownButtonFormField(
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                              ),
                                              // Initial Value
                                              value: dropdownvalue,

                                              // Down Arrow Icon
                                              icon: const Icon(
                                                  Icons.keyboard_arrow_down),

                                              // Array list of items
                                              items: items.map((String items) {
                                                return DropdownMenuItem(
                                                  value: items,
                                                  child: Text(items),
                                                );
                                              }).toList(),
                                              // After selecting the desired option,it will
                                              // change button value to selected value
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  dropdownvalue = newValue!;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(left: 1),
                                      padding: const EdgeInsets.only(right: 2),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(left: 3),
                                            child: Text("Service"),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 1),
                                            child: DropdownButtonFormField(
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                              ),
                                              // Initial Value
                                              value: dropdownvalue,

                                              // Down Arrow Icon
                                              icon: const Icon(
                                                  Icons.keyboard_arrow_down),

                                              // Array list of items
                                              items: items.map((String items) {
                                                return DropdownMenuItem(
                                                  value: items,
                                                  child: Text(items),
                                                );
                                              }).toList(),
                                              // After selecting the desired option,it will
                                              // change button value to selected value
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  dropdownvalue = newValue!;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    //file type field for attachment
                                    Container(
                                      margin: const EdgeInsets.only(left: 1),
                                      padding: const EdgeInsets.only(right: 2),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(left: 3),
                                            child: Text("Service"),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 1),
                                            child: ElevatedButton(
                                                onPressed: () async {
                                                  try {
                                                    FilePickerResult? result =
                                                        await FilePicker
                                                            .platform
                                                            .pickFiles();

                                                    if (result != null) {
                                                      PlatformFile file =
                                                          result.files.first;
                                                      print(file.name);
                                                      print(file.bytes);
                                                      print(file.size);
                                                      print(file.extension);
                                                      print(file.path);
                                                    } else {
                                                      // User canceled the picker
                                                    }
                                                  } on PlatformException catch (e) {
                                                    print(
                                                        'Unsupported operation$e');
                                                  } catch (e) {
                                                    print(e.toString());
                                                  }
                                                },
                                                child:
                                                    const Text("Attachment")),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // cancel and submit button in a row
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: ElevatedButton(
                                                onPressed: () {
                                                  //clear form
                                                  replymsgController.clear();
                                                },
                                                child: const Text("Cancel"))),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.blue,
                                                  foregroundColor: Colors.white,
                                                  textStyle: const TextStyle(
                                                      fontSize: 20),
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          20, 10, 20, 10),
                                                ),
                                                onPressed: () {
                                                  replyTicket(token, widget.id,
                                                      replymsgController.text);
                                                },
                                                child: const Text("Submit")))
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                  ),
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: const BottomBarButtons(),
        floatingActionButton: const FloatingButton(),
      ),
    );
  }
}
