class AppConstant {
  static const String BASE_URL = "http://rxfarm91.cse.buffalo.edu:5001/api/";

  static const String BUSINESS_SIGNUP = BASE_URL + "bussiness-sign-up";

  static const String SIGNUP = BASE_URL + "sign-up";

  static const String SIGNIN = BASE_URL + "sign-in";

  static const String REQ_TEMP_PASS = "business_login";

  //Users
  static const String USERS_GET_BY_ID = "business_login";

  static const String USERS_GET_INFO = "business_login";

  //Business

  static const String GET_BUSINESS_STAFF = "business_login";
  static const String BUSINESS_POST_INFO = "business_login";

  static const String BUSINESS_GET_INFO = "business_login";

  static const String BUSINESS_GET_OWNED_BUSINESS = "business_login";

  static String GET_ALL_BUSINESS(date) => "business?startDate=$date";

  static String getBusinessAvailabilityByDate(id, date) =>
      BASE_URL + "business/bId=$id&startDate=$date";

  static String updateBusinessAvailabilityByDate(id, date) =>
      BASE_URL + "business/bId=$id";

  static const pictureUpload = BASE_URL + "file";

  static const ADD_SERVICE = BASE_URL + "business-services";

  static GET_SERVICE_BY_BID(id) => BASE_URL + "business-services?bId=$id";

  static GET_SERVICE_BY_ID(id) => BASE_URL + "business-services?bId=$id";

  static String getBusinessById(id) => BASE_URL + "business/$id";
  //staff
  static const String GET_STAFF_BY_BUSINESS_ID = "business_login";

  static const String POST_STAFF_BY_BUSINESS_ID = "business_login";

  static getBusinessStaffByID(bussinessID, staffID) => "business_login";

  static updateBusinessStaffByID(bussinessID, staffID) => "business_login";

  static deleteBusinessStaffByID(bussinessID, staffID) => "business_login";

  static getStaffByID(staffID) => "business_login";

  static updateStaffByID(staffID) => "business_login";

  static deleteStaffByID(staffID) => "business_login";

  //Appointment
  static const POST_APPOINTMENT = "business_login";

  static const BOOK_APPOINTMENT = BASE_URL + "appointments/book";

  static getUserAppointmentByID(id) => BASE_URL + "appointments?uId=$id";
  static getBusinessAppointmentByID(id) => BASE_URL + "appointments?bId=$id";

  static updateAppointmentByID(id) => BASE_URL + "appointments/$id";

  static deleteAppointmentByID(id) => BASE_URL + "appointments/$id";

  //Business Hours

  static const POST_BUSINESS_HOURS = "business_login";

  static const GET_BUSINESS_HOURS = "business_login";
  static getBusinessHoursByID(id) => BASE_URL + "business_hours?bId=$id";

  static updateBusinessHoursByID(id) => "business_login";

  static deleteBusinessHoursByID(id) => "business_login";

  //Business Services

  static const POST_BUSINESS_SERVICES = "business_login";

  static const GET_BUSINESS_SERVICES = "business_login";

  static getBusinessServicesByID(id) => "business_login";

  static updateBusinessServicesByID(id) => "business_login";

  static deleteBusinessServicesByID(id) => "business_login";
}
