import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart';
import '../widgets/bottombar.dart';
import '../widgets/floatingbutton.dart';
import '../widgets/appbar.dart';
import '../common/SidebarDrawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import '../common/SmarterDialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class Download extends StatefulWidget {
  final String slug;
  const Download({super.key, required this.slug});
  @override
  _DownloadState createState() => _DownloadState();
}

class _DownloadState extends State<Download> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String token = '';
  List<dynamic> downloads = [];
  @override
  void initState() {
    super.initState();
    _prefs.then((SharedPreferences prefs) {
      setState(() {
        token = prefs.getString('token') ?? '';
        SmarterDialog.show(context, "Loading", "Please wait...");
        getDownload(token).then((value) {
          SmarterDialog.hide(context);
        });
      });
    });
  }

  Future getDownload(token) async {
    try {
      Response response = await get(
        Uri.parse(
            '${ApiConstants.baseUrl}/client-v1/downloads/category/${widget.slug}'),
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
            downloads.addAll(data['downloads']);
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future downloadFile(token, id, name) async {
    try {
      print('${ApiConstants.baseUrl}/client-v1/download/getfile/$id');
      Response response = await get(
        Uri.parse('${ApiConstants.baseUrl}/client-v1/download/$id'),
        headers: <String, String>{
          // 'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );
      print(response.body.toString());
      if (response.statusCode == 200) {
        //blob type download
        var data = response.bodyBytes;
        // print(data);
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = tempDir.path;
        File file = File('$tempPath/$name');
        await file.writeAsBytes(data);
        print(tempPath);
        //open file
        OpenFile.open(file.path);
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
        appBar: const AppBarButton(title: 'Download Details'),
        drawer: const SidebarDrawer(),
        body: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.only(top: 20),
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: downloads.length,
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(
                    height: 10,
                  );
                },
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(
                      downloads[index]['title'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      downloads[index]['description'],
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.download),
                      onPressed: () {
                        downloadFile(token, downloads[index]['downloadid'],
                            downloads[index]['title']);
                      },
                    ),
                  );
                },
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
