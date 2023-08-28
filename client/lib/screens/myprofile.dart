import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:windals_final/constants.dart';
import 'package:windals_final/screens/firstStation.dart';
import 'package:windals_final/screens/station_1.dart';
import 'package:windals_final/globals.dart';

const List<String> stationlist = ['Station 1', 'Station 2'];

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  //make text editing controller
  late TextEditingController controllerid;
  late TextEditingController controllerpass;


  String? employeeId;
  String? password;
  bool isChecked = false;
  String dropdownValue = stationlist.first;
  @override
  void initState() {
    controllerid = TextEditingController();
    controllerpass = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    controllerid.dispose();
    controllerpass.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return isloggedin ? dropdownValue == 'Station 1' ? FirstStation() : Station1()  : Scaffold(
      appBar: MyAppBar(title: "My Profile"),
      endDrawer: const MyDrawer(),
      bottomNavigationBar: myFooter,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(27.0, 0, 27.0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: 20.0,
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                width: MediaQuery.sizeOf(context).width / 1.5,
                height: 55,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAEAEA),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Center(
                  child: Text(
                    "Login Page",
                    style: TextStyle(
                        color: kred, fontSize: 25, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              const Text(
                "Username / Id",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 18.0,
              ),
              TextField(
                controller: controllerid,
                decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent, width: 1),
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1),
                  ),
                ),
                onChanged: (String? value) {
                  employeeId = value;
                },
              ),
              const SizedBox(
                height: 20.0,
              ),
              const Text(
                "Password",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 18.0,
              ),
              TextField(
                controller: controllerpass,
                decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent, width: 1),
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1),
                  ),
                ),
                onChanged: (String? value) {
                  password = value;
                },
              ),
              const SizedBox(
                height: 18.0,
              ),
              const Text(
                "Working Station",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 18.0,
              ),
              DropdownMenu<String>(
                width: 300,
                initialSelection: stationlist.first,
                onSelected: (String? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    dropdownValue = value!;
                  });
                },
                dropdownMenuEntries:
                stationlist.map<DropdownMenuEntry<String>>((String value) {
                  return DropdownMenuEntry<String>(value: value, label: value);
                }).toList(),
              ),
              const SizedBox(
                height: 18.0,
              ),
              Row(
                children: [
                  // CheckBox pending
                  Checkbox(
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value!;
                        });
                      }),
                  // Admin label
                  const Text(
                    "Admin",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                height: 18.0,
              ),
              Center(
                child: TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: kred,
                      minimumSize: const Size(270, 45)),
                  onPressed: () {
                    print(employeeId);
                    print(password);
                    print(dropdownValue);
                    print(isChecked);
                    isloggedin = true;
                    if(dropdownValue == 'Station 1'){
                      // Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        CupertinoPageRoute(builder: (context) => FirstStation()),);
                    }else{
                      // Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        CupertinoPageRoute(builder: (context) => Station1()),);
                    }

                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
