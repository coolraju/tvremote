import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../constants.dart';
import '../widgets/bottombar.dart';
import '../widgets/floatingbutton.dart';
import '../widgets/appbar.dart';
import '../common/SidebarDrawer.dart';
import '../common/SmarterDialog.dart';

class Contactus extends StatefulWidget {
  const Contactus({super.key});

  @override
  _ContactusState createState() => _ContactusState();
}

class _ContactusState extends State<Contactus> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  Future<void> sendContactUs(context) async {
    //send contact us
    try {
      //load contact us
      SmarterDialog.show(context, "Loading", "Please wait...");
      Response response = await post(
        Uri.parse('${ApiConstants.baseUrl}/client-v1/sendcontactusmail'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'fullname': nameController.text,
          'email': emailController.text,
          'message': messageController.text,
        }),
      );
      print(response.body);
      if (response.statusCode == 200) {
        SmarterDialog.hide(context);
        // If the server returns an OK response, then parse the JSON.
        var data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          //show success message
          // SmarterDialog.show(context, "Success", data['message']);
          //clear form
          nameController.clear();
          emailController.clear();
          messageController.clear();
        } else {
          //show error message
          // SmarterDialog.show(context, "Error", data['message']);
        }
      } else {
        SmarterDialog.hide(context);
        // If the server returns an error response, then throw an exception.
        SnackBar(content: Text('Failed to send contact us'));
      }
    } catch (e) {
      print(e);
      SnackBar(content: Text('Failed to send contact us'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        appBar: const AppBarButton(title: 'Contact Us'),
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
                    child: Text(
                      "Full Name",
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xffcdcdf2).withOpacity(0.5),
                            spreadRadius: 10,
                            blurRadius: 30,
                            offset: const Offset(0, 20),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: 'Enter your full name',
                          contentPadding: const EdgeInsets.all(10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffcdcdf2)),
                          ),
                          prefixIcon: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Icon(Icons.person),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your full name';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      "Email",
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xffcdcdf2).withOpacity(0.5),
                            spreadRadius: 10,
                            blurRadius: 30,
                            offset: const Offset(0, 20),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: 'Enter your email',
                          contentPadding: const EdgeInsets.all(10),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffcdcdf2)),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          prefixIcon: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Icon(Icons.email),
                          ),
                        ),
                        validator: (value) => value!.isEmpty
                            ? 'Please enter your email'
                            : !RegExp(r'\S+@\S+\.\S+').hasMatch(value)
                                ? 'Enter a valid email'
                                : null,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      "Message",
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xffcdcdf2).withOpacity(0.5),
                            spreadRadius: 10,
                            blurRadius: 30,
                            offset: const Offset(0, 20),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: messageController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: 'Enter your message',
                          contentPadding: const EdgeInsets.all(10),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffcdcdf2)),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          // prefixIcon: const Padding(
                          //   padding: EdgeInsets.all(10),
                          //   child: Icon(Icons.message),
                          // ),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter your message' : null,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: ElevatedButton(
                        onPressed: () {
                          //validate form
                          if (_formKey.currentState!.validate()) {
                            var newcontext = context;
                            sendContactUs(newcontext);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[900],
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          textStyle: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        child: const Text('Submit',
                            style: TextStyle(color: Colors.white)),
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
