import 'package:flutter/material.dart';
import 'package:windals_final/constants.dart';
import 'package:windals_final/station_design.dart';


class Station1 extends StatefulWidget {

   const Station1({super.key });
  @override
  State<Station1> createState() => _Station1State();
}

class _Station1State extends State<Station1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: "Windals"),
        endDrawer:const MyDrawer(),
      body: const Row(
        children: [
          // Text("data"),
          Station(stationName: "Station 2" )
        ],
      ),
      bottomNavigationBar: myFooter,

      );
  }
}
