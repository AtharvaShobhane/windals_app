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
  String selectedProductAtStation = productList.first;
  late String stationNameforStationId = widget.stationName;
  late int empId = widget.employeeId;
  int stationId = 0;
  var res;
  int numJobs = 0;
  List<Item> _jobs = [];
  var disableColor = Colors.grey;

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
    var st = temp[0];
    // print("--------------------------------------------------------");

    if (st["report"] == 1) isParam = true;
    station_param_str = st['station_parameters'];
    int numParam = ','.allMatches(station_param_str).length + 1;
    station_parameters = station_param_str.split(',');
    // print(st['station_name']);
    return [isParam, numParam, station_parameters];
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
    print("-------getStationId---------");
    print(
        "stationId - $stationId stationName - $stationNameforStationId  productName  - $selectedProductAtStation employeeId - $empId");
    print(stationInfoId);
    print(stationInfoId[0]['station_id']);
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
        numParam = value[1];
        parameters = value[2];
        for (int i = 0; i < parameters.length; i++) {
          parametersValue.add('0');
        }
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
                DropdownMenu<String>(
                  width: MediaQuery.sizeOf(context).width / 4,
                  initialSelection: productList.first,
                  onSelected: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      selectedProductAtStation = value!;
                      getStationId();
                    });
                  },
                  dropdownMenuEntries: productList
                      .map<DropdownMenuEntry<String>>((String value) {
                    return DropdownMenuEntry<String>(
                        value: value, label: value);
                  }).toList(),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        jobNames.clear();
                        getJobAtStation();
                        getCount();
                        // getStationId();
                      });
                    },
                    icon: Icon(Icons.refresh)),
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
          ],
        ),
      ),
    );
  }

  Widget _buildPanel() {
    // print(_formKeys.length);
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
          body: Column(
            children: [
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    IconButton(
                      onPressed: () async {
                        var paramString = "";
                        for (int i = 0; i < numParam; i++) {
                          paramString +=
                              parameters[i] + ':' + parametersValue[i] + ';';
                        }
                        print(parametersValue);

                        http.put(Uri.http(base, updateStationyyyy), body: {
                          'product_name':
                              getproductnamefromjobname(item.headerValue),
                          'station_id': '$stationId',
                          'job_name': item.headerValue,
                          'employee_id': '$empId',
                          'status': '1',
                          'parameters': paramString
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
                            Uri.http(base, postInStationyyyyFirstNextStation),
                            headers: {"Content-Type": "application/json"},
                            body: body);

                        setState(() {
                          _jobs.removeWhere(
                              (Item currentItem) => item == currentItem);
                        });
                        getCount();
                      },
                      icon: const Icon(Icons.check_rounded,
                          color: Colors.green, size: 24.0),
                    ),
                    IconButton(
                      onPressed: () async {
                        var paramString = "";
                        for (int i = 0; i < numParam; i++) {
                          paramString +=
                              parameters[i] + ':' + parametersValue[i] + ';';
                        }

                        //reason text
                        final rejectReasonText = await opendialog();
                        print("Reject Reason -- $rejectReasonText");
                        paramString =
                            "notok:" + rejectReasonText! + ";" + paramString;
                        http.put(Uri.http(base, updateStationyyyy), body: {
                          'product_name':
                              getproductnamefromjobname(item.headerValue),
                          'station_id': '$stationId',
                          'job_name': item.headerValue,
                          'employee_id': '$empId',
                          'status': '0',
                          'parameters': paramString
                        });
                        setState(() {
                          _jobs.removeWhere(
                              (Item currentItem) => item == currentItem);
                        });
                        getCount();
                      },
                      icon: const Icon(
                        Icons.clear_rounded,
                        color: Colors.red,
                        size: 30.0,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        //param string
                        var paramString = "";
                        for (int i = 0; i < numParam; i++) {
                          paramString +=
                              parameters[i] + ':' + parametersValue[i] + ';';
                        }

                        //dialogue box
                        final reworkReasonText = await opendialog();
                        print("Rework Reason -- $reworkReasonText");

                        //api calls
                        http.put(Uri.http(base, updateStationyyyy), body: {
                          'product_name':
                              getproductnamefromjobname(item.headerValue),
                          'station_id': '$stationId',
                          'job_name': item.headerValue,
                          'employee_id': '$empId',
                          'status': '2',
                          'parameters': paramString
                        });

                        setState(() {
                          _jobs.removeWhere(
                              (Item currentItem) => item == currentItem);
                        });
                        getCount();
                      },
                      icon: const Icon(
                        Icons.redo,
                        color: Colors.orange,
                        size: 30.0,
                      ),
                    ),
                    // IconButton(
                    //     onPressed: () async {
                    //
                    //     },
                    //     icon: Icon(
                    //       Icons.next_plan_rounded,
                    //       color: Colors.black,
                    //       size: 30,
                    //     ))
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
                                                  color: Colors.black, width: 1),
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
                                      IconButton(onPressed: (){
                                        setState(() {

                                        });
                                      }, icon: Icon(Icons.check_box , color: Colors.greenAccent,)),
                                      IconButton(onPressed: (){}, icon: Icon(Icons.clear ,color: Colors.red,))
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
