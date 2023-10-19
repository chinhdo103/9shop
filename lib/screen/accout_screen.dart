import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: const Center(
          child: Text(
            'This is account screen ',
            style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
