
import 'package:shared_preferences/shared_preferences.dart';

abstract class CacheHelper {
  //init shared pref
  static Future<SharedPreferences> initSharedPref() async {
    return await SharedPreferences.getInstance();
  }

//set
  static Future<bool> setData(
      {required String key, required double data}) async {
    var sharedPref = await initSharedPref();
    return await sharedPref.setDouble(key, data);
  }
  //get

  static dynamic getData({required String key}) async {
    var sharedPref = await initSharedPref();

    return sharedPref.get(key);
  }
}
