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

  static getBusiness(bId) => BASE_URL + "business/$bId";

  static const PICTURE_ASSET_PATH =
      'http://rxfarm91.cse.buffalo.edu:5001/assets';
  static const PICTURE_UPLOAD = BASE_URL + "file";

  static const String BUSINESS_POST_INFO = "business_login";

  static const String BUSINESS_GET_INFO = "business_login";

  static const String BUSINESS_GET_OWNED_BUSINESS = "business_login";

  static String GET_ALL_BUSINESS(date) => "business?startDate=$date";

  static String getBusinessAvailabilityByDate(id, date) =>
      BASE_URL + "business/bId=$id&startDate=$date";

  static String updateBusinessAvailabilityByDate(id, date) =>
      BASE_URL + "business/bId=$id";

  //Services
  static const BUSINESS_SERVICES = BASE_URL + "business-services";
  static updateBusinessService(bId) => BASE_URL + "business-services/$bId";
  static getBusinessService(bId) => BASE_URL + "business-services?bId=$bId";
  static getBusinessServiceById(serviceId) =>
      BASE_URL + "business-services/$serviceId";

  static deleteBusinesssHourById(bId, sId) =>
      BASE_URL + "business-services/$bId/$sId";
  static GET_SERVICE_BY_ID(id) => BASE_URL + "business-services?bId=$id";

  static String getBusinessById(id) => BASE_URL + "business/$id";
  //staff
  static const String GET_STAFF_BY_BUSINESS_ID = "business_login";

  static addBusinessStaff(bId) => BASE_URL + 'business/$bId/staff';
  static getBusinessStaff(bId) => BASE_URL + 'business/$bId/staff';
  static deleteBusinessStaff(bId, sId) =>
      BASE_URL + 'business/$bId/staff/$sId/delete';
  static getBusinessStaffByID(bId, staffId) => "business/$bId/staff/$staffId";

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

  static const BUSINESS_HOURS = BASE_URL + "businness-hours";

  static getBusinesssHourById(bId) => BASE_URL + "businness-hours?bId=$bId";

  static updateBusinessHoursByID(id) => "business_login";

  static deleteBusinessHoursByID(id) => "business_login";

  //Business Services

  static const POST_BUSINESS_SERVICES = "business_login";

  static const GET_BUSINESS_SERVICES = "business_login";

  static getBusinessServicesByID(id) => "business_login";

  static updateBusinessServicesByID(id) => "business_login";

  static deleteBusinessServicesByID(id) => "business_login";
}
