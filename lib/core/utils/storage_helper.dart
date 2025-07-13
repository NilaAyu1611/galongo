import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageHelper {
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  // Simpan token
  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'authToken', value: token);
  }

  // Ambil token
  static Future<String?> getToken() async {
    return await _storage.read(key: 'authToken');
  }

  // Simpan nama dan username
  static Future<void> saveUserInfo({required String name, required String username}) async {
    await _storage.write(key: 'name', value: name);
    await _storage.write(key: 'username', value: username);
  }

  // Ambil nama
  static Future<String?> getName() async {
    return await _storage.read(key: 'name');
  }

  // Ambil username
  static Future<String?> getUsername() async {
    return await _storage.read(key: 'username');
  }

  // Hapus semua data (misal saat logout)
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}





























// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// class StorageHelper {
//   static final FlutterSecureStorage _storage = FlutterSecureStorage();

//   static Future<void> saveToken(String token) async {
//     await _storage.write(key: 'authToken', value: token);
//   }

//   static Future<String?> getToken() async {
//     return await _storage.read(key: 'authToken');
//   }

//   static Future<void> clearToken() async {
//     await _storage.delete(key: 'authToken');
//   }

//   static Future<void> clear() async {
//     await _storage.deleteAll();
//   }

//   static Future<void> saveUserInfo({
//     required String name,
//     required String username,
//   }) async {
//     await _storage.write(key: 'name', value: name);
//     await _storage.write(key: 'username', value: username);
//   }

//   static Future<String?> getUsername() async {
//     return await _storage.read(key: 'username');
//   }

//   static Future<String?> getName() async {
//     return await _storage.read(key: 'name');
//   }

//   static Future<void> clearAll() async {
//     await _storage.deleteAll();
//   }
// }
