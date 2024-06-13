import 'package:flutter/material.dart';
import '../Pages/TicketAdd.dart';

class FloatingButton extends StatefulWidget {
  const FloatingButton({super.key});

  @override
  FloatingbuttonState createState() => FloatingbuttonState();
}

class FloatingbuttonState extends State<FloatingButton> {
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 30,
      backgroundColor: const Color(0xff2723d8),
      child: IconButton(
        icon: const Icon(Icons.add),
        color: Colors.white,
        onPressed: () {
          print("clicked");
          _newButtons(context);
        },
      ),
    );
  }

  void _newButtons(BuildContext context) {
    showModalBottomSheet(
      useRootNavigator: true,
      elevation: 0,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      context: context,
      builder: (context) {
        return Container(
          width: double.maxFinite,
          decoration: const BoxDecoration(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 35,
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Add Order'),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TicketAdd()),
                    );
                  },
                  child: const Text("Add Ticket"))
            ],
          ),
        );
      },
    );
  }
}
