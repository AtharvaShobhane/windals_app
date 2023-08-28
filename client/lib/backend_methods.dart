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
  http.post(Uri.parse('http://127.0.0.1:8080/api/ProductMasterInsert'),
      body: {
        'productName': '0F15', 'parameter' : 'Radius', "minVal":'10', "maxVal":'20', "unit":'2'
      });
}

main() {
  postData();
  getData();
}

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