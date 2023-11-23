import 'package:flutter/material.dart';
import 'package:windals_final/constants.dart';
import '../expansionpanel.dart';
import 'package:http/http.dart' as http;

class ParamStation extends StatefulWidget {
  const ParamStation(
      {super.key, required this.stationName, required this.employeeId});
  final String stationName;
  final int employeeId;
  @override
  State<ParamStation> createState() => _ParamStationState();
}

class _ParamStationState extends State<ParamStation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'Windals',
      ),
      // endDrawer: MyDrawer(),
      bottomNavigationBar: myFooter,
      body: SingleChildScrollView(
        child: Row(
          children: [
            Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: MediaQuery.sizeOf(context).width),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.pending_actions,
                          color: Colors.amber,
                          size: 28,
                        ),
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
                              color: kred,
                              fontSize: 25,
                              fontWeight: FontWeight.w700),
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Container(
                    width: 290,
                    height: 50,
                    color: Color(0xff1d3557),
                      child: Center(
                        child: Text("Current Jobs at Station",
                            style: TextStyle(fontSize: 20 , color: Colors.white)),
                      )),
                ),
                Container(
                  width: 350,
                  height: MediaQuery.sizeOf(context).height,
                  child: ExpansionPanelDemo(
                    stationName: widget.stationName,
                    employeeId: widget.employeeId,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
