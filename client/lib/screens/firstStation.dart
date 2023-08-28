import 'package:flutter/material.dart';
import 'package:windals_final/constants.dart';

const List<String> productList = ['Product 1', 'Product 2'];

class FirstStation extends StatefulWidget {
  const FirstStation({super.key});

  @override
  State<FirstStation> createState() => _FirstStationState();
}

class _FirstStationState extends State<FirstStation> {
  late TextEditingController controllerjobname;
  String? jobName;
  String? selecteProduct;
  String? employeeId;
  int? stationId;
  @override
  void initState() {
    super.initState();
    controllerjobname = TextEditingController();
  }

  @override
  void dispose() {
    controllerjobname.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'Windals',
      ),
      endDrawer: MyDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              "First Station",
              style: kheading1,
            ),
          ),
          SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: 60,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
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
          Padding(
            padding: const EdgeInsets.only(bottom: 20, top: 40),
            child: Text(
              "Select Product - ",
              style: kheading2,
            ),
          ),
          DropdownMenu<String>(
            width: MediaQuery.sizeOf(context).width / 1.25,
            initialSelection: productList.first,
            onSelected: (String? value) {
              // This is called when the user selects an item.
              setState(() {
                selecteProduct = value!;
              });
            },
            dropdownMenuEntries:
                productList.map<DropdownMenuEntry<String>>((String value) {
              return DropdownMenuEntry<String>(value: value, label: value);
            }).toList(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 60),
            child: TextButton(
                style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: kred,
                    minimumSize: const Size(270, 45)),
                onPressed: () {},
                child: Text(
                  'Add Job',
                  style: TextStyle(
                    fontSize: 18
                  ),
                )),
          )
        ],
      ),
    );
  }
}
