import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import '../widgets/bottombar.dart';
import '../widgets/floatingbutton.dart';
import '../widgets/appbar.dart';

class Annoucement extends StatefulWidget {
  final String slug;

  const Annoucement({super.key, required this.slug});

  @override
  _AnnoucementState createState() => _AnnoucementState();
}

class _AnnoucementState extends State<Annoucement> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String token = '';
  //singe announcement
  dynamic announcement;

  @override
  void initState() {
    super.initState();
    _prefs.then((SharedPreferences prefs) {
      setState(() {
        token = prefs.getString('token') ?? '';
      });
      getData(token).then((value) {});
    });
  }

  Future<void> getData(String token) async {
    Response response = await get(
        Uri.parse(
            '${ApiConstants.baseUrl}/client-v1/announcement/${widget.slug}/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        });
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());
      print(data['announcement']);
      if (data['success'] == true) {
        setState(() {
          announcement = data['announcement'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        appBar: const AppBarButton(title: 'Annoucement Details'),
        body: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(5)),
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 20),
                  announcement == null
                      ? const CircularProgressIndicator()
                      : Column(
                          children: [
                            Text(
                              announcement['title'],
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              child: HtmlWidget(
                                announcement['description'],
                              ),
                            ),
                            Text(
                              announcement['created_at'],
                              style: const TextStyle(fontSize: 15),
                            ),

                            const SizedBox(
                              height: 20,
                            ),
                            // back button
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Back'),
                            )
                          ],
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
