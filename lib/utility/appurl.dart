class AppConstant {
  static const String baseUrl = "http://";

  static const String BUSINESS_SIGNUP = "business_signup";

  static const String SIGNUP = "business_login";

  static const String SIGNIN = "business_login";

  static const String REQ_TEMP_PASS = "business_login";

  //Users
  static const String USERS_GET_BY_ID = "business_login";

  static const String USERS_GET_INFO = "business_login";

  //Business

  static const String BUSINESS_POST_INFO = "business_login";

  static const String BUSINESS_GET_INFO = "business_login";

  static const String BUSINESS_GET_OWNED_BUSINESS = "business_login";

  static const String GET_STAFF_BY_BUSINESS_ID = "business_login";

  static const String POST_STAFF_BY_BUSINESS_ID = "business_login";

  static getBusinessStaffByID(bussinessID, staffID) => "business_login";

  static updateBusinessStaffByID(bussinessID, staffID) => "business_login";

  static deleteBusinessStaffByID(bussinessID, staffID) => "business_login";

  static getStaffByID(staffID) => "business_login";

  static updateStaffByID(staffID) => "business_login";

  static deleteStaffByID(staffID) => "business_login";

  static const POST_APPOINTMENT = "business_login";

  static const GET_APPOINTMENT = "appointment";

  static getAppointmentByID(id) => "business_login";

  static updateAppointmentByID(id) => "business_login";

  static deleteAppointmentByID(id) => "business_login";

  static const POST_APPOINTMENT_BOOK = "business_login";

  //Business Hours

  static const POST_BUSINESS_HOURS = "business_login";

  static const GET_BUSINESS_HOURS = "business_login";

  static getBusinessHoursByID(id) => "business_login";

  static updateBusinessHoursByID(id) => "business_login";

  static deleteBusinessHoursByID(id) => "business_login";

  //Business Services

  static const POST_BUSINESS_SERVICES = "business_login";

  static const GET_BUSINESS_SERVICES = "business_login";

  static getBusinessServicesByID(id) => "business_login";

  static updateBusinessServicesByID(id) => "business_login";

  static deleteBusinessServicesByID(id) => "business_login";
}
