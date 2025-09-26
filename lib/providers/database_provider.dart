import 'package:flutter_repkeep/db/database_helper.dart';

class DatabaseService {
  /// Test koneksi ke database
  Future<bool> testConnection() async {
    try {
      final db = await DatabaseHelper.instance.database; // ambil instance DB
      final result = await db.rawQuery('SELECT 1'); // query sederhana
      print("[DEBUG] DB connection successful: $result");
      return true;
    } catch (e, stackTrace) {
      print("[ERROR] DB connection failed: $e");
      print(stackTrace);
      return false;
    }
  }
}
