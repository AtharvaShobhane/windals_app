import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:windals_final/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:windals_final/screens/supervisorPage.dart';
import 'firstStation.dart';
import 'paramstation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:windals_final/globals.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen(
      {super.key,
      required this.stationName,
      required this.isStationAllocated,
      required this.empId,
      required this.userName});
  final List<String> stationName;
  final bool isStationAllocated;
  final int empId;
  final String userName;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var isSupervisor = "";
  late SharedPreferences pref;
  bool loaded = false;
  late var resEmpData;
  var empDetails;
  // bool _isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSharedPref();
    getEmpData();
  }

  void initSharedPref() async {
    pref = await SharedPreferences.getInstance();
  }

  void getEmpData() async {
    resEmpData = json.decode((await http.get(
      Uri.http(base, EmployeeMasterGetOne, {'userName': widget.userName}),
    ))
        .body);
    print(resEmpData);
    setState(() {
      isSupervisor = resEmpData[0]['access_given'];
      loaded = true;
    });
    print(isSupervisor);
    empDetails = Container(
      child: Column(
        children: [
          Text("Name - ${resEmpData[0]['first_name']} ${resEmpData[0]['last_name']}"),
          Text("Username - ${resEmpData[0]['user_name']}"),
          Text("Designation - ${resEmpData[0]['designation']}"),
          Text("Mobile no. - ${resEmpData[0]['mobile_no']}")
        ],
      ),
    );
  }

  void stationNavigation(String stationName) {
    pref.setString("stationName", stationName);
    print("login stationame - $stationName");
    if (stationNamePosMap[stationName] == 1) {
      //first station
      Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => FirstStation(
                  stationName: stationName,
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
      bottomNavigationBar: myFooter,
      body: loaded
          ? Column(
              children: [
                widget.isStationAllocated
                    ? Center(
                        child: isSupervisor[18] == '0'
                            ? Column(
                                children: [
                                  SizedBox(
                                    height: 50,
                                  ),
                                  empDetails,
                                  SizedBox(
                                    height: 50,
                                  ),
                                  Text(
                                    "Select Station -",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  DropdownMenu<String>(
                                    width:
                                        MediaQuery.sizeOf(context).width / 1.25,
                                    // initialSelection: productList.first,
                                    hintText: "Select Station",
                                    onSelected: (String? value) {
                                      // This is called when the user selects an item.
                                      setState(() {
                                        stationNavigation(value!);
                                      });
                                    },
                                    dropdownMenuEntries: widget.stationName
                                        .map<DropdownMenuEntry<String>>(
                                            (String value) {
                                      return DropdownMenuEntry<String>(
                                          value: value, label: value);
                                    }).toList(),
                                  ),
                                ],
                              )
                            : Column(
                              children: [
                                SizedBox(height: 50,),
                                empDetails,
                                Padding(
                                    padding: const EdgeInsets.only(top: 50),
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              CupertinoPageRoute(
                                                builder: (context) =>
                                                    SupervisorPage(),
                                              ));
                                        },
                                        child: Text("Go to Supervisor Dashboard")),
                                  ),
                              ],
                            ),
                      )
                    : Text(
                        "No station Allocated",
                        style: TextStyle(fontSize: 20),
                      )
              ],
            )
          : Center(
              child: LoadingAnimationWidget.threeArchedCircle(
                  color: Colors.black, size: 50),
            ),
    );
  }
}
