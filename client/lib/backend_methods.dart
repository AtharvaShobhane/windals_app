import 'package:http/http.dart' as http;
import 'dart:convert';

void getData() async {
  await http
      .get(Uri.parse('http://127.0.0.1:8080/api/ProductMasterGet'))
      .then((value) {
    var data = json.decode(value.body);
    print(data);
  });
}

void postData() {
  http.post(Uri.parse('http://127.0.0.1:8080/api/ProductMasterInsert'), body: {
    'productName': '0F15',
    'parameter': 'Radius',
    "minVal": '10',
    "maxVal": '20',
    "unit": '2'
  });
}
//
// main() {
//   getStationInfo('Station 1');
// }


//final methods
// void postvalue(String jobName , int status ){
//   http.post(Uri.parse('http://127.0.0.1:8080/api/ProductMasterInsert'),
//       body: {
//         'productName': jobName, 'status' : '1'
//       });
// }
// void postvalueParam(String jobName , int status , int param ){
//   http.post(Uri.parse('http://127.0.0.1:8080/api/ProductMasterInsert'),
//       body: {
//         'productName': jobName, 'status' : '1' , 'param':'10'
//       });
// }

//login_page_methods
void getEmployeeData() async {
  var res ;
  await http
      .get(Uri.parse('http://127.0.0.1:8080/api/EmployeeMasterGet') )
      .then((value) {
    var data = json.decode(value.body);
    // print(data);
    res = data;
  });
  print(res);
  return res;
}

void addemployee() {
  http.post(Uri.parse('http://127.0.0.1:8080/api/EmployeeMasterInsert'), body: {
    'designation': 'Worker',
    'emp_first_name': 'Ashok',
    'emp_last_name': 'Popat',
    'joining_date': '2008-11-11',
    'password': '1234'
  });
}

void getStationInfo(String stationName) async{
  final params = {'stationName' : stationName};
  var url = Uri.http('127.0.0.1:8080','/api/StationMasterGetOneStation',params);
  // var url = 'http://127.0.0.1:8080/api/StationMasterGetOneStation?stationName=Station+1';
  print(url);
  var res  = await http.get(url);
  var temp = json.decode(res.body);
  // print(temp[0]['station_name']);
  return temp;
}