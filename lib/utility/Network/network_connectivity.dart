import 'package:connectivity_plus/connectivity_plus.dart';

class CheckConnectivity {
  static Future<bool> checkInternet() async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile) {
        return true;
      } else if (connectivityResult == ConnectivityResult.wifi) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }

    //    try {
    //     http.Response response = await http.get(Uri.parse('https://google.com'));
    //     if (response.statusCode == 200)
    //       return true;
    //     else
    //       return false;
    //   } on SocketException catch (e) {
    //     throw Exception('Internet Issue');
    //   } catch (e) {
    //     throw Exception('Error Occurred ${e.toString().substring(0, 15)}');
    //   }
    // }
  }
}
