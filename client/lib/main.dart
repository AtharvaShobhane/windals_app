// import 'dart:html';

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:windals_final/screens/firstStation.dart';
import 'package:windals_final/screens/myprofile.dart';
import 'package:windals_final/screens/paramstation.dart';
import 'constants.dart';
import 'globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

var prefList;
late int serverInfo;
late bool serverInfobool;

Future<bool> checkServerResponse() async {
  // serverInfo = 0;
  try {
    var response = await http
        .get(Uri.http(base, stationMasterGet))
        .timeout(const Duration(seconds: 15), onTimeout: () {
      return http.Response('Error', 408);
    });
    serverInfo = response.statusCode;
    print("server info ------------");
    print(serverInfo);
    return serverInfo == 201;
  } catch (e) {
    return false;
  }
}

Future<List<dynamic>> getPref() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return [
    prefs.getString('token'),
    prefs.getString('stationName'),
    prefs.getInt('employeeId')
  ];
}

void main() async {
  checkServerResponse();
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefList = await getPref();
  var tk = prefs.getString('token');
  String? stationName = prefs.getString('stationName');
  int? empId = prefs.getInt('employeeId');
  print("------------------------");
  print("$stationName $empId $tk");
  runApp(MyApp(token: tk, stationName: stationName, empId: empId));
}

class MyApp extends StatelessWidget {
  final token, stationName, empId;
  const MyApp({this.token, this.stationName, this.empId, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(token: token, stationName: stationName, empId: empId),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  final token, stationName, empId;
  const MyHomePage({this.token, this.stationName, this.empId, super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TextEditingController ipNamecontroller;
  late TextEditingController ipAddcontroller;

  Map<String, String> baseUrlList = {
    'Atharva/Parikshit Laptop': '192.168.137.1:8080',
    'College PC': '172.16.21.252:8080',
    'Real IP': '103.97.164.116:8080'
  };
  String? dropdownValue;
  bool _isLoading = false;
  bool _isLoginLoading = false;
  bool _ifError = false;
  late String ipName;
  late String ipAdd;
  void getStationInfo() async {
    var url = Uri.http(base, stationMasterGet);
    var res =
        await http.get(url).timeout(const Duration(seconds: 20), onTimeout: () {
      setState(() {
        _isLoading = false;
        _ifError = true;
      });
      return http.Response('Errooooor', 408);
    });
    var temp = json.decode(res.body);
    print(temp);
    for (var i in temp) {
      // print(i['station_name']);
      stationlist.add(i['station_name']);
      stationidNamemap[i['station_id']] = i['station_name'];
    }
    print(stationlist);
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isLoading = false;
      _ifError = false;
    });
  }

  void getProductInfo() async {
    var res =
        json.decode((await http.get(Uri.http(base, productMasterGet))).body);
    for (var i in res) {
      if(!productList.contains(i['product_name']))productList.add(i['product_name']);
    }
    print("--------------- Product List -----------------");
    print(productList);
  }

  List<DropdownMenuItem<String>> getIpItems(){

    return baseUrlList.keys.map((String key) {
      return DropdownMenuItem<String>(
        value: baseUrlList[key],
        child: Text(
          key,
          style: TextStyle(color: Colors.white),
        ),
      );
    }).toList();
  }

  void addMap(String ip_Name , String ip_Add){
    setState(() {
      if (ip_Name != "" && ip_Add != "") {
        print("added");
        baseUrlList[ip_Name] = ip_Add;
      }
    });
  }
  void deleteMap(String ip_Name){
    setState(() {
      baseUrlList.remove(ip_Name);
    });
  }

  @override
  void initState() {
    ipNamecontroller = TextEditingController();
    ipAddcontroller = TextEditingController();
    getStationInfo();
    getProductInfo();
    // prefList = await getPref();
  }

  @override
  Widget build(BuildContext context) {
    // return MyProfile();
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/bg-img.jpg"),
            fit: BoxFit.cover,
            opacity: 0.75),
      ),
      child: Scaffold(
        backgroundColor: const Color(0x0d000000),
        appBar: MyAppBar(title: "Windals App"),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 200,
                  child: Image.asset(
                    'assets/images/windals-logo-removebg.png',
                    fit: BoxFit.cover,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  child: Text(
                    "Windal Precision Pvt. Ltd",
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      left: 20, right: 20, bottom: 20, top: 10),
                  decoration: const BoxDecoration(color: Color(0x99000000)),
                  child: const Padding(
                    padding: EdgeInsets.all(30),
                    child: Text(
                        style: TextStyle(color: Colors.white),
                        "Established in 1978 ,India Windals Precision Pvt. Ltd. has gained immense expertise in supplying & trading of Axle components, steering knuckles, steering arms etc. The supplier company is located in Chakan, Maharashtra and is one of the leading sellers of listed products. Buy Axle components, steering knuckles, steering arms in bulk from us for the best quality products and service."),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 55),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.add_circle,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: const Text("Add/Delete IP's"),
                                    content: Container(
                                      height: 100,
                                      child: Column(
                                        children: [
                                          TextField(
                                            onChanged: (value) {
                                              ipName = value;
                                            },
                                            controller: ipNamecontroller,
                                            autofocus: true,
                                            decoration: InputDecoration(
                                                hintText: "Enter IP name -"),
                                          ),
                                          TextField(
                                            onChanged: (value) {
                                              ipAdd = value;
                                            },
                                            controller: ipAddcontroller,
                                            autofocus: true,
                                            decoration: InputDecoration(
                                                hintText: "Enter IP Address -"),
                                          )
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          deleteMap(ipName);
                                          Navigator.of(context)
                                              .pop(ipNamecontroller.text);
                                          baseUrlList.clear();
                                        },
                                        style: const ButtonStyle(
                                          backgroundColor: MaterialStatePropertyAll(Colors.red),
                                        ),
                                        child: const Text(
                                          "Delete",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          addMap(ipName,ipAdd);
                                          Navigator.of(context)
                                              .pop(ipNamecontroller.text);
                                          baseUrlList.clear();
                                        },
                                        child: const Text(
                                          "Add",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        style: const ButtonStyle(
                                          backgroundColor: MaterialStatePropertyAll(Colors.green),
                                        ),
                                      )
                                    ],
                                  ));
                        },
                      ),
                      DropdownButton<String>(
                        dropdownColor: Colors.blueAccent,
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white, // <-- SEE HERE
                        ),
                        value: dropdownValue,
                        items: getIpItems(),
                        onChanged: (String? newValue) async {
                          stationlist.clear();
                          productList.clear();
                          setState(() {
                            _isLoading = true;
                            dropdownValue = newValue;
                            base = newValue!;
                          });

                          getStationInfo();
                          getProductInfo();

                          // await Future.delayed(const Duration(seconds: 2));

                          print("Base is " + base);
                        },
                        hint: Text(
                          'Select an IP',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      _isLoading
                          ? LoadingAnimationWidget.threeArchedCircle(
                              color: Colors.white, size: 20)
                          : _ifError
                              ? Icon(
                                  Icons.close,
                                  color: Colors.red,
                                )
                              : Icon(
                                  Icons.check,
                                  color: Colors.green,
                                )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextButton(
                    style: TextButton.styleFrom(
                        shadowColor: Colors.white,
                        foregroundColor: Colors.white,
                        backgroundColor: kred,
                        minimumSize: const Size(200, 45)),
                    onPressed: () async {
                      setState(() {
                        _isLoginLoading = true;
                      });
                      serverInfobool = await checkServerResponse();
                      setState(() {
                        _isLoginLoading = false;
                      });
                      print(serverInfobool);
                      if (serverInfobool) {
                        print(widget.token);
                        if (widget.token != null) {
                          if (JwtDecoder.isExpired(widget.token) == false) {
                            isloggedin = true;

                            if (widget.stationName == 'station 1') {
                              // Navigator.pop(context);
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => FirstStation(empId: widget.empId.toString(),)),
                              );
                            } else {
                              // Navigator.pop(context);
                              // ignore: use_build_context_synchronously
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => ParamStation(
                                        stationName: widget.stationName,
                                        employeeId: widget.empId!)),
                              );
                            }
                          } else {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => const MyProfile()),
                            );
                          }
                        } else {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => const MyProfile()),
                          );
                        }
                      } else {
                        // ignore: use_build_context_synchronously
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
                                    'Cannot reach server !!',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.red),
                                  ),
                                ),
                              );
                            });
                      }
                    },
                    child: _isLoginLoading
                        ? LoadingAnimationWidget.threeArchedCircle(
                            color: Colors.white, size: 20)
                        : Text('Log In')),
                TextButton(
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.clear();
                    },
                    child: Text("Clear Pref"))
              ],
            ),
          ),
        ),
        // drawer: MyDrawer(),
        bottomNavigationBar: myFooter,
      ),
    );
  }
}
