// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:windals_final/constants.dart';
import 'package:http/http.dart' as http;
import 'package:windals_final/globals.dart';
import 'dart:convert';

// const List<String> productList = ['Product 1', 'Product 2'];

class FirstStation extends StatefulWidget {
  FirstStation({super.key, required this.empId});
  final String empId;
  @override
  State<FirstStation> createState() => _FirstStationState();
}

class _FirstStationState extends State<FirstStation> {
  late TextEditingController controllerjobname;
  String? jobName;
  String? selectedProduct = productList.first;
  late String selectedMachine;
  // String employeeId = widget.empId;
  int stationId = 0;
  @override
  void initState() {
    super.initState();
    controllerjobname = TextEditingController();
    getStationId();
    // getMachines();
  }

  @override
  void dispose() {
    controllerjobname.dispose();
    super.dispose();
  }

  void getStationId() async {
    final queParam = {
      'stationName': "station1", 'productName': selectedProduct
    };
    var stationInfoId = json.decode((await http.get(
      Uri.http(base, getStationIdStationName,queParam),headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    }
    ))
        .body);
    print(stationInfoId);
    stationId = stationInfoId[0]['station_id'];

    print("-------getStationId---------");
    print("stationId - $stationId   productName  - $selectedProduct ");
    print(stationInfoId);
    print(stationInfoId[0]['station_id']);
    // print(res2);
  }

  void getMachines() async {
    machineList.clear();
    // -------------------- first station machines ----------------------
    var res2 =  json.decode((await http.post(
      Uri.http(base, getMachineAtStation) , body: { "stationId" : "$stationId"},
    ))
        .body);
    setState(() {
      for(var i in res2){
        machineList[i['machine_name']] = i['machine_id'];
      }
      isdonefirstStation = true;
    });
    print("mac kist ");
    print(machineList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'Windals',
      ),
      // endDrawer: const MyDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              "First Station",
              style: kheading1,
            ),
          ),
          SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: 60,
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Text(
              "Enter Job Name - ",
              style: kheading2,
            ),
          ),
          Container(
            width: MediaQuery.sizeOf(context).width / 1.25,
            child: TextField(
              controller: controllerjobname,
              decoration: const InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent, width: 1.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1.5),
                ),
              ),
              onChanged: (String? value) {
                jobName = value;
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 20, top: 40),
            child: Text(
              "Select Product - ",
              style: kheading2,
            ),
          ),
          DropdownMenu<String>(
            width: MediaQuery.sizeOf(context).width / 1.25,
            // initialSelection: productList.first,
            hintText: "Select Product",
            onSelected: (String? value) {
              // This is called when the user selects an item.
              setState(() {
                isdonefirstStation = false;
                selectedProduct = value!;
                getStationId();
                getMachines();
              });
              getStationId();
            },
            dropdownMenuEntries:
                productList.map<DropdownMenuEntry<String>>((String value) {
              return DropdownMenuEntry<String>(value: value, label: value);
            }).toList(),
          ),
          isdonefirstStation ? Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 20, top: 40),
                child: Text(
                  "Select Machine - ",
                  style: kheading2,
                ),
              ),
              DropdownMenu<String>(
                width: MediaQuery.sizeOf(context).width / 1.25,
                hintText: "Select Machine",
                onSelected: (String? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    selectedMachine = value!;
                  });
                },
                dropdownMenuEntries:
                machineList.keys.map<DropdownMenuEntry<String>>((var value) {
                  return DropdownMenuEntry<String>(value: value, label: value);
                }).toList(),
              ),
            ],
          )  : SizedBox.shrink(),
          Padding(
            padding: const EdgeInsets.only(top: 60),
            child: TextButton(
                style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: kred,
                    minimumSize: const Size(270, 45)),
                onPressed: () async {
                  int macId = machineList[selectedMachine];
                  await http.post(Uri.http(base, postProductyyyy), body: {
                    'product_name': selectedProduct,
                    'job_name': jobName,
                    'station_id': '$stationId',
                    'machine_id': '$macId'
                  });
                  await http.post(Uri.http(base, postStationYYYY), body: {
                    'product_name': selectedProduct,
                    'job_name': jobName,
                    'station_id': '$stationId',
                    'employee_id': widget.empId,
                    'machine_id': '$macId'
                  });
                  await http.post(Uri.http(base, postInStationyyyyFirstNextStation),
                      body: {
                        'product_name': selectedProduct,
                        'job_name': jobName,
                        'station_id': '$stationId',
                      });
                  showDialog(
                      barrierColor: Colors.transparent,
                      context: context,
                      builder: (context) {
                        Future.delayed(Duration(seconds: 1), () {
                          Navigator.of(context).pop(true);
                        });
                        return Container(
                          // padding: EdgeInsets.only(bottom: 50),
                          child: const AlertDialog(
                            // backgroundColor: Colors.black12,
                            title: Text(
                              'Job Successfully Added!',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.green),
                            ),
                          ),
                        );
                      });

                  print(jobName);
                  print(selectedProduct);
                  print(macId);
                  controllerjobname.clear();
                },
                child: const Text(
                  'Add Job',
                  style: TextStyle(fontSize: 18),
                )),
          )
        ],
      ),
    );
  }
}
