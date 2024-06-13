import 'package:flutter/material.dart';
import '../common/SidebarDrawer.dart';

//about screen
class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
            //back button
            title: const Text('About')),
        backgroundColor: Colors.blue,
        drawer: const SidebarDrawer(),
        body: Center(
          child: ListView(
            children: const <Widget>[
              ListTile(
                title: Text('About Us'),
                subtitle: Text(
                    'We are a team of experienced professionals who are passionate about technology and are dedicated to providing the best services to our customers.'),
              ),
              ListTile(
                title: Text('Contact Us'),
                subtitle: Text('Email: xyz@gmail.com'),
              ),
              ListTile(
                title: Text('Address'),
                subtitle: Text('123, ABC Street, XYZ City, Country'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
