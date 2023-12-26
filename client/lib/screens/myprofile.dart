// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:windals_final/constants.dart';
import 'package:windals_final/screens/firstStation.dart';
import 'package:windals_final/screens/homeScreen.dart';
import 'package:windals_final/screens/paramstation.dart';
import 'package:windals_final/screens/station_1.dart';
import 'package:windals_final/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:windals_final/screens/supervisorPage.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  //make text editing controller
  late TextEditingController controllerusername;
  late TextEditingController controllerpass;
  // late var token;

  int? employeeID;
  String? userName;
  String? password;
  bool isChecked = false;
  String dropdownValue = "Select Station";
  bool obscureText = true;
  late SharedPreferences pref;
  bool _isLoginLoader = false;
  late int currentShift;
  int position =0;

  @override
  void initState() {
    // getStationInfo();
    getCurrentShiftFunc();
    controllerusername = TextEditingController();
    controllerpass = TextEditingController();
    initSharedPref();
    super.initState();
  }

  void initSharedPref() async {
    pref = await SharedPreferences.getInstance();
  }

  @override
  void dispose() {
    controllerusername.dispose();
    controllerpass.dispose();
    super.dispose();
  }

  Future<String> loginMessage(String? userName, String? password) async {
    var mytoken;
    var req = await http.post(Uri.http(base, login),
        body: {"userName": userName, "password": password});
    var mssg = json.decode((req).body);
    print("----- login mssg -------");
    // print(mssg);
    setState(() {
      if (req.statusCode == 201) {
        employeeID = mssg['employeeId'];
        pref.setInt("employeeId", employeeID!);
        mytoken = mssg['token'];
        pref.setString('token', mytoken);
        print(employeeID);
        print("Token - " + mytoken);
        print(JwtDecoder.isExpired(mytoken));
      }
    });

    return mssg['msg'];
  }

  void getCurrentShiftFunc() async {
    var res = json.decode((await http.get(
      Uri.http(base, getCurrentShift),
    ))
        .body);
    currentShift = res['shift_id'];
    print("Current shift - $currentShift");
  }

  Future<List<String>> getStation(String? userName) async {
    //for todays date and time
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);
    var finaldate = date.toString().replaceAll("00:00:00.000", "");
    print(finaldate);
    List<String> workerStation=[];
    List<int> workerStationPos=[];
    var empStation = json.decode((await http.get(
      Uri.http(base, getOneWorkerStation, {
        'employeeId': "$employeeID",
        'date': finaldate,
        'shift': '$currentShift'
      }),
    ))
        .body);
    print("-----worker station-----");
    print("emp id - $employeeID");
    print(empStation);

    var msg;
    try {
      for(var i in empStation){
        workerStation.add(i['station_name']);
        // workerStationPos.add(i['position']);
      }
      msg = workerStation;
      return msg;
    } catch (e) {
      msg = empStation['msg'];
    }
    return [];
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: "Windals App"),
      // endDrawer: const MyDrawer(),
      bottomNavigationBar: myFooter,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(27.0, 0, 27.0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                // width: MediaQuery.sizeOf(context).width,
                height: 20.0,
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                // width: MediaQuery.sizeOf(context).width / 1.5,
                height: 170,
                child: Column(
                  children: [
                    Container(
                      height: 100,
                      child: Image.asset(
                        'assets/images/windals-logo-removebg.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Center(
                      child: Text(
                        "Welcome Back!",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 35,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Center(
                      child: Text(
                        "Login to your account.",
                        style: TextStyle(
                            color: kred,
                            fontSize: 15,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              const SizedBox(
                height: 18.0,
              ),
              TextField(
                controller: controllerusername,
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Icon(Icons.person_2),
                  ),
                  hintText: 'Username',
                  labelText: 'Username',
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(color: Colors.blueAccent, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(color: Colors.black, width: 1),
                  ),
                ),
                onChanged: (String? value) {
                  setState(() {
                    userName = value;
                  });
                },
              ),
              const SizedBox(
                height: 18.0,
              ),
              TextField(
                obscureText: obscureText,
                controller: controllerpass,
                decoration: InputDecoration(
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: IconButton(
                      icon: Icon(Icons.hide_source),
                      onPressed: () {
                        setState(() {
                          obscureText
                              ? obscureText = false
                              : obscureText = true;
                        });
                      },
                    ),
                  ),
                  // contentPadding: EdgeInsets.only(top: 20 ,bottom: 20,left: 40),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Icon(Icons.lock),
                  ),
                  hintText: 'Password',
                  labelText: 'Password',
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(color: Colors.blueAccent, width: 1),
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(color: Colors.black, width: 1),
                  ),
                ),
                onChanged: (String? value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
              //Dropdown removed
              // const SizedBox(
              //   height: 18.0,
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(left: 10, top: 10),
              //   child: const Text(
              //     "Working Station",
              //     style: TextStyle(
              //       fontSize: 20.0,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // ),
              // const SizedBox(
              //   height: 10.0,
              // ),

              // DropdownMenu<String>(
              //   inputDecorationTheme: InputDecorationTheme(
              //       contentPadding: EdgeInsets.only(left: 30),
              //       border: OutlineInputBorder(
              //           borderRadius: BorderRadius.circular(50))),
              //   width: 350,
              //   initialSelection: stationlist.first,
              //   onSelected: (String? value) {
              //     // This is called when the user selects an item.
              //     setState(() {
              //       dropdownValue = value!;
              //     });
              //   },
              //   dropdownMenuEntries: stationlist
              //       .map<DropdownMenuEntry<String>>((String value) {
              //     return DropdownMenuEntry<String>(
              //         value: value, label: value);
              //   }).toList(),
              // ),
              const SizedBox(
                height: 18.0,
              ),
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: 18.0,
              ),
              TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  foregroundColor: Colors.white,
                  backgroundColor: kred,
                  minimumSize: const Size(350, 45),
                ),
                onPressed: () async {
                  print(userName);
                  print(password);
                  print(dropdownValue);
                  // print(isChecked);
                  isloggedin = true;

                  print("-------- onpressed login --------");
                  setState(() {
                    _isLoginLoader = true;
                  });
                  getCurrentShiftFunc();
                  loginMessage(userName!, password!).then((mssg) async {
                    pref.setString("useName", userName!);
                    pref.setString("password", password!);
                    setState(() {
                      controllerpass.clear();
                      controllerusername.clear();
                      // userName = "";
                      // password = "";
                    });
                    if (mssg == "Done:Login successful") {
                      print("Login success !!");
                      List<String> stationNames = await getStation(userName!);
                      //insert in login log
                      for(var i in stationNames){
                        http.post(Uri.http(base, insertInLoginLog), body: {
                          'userName': userName,
                          'stationName': i,
                        });
                      }

                      bool isStationAllocated = false;
                      if(stationNames.length != 0)isStationAllocated=true;
                      setState(() {
                        _isLoginLoader = false;
                      });

                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => HomeScreen(stationName: stationNames, isStationAllocated: isStationAllocated , empId: employeeID!, userName : userName!)));

                    } else {
                      print("NO LOGIN!!");
                      showDialog(
                          barrierColor: Colors.transparent,
                          context: context,
                          builder: (context) {
                            Future.delayed(Duration(seconds: 3), () {
                              Navigator.of(context).pop(true);
                            });
                            return AlertDialog(
                              // backgroundColor: Colors.black12,
                              title: Text(
                                mssg as String,
                                style:
                                    TextStyle(fontSize: 14, color: Colors.red),
                              ),
                            );
                          });
                    }
                  });
                },
                child: _isLoginLoader
                    ? LoadingAnimationWidget.threeArchedCircle(
                        color: Colors.white, size: 20)
                    : Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
              // ElevatedButton(
              //     onPressed: () {
              //       //supervisor page
              //       Navigator.push(
              //           context,
              //           CupertinoPageRoute(
              //             builder: (context) => SupervisorPage(),
              //           ));
              //     },
              //     child: Text("Supervisor Page")),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'Press BACK for Home Screen',
                  style: TextStyle(fontSize: 11),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
