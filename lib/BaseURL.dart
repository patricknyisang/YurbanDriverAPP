class BaseURL {
 static const String BASE_URL = "http://127.0.0.1:8000";


  static const String   COUNTIES = "$BASE_URL/api/fetchcounties";
  static const String   CONSTITUENCIES = "$BASE_URL/api/fetchconstituencies";
    static const String   REGISTER_DRIVER = "$BASE_URL/api/registerdriver";
  static const String   LOGIN = "$BASE_URL/api/logindriver";
 static const String   REGISTER_REQUESTRIDE = "$BASE_URL/api/login";
 static const String   GETMYRIDES = "$BASE_URL/api/fetchdriversride";
 static const String   ONLINESTATUS = "$BASE_URL/api/updateonline";
 
static const String   OFFLINESTATUS = "$BASE_URL/api/updateoffline";
static const String   REQUESTRIDES = "$BASE_URL/api/fetchcostomersrequest";
static const String   UPDATEDRIVERACCEPT = "$BASE_URL/api/acceptride";
static const String   UPDATEDRIVEREJECT = "$BASE_URL/api/rejectride";
  

 

  }