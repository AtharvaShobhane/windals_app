import 'package:flutter/material.dart';
import 'package:windals_final/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'firstStation.dart';
import 'paramstation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen(
      {super.key,
      required this.stationName,
      required this.isStationAllocated,
      required this.empId});
  final List<String> stationName;
  final bool isStationAllocated;
  final int empId;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late SharedPreferences pref;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async {
    pref = await SharedPreferences.getInstance();
  }

  void stationNavigation(String stationName) {
    pref.setString("stationName", stationName);
    print("login stationame - $stationName");
    if (stationName == 'station 1' ||
        stationName == 's1' ||
        stationName == 'station1') {
      //first station
      Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => FirstStation(
                  empId: widget.empId.toString(),
                )),
      );
    } else {
      // Navigator.pop(context);
      Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => ParamStation(
                stationName: stationName, employeeId: widget.empId!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: "Windals",
      ),
      body: Column(
        children: [
          widget.isStationAllocated
              ? Center(
                child: Column(
                    children: [
                      SizedBox(height: 50,),
                      Text(
                        "Select Station -",
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 20,),
                      DropdownMenu<String>(
                        width: MediaQuery.sizeOf(context).width / 1.25,
                        // initialSelection: productList.first,
                        hintText: "Select Station",
                        onSelected: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            stationNavigation(value!);
                          });
                        },
                        dropdownMenuEntries: widget.stationName
                            .map<DropdownMenuEntry<String>>((String value) {
                          return DropdownMenuEntry<String>(
                              value: value, label: value);
                        }).toList(),
                      ),
                    ],
                  ),
              )
              : Text(
                  "No station Allocated",
                  style: TextStyle(fontSize: 20),
                )
        ],
      ),
    );
  }
}
