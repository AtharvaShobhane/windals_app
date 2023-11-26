import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/station_1.dart';
import 'screens/myprofile.dart';
import 'main.dart';
import 'globals.dart';


// text style
const kheading1 = TextStyle(
  fontSize: 30,
  fontWeight: FontWeight.w700,
  color: kred,
);
const kheading2 = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w500,
);
//constant strings
String kapp_bar_text = 'Windals';

//colors
const kred = Color(0xFFEB1B24);
const kgrey = Color(0xFF474747);
const kdarkblue = Color(0xff1d3557);

Map<String, int> stations = {"Station 1": 1, "Station 1": 3};

//custom widgets
class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  MyAppBar({required this.title});
  String title;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Container(child: Image.asset('assets/images/windals-logo-removebg.png') , margin: EdgeInsets.only(left: 10),),
      title: Text(
        title,
        style: const TextStyle(
            fontFamily: 'Poppins', fontSize: 22, fontWeight: FontWeight.w600),
      ),
      backgroundColor: kdarkblue,
      actions: <Widget>[
        if(isloggedin)IconButton(
            onPressed: () async {
              SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              await prefs.clear();
              isloggedin = false;
              isParam = false;
              isdonefirstStation = false;
              // token = "";
              jobNames.clear();
              machineList.clear();
              // Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (BuildContext context) => const MyProfile()),(route) => false
              );

            },
            icon: Icon(Icons.logout)),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

const myFooter = BottomAppBar(
  color: kgrey,
  elevation: 1,
  height: 40,
  child: Center(
      child: Text(
    'Vishwakarma Institute Of information Technology',
    style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
  )),
);

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: kred,
            ),
            child: Text(
              'Drawer Header',
              style: TextStyle(color: Colors.white),
            ),
          ),
          ListTile(
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => const MyHomePage()),
              );
            },
          ),
          ListTile(
            title: const Text('My Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => const MyProfile()),
              );
            },
          ),
          ListTile(
            title: const Text('My Station'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => Station1()),
              );
            },
          ),
        ],
      ),
    );
  }
}


//custom text field
class MyTextField extends StatefulWidget {
  MyTextField({super.key , required TextEditingController controller , required String textValue});
  TextEditingController? controller;
  String? textValue;
  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width / 1.25,
      child: TextField(
        controller: widget.controller,
        decoration: const InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1.5),
          ),
        ),
        onChanged: (String? value) {
          widget.textValue = value;
        },
      ),
    );
  }
}
