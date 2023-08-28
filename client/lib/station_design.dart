import 'package:flutter/material.dart';
import 'package:windals_final/constants.dart';
import 'expansionpanel.dart';

class Station extends StatefulWidget {
  const Station({Key? key, required this.stationName}) : super(key: key);
  final String stationName;
  @override
  State<Station> createState() => _StationState();
}

class _StationState extends State<Station> {

  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: MediaQuery.sizeOf(context).width),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 20),
                child: Icon(
                  Icons.pending_actions,
                  color: Colors.amber,
                  size: 28,
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                width: MediaQuery.sizeOf(context).width / 1.5,
                height: 55,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAEAEA),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Text(
                    widget.stationName,
                    style: const TextStyle(
                        color: kred, fontSize: 25, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 28,
                ),
              ),
            ],
          ),
          const Text("Job IDs", style: TextStyle(fontSize: 20)),
          Container(width: 350, height: 500, child: const ExpansionPanelDemo())

        ],
      ),
    );
  }


}
