import 'package:flutter/material.dart';
import 'package:windals_final/constants.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: "Windals",),
      body: Column(children: [
        Text("No station Allocated" , style: TextStyle(fontSize: 20),)
      ],
      ),
    );
  }
}
