import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart';
import '../common/SmarterDialog.dart';
import 'dart:async';
import '../Auth/Login.dart';
import '../constants.dart';
import '../widgets/bottombar.dart';
import '../widgets/floatingbutton.dart';
import '../widgets/appbar.dart';
import '../common/SidebarDrawer.dart';
import 'package:file_picker/file_picker.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  dynamic profiledata;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final _formKey = GlobalKey<FormState>();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  //default pick
  String clientpic = 'assets/images/avatar1.png';
  String clientpic1 = '';

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

  void pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
        allowMultiple: false,
      );
      if (result != null) {
        File? file = result.files.single.path != null
            ? File(result.files.single.path!)
            : null;
        // print(file);
        // upload file to server
        //show loading
        SmarterDialog.show(context, "Loading", "Please wait...");
        var req = MultipartRequest(
            'POST',
            Uri.parse(
                '${ApiConstants.baseUrl}/client-v1/updateppimage/${profiledata['id']}'));
        req.headers['Authorization'] = 'Bearer $token';
        req.files.add(MultipartFile.fromBytes('file', file!.readAsBytesSync(),
            filename: file.path.split('/').last));
        var response = await req.send();
        // print("respone data");
        // print(response.statusCode);
        if (response.statusCode == 200) {
          // hide loading
          SmarterDialog.hide(context);
          var data = jsonDecode(await response.stream.bytesToString());
          print(data);
          if (data['success'] == true) {
            setState(() {
              clientpic1 = data['message'];
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile image updated successfully.'),
              ),
            );
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
      } else {
        SmarterDialog.hide(context);
        // User canceled the picker
      }
    } on Exception catch (e) {
      print(e.toString());
    } catch (e) {
      print(e.toString());
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> getData(token) async {
    try {
      //get data from api
      Response response = await get(
          Uri.parse('${ApiConstants.baseUrl}/client-v1/me'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          });
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print(data['userdata']);
        if (data['success'] == true) {
          setState(() {
            profiledata = data['userdata'];
            _firstnameController.text = profiledata['firstname'];
            _lastnameController.text = profiledata['lastname'];
            _emailController.text = profiledata['email'];
            _phoneController.text = profiledata['phonenumber'];
            _addressController.text = profiledata['address'];
            clientpic1 = profiledata['avatar'];
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

  //update profile
  Future<void> updateProfile(token, profiledata) async {
    try {
      SmarterDialog.show(context, "Loading", "Please wait...");
      Response response = await post(
          Uri.parse(
              '${ApiConstants.baseUrl}/client-v1/update/${profiledata['id']}'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(profiledata));
      if (response.statusCode == 200) {
        SmarterDialog.hide(context);
        var data = jsonDecode(response.body.toString());
        print(data);
        if (data['success'] == true) {
          setState(() {
            profiledata = data['user'];
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully.'),
            ),
          );
        } else {
          if (data['message'] == 'Unauthenticated.') {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.remove('token');
            setState(() {
              loginError = 'Unauthenticated';
            });
          }
        }
      } else {
        print(response.body.toString());
        SmarterDialog.hide(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Something went wrong!'),
          ),
        );
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
        drawer: const SidebarDrawer(),
        body: Form(
          key: _formKey,
          child: SizedBox(
              width: double.maxFinite,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 5),
                        padding: const EdgeInsets.symmetric(horizontal: 21),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    spreadRadius: 0,
                                    blurRadius: 20, // Increased blur radius
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Card(
                                clipBehavior: Clip.antiAlias,
                                elevation: 0,
                                margin: const EdgeInsets.all(0),
                                // color: Colors.grey[100],
                                shape: RoundedRectangleBorder(
                                  // side: const BorderSide(
                                  //     color: Colors.red, width: 2),
                                  borderRadius: BorderRadius.circular(2.0),
                                ),
                                child: InkWell(
                                  onTap: pickFile,
                                  child: Container(
                                    height: 120,
                                    width: 130,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      image: clientpic1 == ''
                                          ? DecorationImage(
                                              image: AssetImage(clientpic),
                                              fit: BoxFit.cover)
                                          : DecorationImage(
                                              image: NetworkImage(clientpic1),
                                              fit: BoxFit.cover),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xffcdcdf2)
                                              .withOpacity(0.5),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: const Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    // child: const Stack(
                                    //   alignment: Alignment.bottomRight,
                                    //   children: [Text("Profile Image Here")],
                                    // ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(left: 2),
                                    child: Text("First Name"),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xffcdcdf2)
                                              .withOpacity(0.5),
                                          spreadRadius: 10,
                                          blurRadius: 30,
                                          offset: const Offset(0, 20),
                                        ),
                                      ],
                                    ),
                                    child: TextFormField(
                                      controller: _firstnameController,
                                      decoration: const InputDecoration(
                                          hintText: "First Name",
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xffcdcdf2)),
                                          ),
                                          border: OutlineInputBorder(),
                                          prefixIcon: Icon(Icons.man_2)),
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 20,
                                  ),
                                  // last name field
                                  const Padding(
                                    padding: EdgeInsets.only(left: 2),
                                    child: Text("Last Name"),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xffcdcdf2)
                                              .withOpacity(0.5),
                                          spreadRadius: 10,
                                          blurRadius: 30,
                                          offset: const Offset(0, 20),
                                        ),
                                      ],
                                    ),
                                    child: TextFormField(
                                      controller: _lastnameController,
                                      decoration: const InputDecoration(
                                          hintText: "Last Name",
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xffcdcdf2)),
                                          ),
                                          border: OutlineInputBorder(),
                                          prefixIcon: Icon(Icons.man_2)),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  // email field
                                  const Padding(
                                    padding: EdgeInsets.only(left: 2),
                                    child: Text("Email"),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xffcdcdf2)
                                              .withOpacity(0.5),
                                          spreadRadius: 10,
                                          blurRadius: 30,
                                          offset: const Offset(0, 20),
                                        ),
                                      ],
                                    ),
                                    child: TextFormField(
                                      controller: _emailController,
                                      decoration: const InputDecoration(
                                          hintText: "Your Email",
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xffcdcdf2)),
                                          ),
                                          border: OutlineInputBorder(),
                                          prefixIcon: Icon(Icons.email)),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  // phone field
                                  const Padding(
                                    padding: EdgeInsets.only(left: 2),
                                    child: Text("Phone"),
                                  ),

                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xffcdcdf2)
                                              .withOpacity(0.5),
                                          spreadRadius: 10,
                                          blurRadius: 30,
                                          offset: const Offset(0, 20),
                                        ),
                                      ],
                                    ),
                                    child: TextFormField(
                                      controller: _phoneController,
                                      decoration: const InputDecoration(
                                          hintText: "Your Phone",
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xffcdcdf2)),
                                          ),
                                          border: OutlineInputBorder(),
                                          prefixIcon: Icon(Icons.phone)),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),

                                  const Padding(
                                    padding: EdgeInsets.only(left: 2),
                                    child: Text("Address"),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  // address field
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xffcdcdf2)
                                              .withOpacity(0.5),
                                          spreadRadius: 10,
                                          blurRadius: 30,
                                          offset: const Offset(0, 20),
                                        ),
                                      ],
                                    ),
                                    child: TextFormField(
                                      controller: _addressController,
                                      decoration: const InputDecoration(
                                          hintText: "Your Address",
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xffcdcdf2)),
                                          ),
                                          border: OutlineInputBorder(),
                                          prefixIcon: Icon(Icons.location_on)),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),

                                  // submit button
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 10, 20, 10),
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          profiledata = {
                                            'id': profiledata['id'],
                                            'firstname':
                                                _firstnameController.text,
                                            'lastname':
                                                _lastnameController.text,
                                            'email': _emailController.text,
                                            'phonenumber':
                                                _phoneController.text,
                                            'address': _addressController.text,
                                          };
                                          updateProfile(token, profiledata);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(2),
                                          ),
                                          backgroundColor:
                                              const Color(0xff2723d8),
                                          foregroundColor: Colors.white,
                                          textStyle:
                                              const TextStyle(fontSize: 20),
                                          padding: const EdgeInsets.fromLTRB(
                                              20, 10, 20, 10),
                                        ),
                                        child: const Text("Update Profile"),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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
