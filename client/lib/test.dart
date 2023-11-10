import 'globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void getJobAtStation() async {
  final param = {'station_id': '123'};
  var res = json
      .decode((await http.get(Uri.http(base, getjobatstation, param))).body);
  print(res);
}

main() {
  // getJobAtStation();
  // print(Uri.http(base, postStationYYYY));
  // http.post(Uri.http(base, postInStationyyyyFirstNextStation),
  //     body: {"product_name": "OF14", "station_id": "123", "job_name": "B13"});
  DateTime now = new DateTime.now();
  DateTime date = new DateTime(now.year, now.month, now.day);
  var finaldate = date.toString().replaceAll("00:00:00.000", "");
  print(finaldate);

}
