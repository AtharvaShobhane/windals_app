import 'package:flutter/material.dart';
import 'package:windals_final/constants.dart';

class ExpansionPanelDemo extends StatefulWidget {
  const ExpansionPanelDemo({super.key});
  @override
  _ExpansionPanelDemoState createState() => _ExpansionPanelDemoState();
}

class _ExpansionPanelDemoState extends State<ExpansionPanelDemo> {
  List<Item> _books = generateItems(8);

  late TextEditingController controller;
  @override
  void initState(){
    super.initState();
    controller = TextEditingController();
  }
  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          // width: 350,
          padding: const EdgeInsets.only(top: 20),
          child: _buildPanel(),
        ),
      ),
    );
  }

  Widget _buildPanel() {

    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _books[index].isExpanded = !isExpanded;
        });
      },
      children: _books.map<ExpansionPanel>((Item item) {
        return ExpansionPanel(
          canTapOnHeader: true,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(item.headerValue),
            );
          },
          body:  ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
               const Icon(
                  Icons.check_rounded,
                  color: Colors.green,
                  size: 24.0,
                  semanticLabel: 'Text to announce in accessibility modes',
                ),
                IconButton(
                  onPressed: () async {
                    setState(() {
                      _books.removeWhere(
                          (Item currentItem) => item == currentItem);
                    });
                    //reason text
                    final rejectReasonText  = await opendialog();
                    print("Reject Reason -- $rejectReasonText");
                  },
                  icon: const Icon(
                    Icons.clear_rounded,
                    color: Colors.red,
                    size: 30.0,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    setState(() {
                      _books.removeWhere(
                              (Item currentItem) => item == currentItem);
                    });
                    //
                    final reworkReasonText  = await opendialog();
                    print("Rework Reason -- $reworkReasonText");
                  },
                  icon: const Icon(
                    Icons.redo,
                    color: Colors.orange,
                    size: 30.0,
                  ),
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
      builder: (context) =>  AlertDialog(
        title: const Text("Reason"),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(hintText: "Type your reason"),
        ),
        actions: [TextButton(onPressed: submit, child: const Text("Submit" , style: TextStyle(color:kred),))],
      ));
  void submit(){
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

List<Item> generateItems(int numberOfItems) {
  return List.generate(numberOfItems, (int index) {
    return Item(
      headerValue: 'Book $index',
      expandedValue: 'Details for Book $index goes here',
    );
  });
}
