import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:windals_final/screens/firstStation.dart';
import 'constants.dart';
import 'screens/station_1.dart';
import 'screens/myprofile.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // void sendmessage(String message) {
  //   print(message);
  //   WebSocketChannel channel;
  //
  //   try {
  //     channel = WebSocketChannel.connect(Uri.parse('http://127.0.0.1:8080/api/ProductMasterGet')); //url of local host
  //     channel.sink.add(message);
  //     channel.stream.listen((message) {
  //       print(message);
  //       channel.sink.close();
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: MyAppBar(title: "Windals"),
      // body: const Row(
      //   children: [
      //     //add main widgets
      //
      //   ],
      // ),
      body: Text('Home Page', style: TextStyle(fontSize: 30),),
      drawer: MyDrawer(),
      bottomNavigationBar: myFooter,
    );
  }
}
