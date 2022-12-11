import 'dart:convert';

import 'package:wepostexpress/utils/errors/my_error.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  final SharedPreferences _sharedPreferences;

  CacheHelper(this._sharedPreferences);

  Future<bool> has(String key) async {
    final bool f = await _basicErrorHandling(() async {
      return _sharedPreferences.containsKey(key) && _sharedPreferences.getString(key).isNotEmpty;
    });
    return f;
  }

  Future<bool> clear(String key) async {
    final bool f = await _basicErrorHandling(() async {
      return await _sharedPreferences.remove(key);
    });
    return f;
  }

  Future get(String key) async {
    final f = await _basicErrorHandling(() async {
      if (await has(key)) {
        return await jsonDecode(_sharedPreferences.getString(key));
      }
      return null;
    });
    return f;
  }

  Future<bool> put(String key, dynamic value) async {
    final bool f = await _basicErrorHandling(() async {
      return await _sharedPreferences.setString(key, jsonEncode(value));
    });
    return f;
  }
}

extension on CacheHelper {
  Future<T> _basicErrorHandling<T>(Future<T> onSuccess()) async {
    try {
      final f = await onSuccess();
      return f;
    } catch (e) {
      print(e);
      throw MyError(e.toString());
    }
  }
}
