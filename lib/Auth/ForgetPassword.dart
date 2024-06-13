import 'dart:async';

import 'package:flutter/material.dart';
import 'Login.dart';
import '../common/SmarterDialog.dart';
import 'package:http/http.dart';
import 'dart:convert';
import '../constants.dart';

//forget password page with form
class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // appBar: AppBar(
        //   title: Text('Forget Password'),
        // ),
        body: Center(
          child: ForgetPasswordForm(),
        ),
      ),
    );
  }
}

//forget password form
class ForgetPasswordForm extends StatefulWidget {
  const ForgetPasswordForm({super.key});

  @override
  _ForgetPasswordFormState createState() => _ForgetPasswordFormState();
}

class _ForgetPasswordFormState extends State<ForgetPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const Image(
                image: AssetImage('assets/images/logo.png'),
                width: 200,
                height: 200,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
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
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffcdcdf2)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter email';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                      backgroundColor: const Color(0xff2723d8),
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(fontSize: 20),
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        SmarterDialog.show(
                            context, "Loading", "Please wait...");
                        forgetPasswordRequest(_emailController.text)
                            .then((value) {
                          SmarterDialog.hide(context);
                          if (value == true) {
                            Timer(const Duration(seconds: 3), () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()),
                              );
                            });
                          }
                        });
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: const Text('Back to Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //forget password api request
  Future<bool> forgetPasswordRequest(email) async {
    try {
      Response response = await post(
        Uri.parse('${ApiConstants.baseUrl}/client-v1/forgot-password'),
        body: jsonEncode({'email': email}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
      );
      print(response.body.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        if (data['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Email sent successfully to reset password.'),
            ),
          );
          return true;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data['message']),
            ),
          );
          return false;
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Something went wrong')),
        );
        return false;
      }
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
      return false;
    }
  }
}
