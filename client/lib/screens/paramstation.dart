import 'package:flutter/material.dart';
import 'package:windals_final/constants.dart';
import '../expansionpanel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:windals_final/globals.dart';


class ParamStation extends StatefulWidget {
  const ParamStation({super.key, required this.stationName , required this.employeeId});
  final String stationName;
  final int employeeId;
  @override
  State<ParamStation> createState() => _ParamStationState();
}

class _ParamStationState extends State<ParamStation> {
  // bool isParam = false;
  // int numParam = 0;
  // List<String> parametersValue = [];
  // List<String> parameters = [];
  //
  // Future<List> getOneStationInfo(String stationName) async {
  //   String station_param_str;
  //   List<String> station_parameters;
  //   bool isParam = false;
  //   final params = {'stationName': stationName};
  //   var url = Uri.http(base, '/api/StationMasterGetOneStation', params);
  //   // print(url);
  //   var res = await http.get(url);
  //   var temp = json.decode(res.body);
  //   var st = temp[0];
  //   // print("--------------------------------------------------------");
  //
  //   if (st["report"] == 1) isParam = true;
  //   station_param_str = st['station_parameters'];
  //   int numParam = ','.allMatches(station_param_str).length + 1;
  //   station_parameters = station_param_str.split(',');
  //   // print(st['station_name']);
  //   return [isParam, numParam, station_parameters];
  // }

  @override
  Widget build(BuildContext context) {
    //
    // List<String> listParam = [] ;
    // getOneStationInfo(widget.stationName).then((value) {
    //   setState(() {
    //     isParam = value[0];
    //     numParam = value[1];
    //     parameters = value[2];
    //   });
    // });

    // print("------------------ Build ------------------------");
    // print(isParam);
    // print(numParam);

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
                        onPressed: (){

                          },
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
                  child: const Text("Job IDs", style: TextStyle(fontSize: 20)),
                ),
                Container(
                  width: 350,
                  height: MediaQuery.sizeOf(context).height,
                  child: ExpansionPanelDemo(
                    stationName: widget.stationName,employeeId: widget.employeeId,
                  ),
                ),
                // if(isParam)SingleChildScrollView(
                //   child: Container(
                //     height: 400,
                //     width: 200,
                //     child: Form(
                //       onChanged: (){
                //         Form.of(context)!.save();
                //       },
                //       autovalidateMode: AutovalidateMode.always,
                //       child: Column(
                //         children: List.generate(numParam, (int index) {
                //           return Padding(
                //             padding: EdgeInsets.only(top:30),
                //             child: Column(
                //               children: [
                //                 Padding(
                //                   padding: const EdgeInsets.only(bottom: 10),
                //                   child: Text(parameters[index]),
                //                 ),
                //                 TextFormField(
                //                   keyboardType: TextInputType.number,
                //                   decoration: const InputDecoration(
                //                     focusedBorder: OutlineInputBorder(
                //                       borderSide: BorderSide(color: Colors.blueAccent, width: 1),
                //                     ),
                //
                //                     enabledBorder: OutlineInputBorder(
                //                       borderSide: BorderSide(color: Colors.black, width: 1),
                //                     ),
                //                   ),
                //                   onSaved: (String? value){
                //                     if(value!= null){
                //                       parametersValue[index] = value;
                //                     }
                //                   },
                //                 ),
                //               ],
                //             ),
                //           );
                //         }),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
