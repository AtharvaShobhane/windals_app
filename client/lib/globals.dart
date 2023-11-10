

bool isloggedin = false;
bool isParam = false;
String base = '';
// var token  = "";

//lists
List<String> stationlist = [];
List<String> productList = [];
List<String> jobNames = [];

//atharva laptop
// String base = '192.168.137.1:8080';
//cllg computer
// String base = '172.16.21.44:8080';

//get
String stationMasterGet = '/api/StationMasterGet';
String getOneStation = '/api/StationMasterGetOneStation';
String productMasterGet = '/api/ProductMasterGet';
String getjobatstation = '/api/StationyyyyShowJob';
String getStationIdStationName = "/api/MobileStationMasterGetOneStationOneProduct";
String getCurrentShift = "/api/ShiftConfigGetCurrentShift";

//post
String postStationYYYY = '/api/StationyyyyInsertFirst';
String postInStationyyyyFirstNextStation = '/api/StationyyyyInsertFirstNextStation';
String postProductyyyy = '/api/ProductyyyyInsert';
String getCountAtStation = "/api/StationyyyyGetCountOfWorkAtStation";
String login = "/api/login";
String getOneWorkerStation = "/api/getOneWorkerStation";
String insertInLoginLog = "/api/loginLogInsert";

//put
String updateStationyyyy = '/api/Stationyyyyupdate';


