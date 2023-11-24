import 'dart:io';

import 'package:flutter/material.dart';
import 'package:windals_final/constants.dart';
import 'package:http/http.dart' as http;
import 'package:windals_final/globals.dart';
import 'dart:convert';

class SupervisorPage extends StatefulWidget {
  const SupervisorPage({super.key});

  @override
  State<SupervisorPage> createState() => _SupervisorPageState();
}

class _SupervisorPageState extends State<SupervisorPage> {
  var jobNames = [];
  bool isDone = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getJobAtSupervisor();
  }

  void getJobAtSupervisor() async {
    var res = json.decode(
        (await http.get(Uri.http(base, getJobAtSupervisorStation))).body);
    jobNames = res;
    print(jobNames);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: "Windals",
      ),
      bottomNavigationBar: myFooter,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 25, bottom: 25),
                  child: Text(
                    "Supervisor Page",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(
                  width: 50,
                ),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isDone = true;
                      });
                      getJobAtSupervisor();
                    },
                    child: Icon(Icons.refresh)),
              ],
            ),
            isDone
                ? Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Container(
                      child: Column(
                        children: List.generate(jobNames.length, (index) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFf1faee),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0x33808080), //New
                                    blurRadius: 15.0,
                                    offset: Offset(0, 10))
                              ],
                            ),
                            padding: EdgeInsets.all(20),
                            margin: EdgeInsets.only(bottom: 20),
                            height: 300,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 120,
                                      // height: 100,
                                      // color: Color(0xffa8dadc),
                                      child: Column(
                                        children: [
                                          Text("Job Name -" , style: TextStyle(color: Colors.black54 , fontSize: 15)),
                                          Text(jobNames[index]['job_name'] , style: TextStyle(fontSize: 25 , color: Color(0xff1d3557), fontWeight: FontWeight.w800),),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 120,
                                      child: Column(
                                        children: [
                                          Text("Station Name -" , style: TextStyle(color: Colors.black54 , fontSize: 15)),
                                          Text(stationidNamemap[jobNames[index]['station_id']] , style: TextStyle(fontSize: 25 , color: Color(0xff1d3557), fontWeight: FontWeight.w800),),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text("Reason - ", style: TextStyle(color: Colors.black54 , fontSize: 18)),
                                Text(jobNames[index]['parameters'] , style: TextStyle(fontSize: 15 , color: Color(0xff1d3557), fontWeight: FontWeight.w500)),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Text("Empoloyee Name -",style: TextStyle(color: Colors.black54 , fontSize: 18)),
                                    Text(jobNames[index]['first_name'] + " " +jobNames[index]['last_name'] , style: TextStyle(fontSize: 18 , color: Color(0xff1d3557), fontWeight: FontWeight.w800))
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () async {
                                        //update
                                        int stationIdStr = jobNames[index]['station_id'];
                                        int employeeIdStr = jobNames[index]['employee_id'];
                                        int machineIdStr = jobNames[index]['machine_id'];
                                        print("$stationIdStr $employeeIdStr $machineIdStr");
                                        await http.put(
                                            Uri.http(base, updateStationyyyyRework
                                            ),
                                            body: {
                                              'product_name': jobNames[index]
                                                  ['product_name'],
                                              'station_id': '$stationIdStr',
                                              'job_name': jobNames[index]
                                                  ['job_name'],
                                              'employee_id': '$employeeIdStr',
                                              'status': '2',
                                              'parameters': jobNames[index]
                                                  ['parameters'],
                                              'machine_id': '$machineIdStr'
                                            });
                                        // next station
                                        await http.post(
                                            Uri.http(base,
                                                postInStationyyyyFirstNextStation),
                                            headers: {
                                              "Content-Type": "application/json"
                                            },
                                            body: json.encode({
                                              "station_id": '$stationIdStr',
                                              "job_name": jobNames[index]
                                                  ['job_name'],
                                              "product_name": jobNames[index]
                                                  ['product_name']
                                            }));
                                        setState(() {
                                          jobNames.removeWhere(
                                                  (var currentItem) =>
                                              jobNames[index] ==
                                                  currentItem);
                                        });
                                      },
                                      child: Icon(Icons.check),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                      ),
                                    ),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                        ),
                                        onPressed: () async {
                                          int stationIdStr = jobNames[index]['station_id'];
                                          int employeeIdStr = jobNames[index]['employee_id'];
                                          int machineIdStr = jobNames[index]['machine_id'];
                                          await http.put(
                                              Uri.http(base, updateStationyyyyRework),
                                              body: {
                                                'product_name': jobNames[index]
                                                    ['product_name'],
                                                'station_id': '$stationIdStr',
                                                'job_name': jobNames[index]
                                                    ['job_name'],
                                                'employee_id': '$employeeIdStr',
                                                'status': '-2',
                                                'parameters': jobNames[index]
                                                    ['parameters'],
                                                'machine_id': '$machineIdStr'
                                              });
                                          setState(() {
                                            jobNames.removeWhere(
                                                    (var currentItem) =>
                                                jobNames[index] ==
                                                    currentItem);
                                          });
                                        },
                                        child: Icon(Icons.clear)),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xffFFD300),
                                        ),
                                        onPressed: () async {
                                          int stationIdStr = jobNames[index]['station_id'];
                                          int employeeIdStr = jobNames[index]['employee_id'];
                                          int machineIdStr = jobNames[index]['machine_id'];
                                          await http.put(
                                              Uri.http(base, updateStationyyyyRework),
                                              body: {
                                                'product_name': jobNames[index]
                                                    ['product_name'],
                                                'station_id': '$stationIdStr',
                                                'job_name': jobNames[index]
                                                    ['job_name'],
                                                'employee_id': '$employeeIdStr',
                                                'status': '-3',
                                                'parameters': jobNames[index]
                                                    ['parameters'],
                                                'machine_id': '$machineIdStr'
                                              });
                                          await http.post(
                                              Uri.http(base,
                                                  StationyyyyInsertSameStation),
                                              headers: {
                                                "Content-Type":
                                                    "application/json"
                                              },
                                              body: json.encode({
                                                "station_id": '$stationIdStr',
                                                "job_name": jobNames[index]
                                                    ['job_name'],
                                                "product_name": jobNames[index]
                                                    ['product_name']
                                              }));
                                          setState(() {
                                            jobNames.removeWhere(
                                                    (var currentItem) =>
                                                jobNames[index] ==
                                                    currentItem);
                                          });
                                        },
                                        child: Icon(Icons.undo)),
                                  ],
                                )
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
