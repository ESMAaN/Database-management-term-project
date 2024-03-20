import 'package:mysql1/mysql1.dart';

class Mysql {
  static String host = '10.0.2.2',
      user = 'root',
      db = 'dbms_proje';
  static int port = 3306;

  Mysql();

  Future<MySqlConnection> getConnection() async {
    var settings = ConnectionSettings(
      host: host,
      port: port,
      user: user,
      db: db,
    );
    return await MySqlConnection.connect(settings);
  }


  Future<List<Map<String, dynamic>>> getTheses() async {
    MySqlConnection conn = await getConnection();
    Results results = await conn.query('SELECT * FROM Thesis');
    await conn.close();

    return results.map((r) => Map<String, dynamic>.from(r.fields)).toList();
  }
}
