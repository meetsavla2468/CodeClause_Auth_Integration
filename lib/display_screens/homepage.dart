import 'package:flutter/material.dart';
class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 50,
        titleTextStyle: const TextStyle(fontSize: 25, color: Colors.black),
        title: const Text('Authentication Integration'),
      ),
    );
  }
}
