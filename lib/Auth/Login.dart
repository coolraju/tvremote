import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:vpnpanel/Auth/Signup.dart';
import 'ForgetPassword.dart';
import '../Dashboard.dart';
import 'dart:convert';
import '../common/SmarterDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';

//login page with form
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        //hide appbar
        body: Center(
          child: LoginForm(),
        ),
      ),
    );
  }
}

//login form
class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    // print('initState');
    //check if user is logged in
    _prefs.then((SharedPreferences prefs) {
      String token = prefs.getString('token') ?? '';
      if (token == '') {
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const Dashboard()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        // appBar:null,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const Image(
                image: AssetImage('assets/images/logo.png'),
                width: 200,
                height: 200,
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // label
                    const Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Text(
                        'Email',
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.left,
                      ),
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
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            labelText: 'Username',
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffcdcdf2)),
                            ),
                            prefixIcon: Icon(Icons.email, color: Colors.grey),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter username';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Text(
                        'Password',
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.left,
                      ),
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
                          controller: _passwordController,
                          obscureText: !isPasswordVisible,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: const OutlineInputBorder(),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffcdcdf2)),
                            ),
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Colors.grey,
                            ),
                            suffixIcon: IconButton(
                              color: Colors.grey,
                              icon: Icon(isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  isPasswordVisible = !isPasswordVisible;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter password';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: true,
                                    onChanged: (bool? value) {},
                                  ),
                                  const Text('Remember me'),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ForgetPassword()),
                                );
                              },
                              child: const Text('Forgot Password?'),
                            ),
                          ]),
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
                              // print("username: ${_usernameController.text}");
                              //show loading till response is received
                              var newcontext = context;
                              SmarterDialog.show(
                                  context, "Loading", "Please wait...");
                              //login successful
                              login(_usernameController.text,
                                      _passwordController.text)
                                  .then((value) {
                                //hide showLoaderDialog
                                SmarterDialog.hide(newcontext);
                                if (value) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const Dashboard()),
                                  );
                                } else {
                                  //hide showLoaderDialog
                                  // Navigator.pop(context);
                                  //login failed
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Login failed'),
                                    ),
                                  );
                                }
                              });
                            }
                          },
                          child: const Text('Login'),
                        ),
                      ),
                    ),
                    // const Padding(
                    //   padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    //   child: Center(
                    //       child: Text(
                    //     ' or continue with',
                    //     textAlign: TextAlign.center,
                    //     style: TextStyle(fontSize: 10),
                    //   )),
                    // ),
                    // apple login button
                    // Padding(
                    //   padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    //   child: SizedBox(
                    //     width: double.infinity,
                    //     child: ElevatedButton(
                    //       style: ElevatedButton.styleFrom(
                    //         textStyle: const TextStyle(fontSize: 20),
                    //         padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    //       ),
                    //       onPressed: () {
                    //         //login successful
                    //         // Navigator.push(
                    //         //   context,
                    //         //   MaterialPageRoute(
                    //         //       builder: (context) => const Dashboard()),
                    //         // );
                    //       },
                    //       child: const Wrap(
                    //         children: <Widget>[
                    //           Icon(Icons.app_registration),
                    //           SizedBox(
                    //             width: 5.0,
                    //           ),
                    //           Text('Sign-in with Apple')
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // google login button
                    // Padding(
                    //   padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    //   child: SizedBox(
                    //     width: double.infinity,
                    //     child: ElevatedButton(
                    //       style: ElevatedButton.styleFrom(
                    //         textStyle: const TextStyle(fontSize: 20),
                    //         padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    //       ),
                    //       child: const Wrap(
                    //         children: <Widget>[
                    //           Icon(Icons.g_mobiledata),
                    //           SizedBox(
                    //             width: 5.0,
                    //           ),
                    //           Text('Sign-in with Google')
                    //         ],
                    //       ),
                    //       onPressed: () {
                    //         //login successful
                    //         // Navigator.push(
                    //         //   context,
                    //         //   MaterialPageRoute(
                    //         //       builder: (context) => const Dashboard()),
                    //         // );
                    //       },
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(
                      height: 100,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Don\'t have an account?'),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Signup()),
                              );
                            },
                            child: const Text(
                              ' Sign Up',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // login function return true and false
  Future<bool> login(username, password) async {
    //send request to server
    try {
      Response response = await post(
        Uri.parse('${ApiConstants.baseUrl}/client-v1/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': username,
          'password': password,
        }),
      );
      //if login successful
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print(data);
        if (data['success'] == false) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data['message']),
            ),
          );
          return false;
        }
        //save token in shared preferences
        final SharedPreferences prefs = await _prefs;
        prefs.setString('token', data['access_token']);
        prefs.setString('email', data['user']['email']);
        prefs.setString('firstname', data['user']['firstname']);
        prefs.setString('lastname', data['user']['lastname']);
        prefs.setString('currency', data['user']['currency']?['name'] ?? 'USD');
        prefs.setString(
            'currency_symbol', data['user']['currency']?['symbol'] ?? '\$');
        prefs.setString('profilepic', data['user']['avatar'] ?? '');
        //if login successful
        return true;
      }
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
      //if login failed
      return false;
    }

    // Add the following return statement
    return false;
  }
}
