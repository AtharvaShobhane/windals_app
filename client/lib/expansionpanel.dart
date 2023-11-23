import 'package:flutter/material.dart';
import 'package:windals_final/constants.dart';
import 'globals.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class ExpansionPanelDemo extends StatefulWidget {
  ExpansionPanelDemo(
      {super.key, required this.stationName, required this.employeeId});
  String stationName;
  int employeeId;
  // String station_id;
  @override
  _ExpansionPanelDemoState createState() => _ExpansionPanelDemoState();
}

class _ExpansionPanelDemoState extends State<ExpansionPanelDemo> {
  // bool isParam = false;
  int numParam = 0;
  List<String> parametersValue = [];
  List<String> parameters = [];
  int accepted = 0, rejected = 0, rework = 0;
  String selectedProductAtStation = "Select Product";
  late String selectedMachineAtStation;
  late String stationNameforStationId = widget.stationName;
  late int empId = widget.employeeId;
  int stationId = 0;
  var res;
  int numJobs = 0;
  List<Item> _jobs = [];
  List<Item> _undojobs = [];
  bool isMachine = false;
  var disableColor = Colors.grey;
  var productParamMap = {};

  //-----------------------------------------------station-id-changed-------------------------------------------------
  void getCount() async {
    var res = json.decode((await http.get(
      Uri.http(
          base, getCountAtStation, {'stationName': stationNameforStationId}),
    ))
        .body);
    print(res);

    setState(() {
      accepted = res['ok'];
      rejected = res['notok'];
      rework = res['rework'];
    });
    print(accepted);
  }

  String getjobidfromjobname(String jobName) {
    for (var i in res) {
      if (i['job_name'] == jobName) {
        return i['job_id'];
      }
    }
    return "No job found";
  }

  String getproductnamefromjobname(String jobName) {
    for (var i in res) {
      if (i['job_name'] == jobName) {
        return i['product_name'];
      }
    }
    return "No job found";
  }

  Future<List> getOneStationInfo(String stationName) async {
    String station_param_str;
    List<String> station_parameters;
    // bool isParam = false;
    final params = {'stationName': stationName};
    var url = Uri.http(base, getOneStation, params);
    // print(url);
    var res = await http.get(url);

    var temp = json.decode(res.body);
    for (var i in temp) {
      productParamMap[i['product_name']] = i['station_parameters'];
    }
    print("----------------product param map-----------");
    print(productParamMap);
    var st = temp[0];
    // print("--------------------------------------------------------");
    print("station info ----");
    print(temp);
    if (st["report"] == 1) isParam = true;
    // station_param_str = st['station_parameters'];
    // int numParam = ','.allMatches(station_param_str).length + 1;
    // station_parameters = station_param_str.split(',');
    // print(station_param_str);
    // print(station_parameters);
    // print(st['station_name']);
    return [isParam];
  }

  void getParamDetails(String product_name) async {
    String param_str = productParamMap[product_name];
    var param_arr = param_str.split(',');
    // var param_arr_new = [];
    print(productParamMap[product_name]);
    // for(var i in param_arr){
    //    param_arr_new.add("\'$i\'");
    // }
    print(param_arr);
    setState(() {
      numParam = ','.allMatches(param_str).length + 1;
      parameters = param_str.split(',');
      for (int i = 0; i < parameters.length; i++) {
        parametersValue.add('0');
      }
    });

    // pass array in post
    Map<String, dynamic> args = {"parameterName": param_arr , "product_name": product_name};
    var body = json.encode(args);
    var res = json.decode((await http.post(Uri.http(base, getParamStatus),
            body: body,  headers: {'Content-type': 'application/json'}))
        .body);
    print("-------------param deatils---------------");
    print(res);


  }

  void getStationId() async {
    print(stationNameforStationId + " " + selectedProductAtStation);
    var que = {
      'stationName': stationNameforStationId,
      'productName': selectedProductAtStation
    };
    var stationInfoId = json.decode((await http.get(
      Uri.http(base, getStationIdStationName, que),
    ))
        .body);
    stationId = stationInfoId[0]['station_id'];
    // -----------------------------machine details------------------------------
    var res2 = json.decode((await http.post(
      Uri.http(base, getMachineAtStation),
      body: {"stationId": "$stationId"},
    ))
        .body);
    setState(() {
      isMachine = true;
    });
    for (var i in res2) {
      machineList[i['machine_name']] = i['machine_id'];
    }

    print("-------getStationId---------");
    print(
        "stationId - $stationId stationName - $stationNameforStationId  productName  - $selectedProductAtStation employeeId - $empId");
    print(stationInfoId);
    print(stationInfoId[0]['station_id']);
    print(res2);
  }

  void getMachines() async {
    machineList.clear();
    // -------------------- first station machines ----------------------
    var res2 = json.decode((await http.post(
      Uri.http(base, getMachineAtStation),
      body: {"stationId": "$stationId"},
    ))
        .body);
    setState(() {
      for (var i in res2) {
        machineList[i['machine_name']] = i['machine_id'];
      }
    });
    print("mac kist ");
    print(machineList);
  }

  void getJobAtStation() async {
    final body = {'station_id': "$stationId"};
    res = json.decode(
        (await http.post(Uri.http(base, getjobatstation), body: body)).body);
    print(res);
    for (var i in res) {
      jobNames.add(i['job_name']);
    }
    setState(() {
      numJobs = res.length;
      _jobs = generateItems(numJobs, jobNames);
    });

    print("----------------getJobs-----------------");
    print("is param = $isParam");
    print(jobNames);
    print(_jobs);
    print(_undojobs);
    print(numJobs);
  }

  int currentItemKey = 0;

  late TextEditingController controller;
  late List<TextEditingController> paramcontroller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    // paramcontroller = TextEditingController();
    paramcontroller =
        List.generate(parameters.length, (i) => TextEditingController());

    getOneStationInfo(widget.stationName).then((value) {
      setState(() {
        isParam = value[0];
      });
    });
    // getStationId();
    getJobAtStation();
    getCount();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    // List<TextEditingController> paramcontroller = List.generate(parameters.length, (i) => TextEditingController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text("Product - "),
                    DropdownMenu<String>(
                      width: MediaQuery.sizeOf(context).width / 4,
                      // initialSelection: productList.first,
                      hintText: "Select Product",
                      onSelected: (String? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          isMachine = false;
                          selectedProductAtStation = value!;
                          machineList.clear();
                          getStationId();
                          // getMachines();
                          getParamDetails(selectedProductAtStation);
                        });
                      },
                      dropdownMenuEntries: productList
                          .map<DropdownMenuEntry<String>>((String value) {
                        return DropdownMenuEntry<String>(
                            value: value, label: value);
                      }).toList(),
                    ),
                  ],
                ),
                SizedBox(
                  width: 20,
                ),
                isMachine
                    ? Column(
                        children: [
                          Text("Machine -"),
                          DropdownMenu<String>(
                            width: MediaQuery.sizeOf(context).width / 4,
                            initialSelection: machineList.keys.first,
                            onSelected: (String? value) {
                              // This is called when the user selects an item.
                              setState(() {
                                selectedMachineAtStation = value!;
                              });
                            },
                            dropdownMenuEntries: machineList.keys
                                .map<DropdownMenuEntry<String>>((var value) {
                              return DropdownMenuEntry<String>(
                                  value: value, label: value);
                            }).toList(),
                          ),
                        ],
                      )
                    : SizedBox.shrink(),
                SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      jobNames.clear();
                      getJobAtStation();
                      getCount();
                      // getStationId();
                    });
                  },
                  child: Icon(Icons.refresh, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff457b9d)),
                ),
              ],
            ),
            DataTable(columns: [
              DataColumn(label: Text('Accepted')),
              DataColumn(label: Text('Rejected')),
              DataColumn(label: Text('Rework'))
            ], rows: [
              DataRow(cells: [
                (DataCell(Center(child: Text('$accepted')))),
                DataCell(Center(child: Text('$rejected'))),
                DataCell(Center(child: Text('$rework')))
              ])
            ]),
            Container(
              // width: 350,
              padding: const EdgeInsets.only(top: 20),
              child: _buildPanel(),
            ),
            SizedBox(
              height: 70,
            ),
            Text(
              "Undo Tasks",
              style: TextStyle(fontSize: 15),
            ),
            Divider(
              color: Colors.black,
              thickness: 3,
            ),
            Container(
              height: 300,
              // color: Colors.black12,
              width: 200,
              child: ListView.builder(
                // scrollDirection: Axis.horizontal,
                itemCount: _undojobs.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    shape: const RoundedRectangleBorder(
                      side: BorderSide(width: 1.5),
                      // borderRadius: BorderRadius.circular(10),
                    ),
                    title: Text(
                      _undojobs[index].headerValue,
                      style: TextStyle(fontSize: 15, color: Colors.red),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.undo),
                      onPressed: () {
                        setState(() {
                          _jobs.add(_undojobs[index]);
                          // getJobAtStation();
                          _undojobs.removeWhere(
                              (element) => element == _undojobs[index]);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPanel() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _jobs[index].isExpanded = !isExpanded;
          currentItemKey = index;
        });
      },
      children: _jobs.map<ExpansionPanel>((Item item) {
        return ExpansionPanel(
          canTapOnHeader: true,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(item.headerValue),
            );
          },
          body: Container(
            decoration: BoxDecoration(color: Color(0xFFEAEAEA)),
            padding: EdgeInsets.only(top: 20),
            child: Column(
              children: [
                ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        width: 150,
                        child: ElevatedButton(
                          onPressed: () async {
                            var paramString = "";
                            int macid = machineList[selectedMachineAtStation];
                            for (int i = 0; i < numParam; i++) {
                              paramString += parameters[i] +
                                  ':' +
                                  parametersValue[i] +
                                  ';';
                            }
                            print(parametersValue);

                            http.put(Uri.http(base, updateStationyyyy), body: {
                              'product_name':
                                  getproductnamefromjobname(item.headerValue),
                              'station_id': '$stationId',
                              'job_name': item.headerValue,
                              'employee_id': '$empId',
                              'status': '1',
                              'parameters': paramString,
                              'machine_id': '$macid'
                            });

                            Map data = {
                              "station_id": "$stationId",
                              "job_name": '${item.headerValue}',
                              "product_name":
                                  '${getproductnamefromjobname(item.headerValue)}'
                            };
                            var body = json.encode(data);
                            print(body);
                            print(item.headerValue);
                            await http.post(
                                Uri.http(
                                    base, postInStationyyyyFirstNextStation),
                                headers: {"Content-Type": "application/json"},
                                body: body);

                            setState(() {
                              _jobs.removeWhere(
                                  (Item currentItem) => item == currentItem);
                              _undojobs.add(item);
                            });

                            getCount();
                          },
                          child: const Icon(Icons.check_rounded,
                              color: Colors.white, size: 24.0),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                        ),
                      ),
                      Container(
                        width: 150,
                        child: ElevatedButton(
                          onPressed: () async {
                            var paramString = "";
                            for (int i = 0; i < numParam; i++) {
                              paramString += parameters[i] +
                                  ':' +
                                  parametersValue[i] +
                                  ';';
                            }

                            //reason text
                            final rejectReasonText = await opendialog();
                            print("Reject Reason -- $rejectReasonText");
                            paramString = "notok:" +
                                rejectReasonText! +
                                ";" +
                                paramString;

                            int macid = machineList[selectedMachineAtStation];
                            http.put(Uri.http(base, updateStationyyyy), body: {
                              'product_name':
                                  getproductnamefromjobname(item.headerValue),
                              'station_id': '$stationId',
                              'job_name': item.headerValue,
                              'employee_id': '$empId',
                              'status': '-1',
                              'parameters': paramString,
                              'machine_id': '$macid'
                            });
                            setState(() {
                              _jobs.removeWhere(
                                  (Item currentItem) => item == currentItem);
                              _undojobs.add(item);
                            });

                            getCount();
                          },
                          child: const Icon(
                            Icons.clear_rounded,
                            color: Colors.white,
                            size: 30.0,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                        ),
                      ),
                      // IconButton(
                      //   onPressed: () async {
                      //     //param string
                      //     var paramString = "";
                      //     for (int i = 0; i < numParam; i++) {
                      //       paramString +=
                      //           parameters[i] + ':' + parametersValue[i] + ';';
                      //     }
                      //
                      //     //dialogue box
                      //     final reworkReasonText = await opendialog();
                      //     print("Rework Reason -- $reworkReasonText");
                      //
                      //     //api calls
                      //     http.put(Uri.http(base, updateStationyyyy), body: {
                      //       'product_name':
                      //           getproductnamefromjobname(item.headerValue),
                      //       'station_id': '$stationId',
                      //       'job_name': item.headerValue,
                      //       'employee_id': '$empId',
                      //       'status': '2',
                      //       'parameters': paramString
                      //     });
                      //
                      //     setState(() {
                      //       _jobs.removeWhere(
                      //           (Item currentItem) => item == currentItem);
                      //       _undojobs.add(item);
                      //     });
                      //     getCount();
                      //   },
                      //   icon: const Icon(
                      //     Icons.redo,
                      //     color: Colors.orange,
                      //     size: 30.0,
                      //   ),
                      // ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  child: isParam
                      ? Container(
                          height: 400,
                          width: 250,
                          child: Column(
                            children: List.generate(numParam, (int index) {
                              return Padding(
                                padding: EdgeInsets.only(top: 30),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: Text(parameters[index]),
                                        ),
                                        SizedBox(
                                          width: 100,
                                          height: 30,
                                          child: TextField(
                                            // controller: paramcontroller[index],
                                            keyboardType: TextInputType.number,

                                            decoration: const InputDecoration(
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.blueAccent,
                                                    width: 1),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black,
                                                    width: 1),
                                              ),
                                            ),
                                            onChanged: (String? value) {
                                              if (value != null) {
                                                parametersValue[index] = value;
                                                print(parameters[index] +
                                                    " " +
                                                    parametersValue[index]);
                                              }
                                            },
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              setState(() {});
                                            },
                                            icon: Icon(
                                              Icons.check_box,
                                              color: Colors.greenAccent,
                                            )),
                                        IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              Icons.clear,
                                              color: Colors.red,
                                            ))
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ),
                        )
                      : null,
                ),
              ],
            ),
          ),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }

  Future<String?> opendialog() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text("Reason"),
            content: TextField(
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(hintText: "Type your reason"),
            ),
            actions: [
              TextButton(
                  onPressed: submit,
                  child: const Text(
                    "Submit",
                    style: TextStyle(color: kred),
                  ))
            ],
          ));
  void submit() {
    Navigator.of(context).pop(controller.text);
    controller.clear();
  }
}

// stores ExpansionPanel state information
class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

List<Item> generateItems(int numberOfItems, List<String> jobNames) {
  return List.generate(numberOfItems, (int index) {
    return Item(
      headerValue: jobNames[index],
      expandedValue: 'Details for Book $index goes here',
    );
  });
}
