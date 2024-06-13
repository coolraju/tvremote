import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import '../widgets/bottombar.dart';
import '../widgets/floatingbutton.dart';
import '../widgets/appbar.dart';

class Knowledgebase extends StatefulWidget {
  final String ktitle;
  final String kdesc;
  final List kart;

  const Knowledgebase(
      {super.key,
      required this.ktitle,
      required this.kart,
      required this.kdesc});

  @override
  _KnowledgebasetState createState() => _KnowledgebasetState();
}

class _KnowledgebasetState extends State<Knowledgebase> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String token = '';
  //singe announcement
  dynamic knowledgebase;

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
        appBar: const AppBarButton(title: 'Knowledgebase Details'),
        body: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
              child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(5)),
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 10),
                    widget.ktitle == null
                        ? const CircularProgressIndicator()
                        : Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                widget.ktitle,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              //list view of articles
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: widget.kart.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        widget.kart[index]['title'],
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      HtmlWidget(
                                          widget.kart[index]['description']),
                                    ],
                                  );
                                },
                              ),
                              // back button
                              // ElevatedButton(
                              //   onPressed: () {
                              //     Navigator.pop(context);
                              //   },
                              //   child: const Text('Back'),
                              // )
                            ],
                          ),
                  ],
                ),
              ),
            ],
          )),
        ),
        bottomNavigationBar: const BottomBarButtons(),
        floatingActionButton: const FloatingButton(),
      ),
    );
  }
}
