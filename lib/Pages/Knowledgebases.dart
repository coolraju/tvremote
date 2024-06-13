import 'package:flutter/material.dart';
import '../widgets/bottombar.dart';
import '../widgets/floatingbutton.dart';
import '../widgets/appbar.dart';
import '../common/SidebarDrawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart';
import '../constants.dart';
import 'Knowledgebase.dart';
import '../common/SmarterDialog.dart';

class Knowledgebases extends StatefulWidget {
  const Knowledgebases({super.key});

  @override
  _KnowledgebasesState createState() => _KnowledgebasesState();
}

class _KnowledgebasesState extends State<Knowledgebases> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String token = '';
  List<dynamic> knowledgebases = [];
  @override
  void initState() {
    super.initState();
    _prefs.then((SharedPreferences prefs) {
      setState(() {
        token = prefs.getString('token') ?? '';
        SmarterDialog.show(context, "Loading", "Please wait...");
        getKnowledgebase(token).then((value) {
          SmarterDialog.hide(context);
        });
      });
    });
  }

  //get knowledgebase data
  Future getKnowledgebase(token) async {
    try {
      Response response = await get(
        Uri.parse('${ApiConstants.baseUrl}/client-v1/knowledgebase'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print(data);
        if (data['success'] == true) {
          setState(() {
            knowledgebases.addAll(data['knowledgebase']);
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        appBar: const AppBarButton(title: 'Knowledgebase'),
        drawer: const SidebarDrawer(),
        body: Container(
            width: double.maxFinite,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 138, 197, 226),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Knowledgebase",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Padding(
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
                      ],
                    ),
                  ),
                ),
                // content here
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.separated(
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 16,
                      );
                    },
                    itemCount: knowledgebases.length,
                    itemBuilder: (context, index) {
                      // print(knowledgebases[index]);
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Knowledgebase(
                                  kdesc: knowledgebases[index]['description'],
                                  ktitle: knowledgebases[index]['title'],
                                  kart: knowledgebases[index]['articles']),
                            ),
                          );
                        },
                        child: Column(children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(5)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, top: 15, bottom: 8),
                                  child: Text(knowledgebases[index]['title']),
                                ),
                                const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15, bottom: 15),
                                  child: Text(
                                    knowledgebases[index]['created_at'],
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(5)),
                            child: Padding(
                                padding: const EdgeInsets.all(0),
                                child:
                                    Text(knowledgebases[index]['description'])),
                          )
                        ]),
                      );
                    },
                  ),
                ),
              ],
            )),
        bottomNavigationBar: const BottomBarButtons(),
        floatingActionButton: const FloatingButton(),
      ),
    );
  }
}
