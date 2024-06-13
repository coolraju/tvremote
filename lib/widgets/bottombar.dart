import 'package:flutter/material.dart';
import '../../Dashboard.dart';
import '../Pages/Invoices.dart';
import '../Pages/Services.dart';
import '../Pages/Tickets.dart';

class BottomBarButtons extends StatefulWidget {
  const BottomBarButtons({super.key});

  @override
  BottomBarButtonsState createState() => BottomBarButtonsState();
}

class BottomBarButtonsState extends State<BottomBarButtons> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 10,
      child: SizedBox(
        height: 100,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Dashboard()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_sharp),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Services()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.receipt),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Invoices()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.support_agent),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Tickets()),
              );
            },
          ),
        ]),
      ),
    );
  }
}
