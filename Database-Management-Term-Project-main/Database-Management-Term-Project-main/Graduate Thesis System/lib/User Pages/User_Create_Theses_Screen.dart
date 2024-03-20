import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mysql1/mysql1.dart';

import '../Database_connection/Mysql.dart';
import 'User_Screen.dart';

class CreateTheses extends StatefulWidget {
  const CreateTheses({super.key, required this.username, required this.password});
  final String username;
  final String password;

  @override
  State<CreateTheses> createState() => _CreateThesesState();
}

class _CreateThesesState extends State<CreateTheses> {
  TextEditingController _theseTitledController = TextEditingController();
  TextEditingController _theseAbstractController = TextEditingController();
  TextEditingController _theseSupervisorConrtoller = TextEditingController();
  TextEditingController _theseCoSupervisorConrtoller = TextEditingController();
  TextEditingController _theseYearController = TextEditingController();
  TextEditingController _UniversityNameController = TextEditingController();
  TextEditingController _instituteNameController = TextEditingController();
  TextEditingController _theseNumberOfPagesController = TextEditingController();

  List<String> thesType = [ "Master", "Doctorate", "Specialization in Madicine", "Proficiency in Art"];
  String? selectedThesType = "Master";

  List<String> Language = ["Turkish", "English", "France","Dutch"];
  String? selectedLanguage = "Turkish";

  DateTime now = DateTime.now().toUtc();

  var author_Id;
  var maxThesNo;
  var csv_Id;
  var sv_Id;
  var uni_Id;
  var ins_Id;
  int deneme = 2;
  int insId = 111;

  void _coSupervisor() async {
    Mysql mysql = Mysql();
    MySqlConnection conn = await mysql.getConnection();

    try {
      // co_supervisor ekleniyor
      await conn.query(
        'INSERT INTO co_supervisor (CSV_NAME) VALUES (?)',
        [_theseCoSupervisorConrtoller.text],
      );

      // Eklenen co_supervisor'un CSV_ID değeri geri döndürülüyor
      var result = await conn.query(
        'SELECT LAST_INSERT_ID() as CSV_ID',
      );

      if (result.isNotEmpty) {
        csv_Id = result.first['CSV_ID']; // csv_Id doğrudan int olarak alınıyor
        print('Eklenen co_supervisor\'un CSV_ID değeri: $csv_Id');
        _supervisor();
      } else {
        print('Hata: CSV_ID alınamadı.');
      }

    } catch (e) {
      print('Hata: $e');
    } finally {
      await conn.close();
    }
  }

  void _supervisor() async {
    Mysql mysql = Mysql();
    MySqlConnection conn = await mysql.getConnection();

    try {
      // co_supervisor ekleniyor
      await conn.query(
        'INSERT INTO supervisor (SV_NAME) VALUES (?)',
        [_theseSupervisorConrtoller.text],
      );

      var result = await conn.query(
        'SELECT LAST_INSERT_ID() as SV_ID',
      );

      if (result.isNotEmpty) {
        sv_Id = result.first['SV_ID'];
        print('Eklenen supervisor\'un SV_ID değeri: $sv_Id');
        _uni();
      } else {
        print('Hata: SV_ID alınamadı.');
      }

    } catch (e) {
      print('Hata: $e');
    } finally {
      await conn.close();
    }
  }

  void _uni() async {
    Mysql mysql = Mysql();
    MySqlConnection conn = await mysql.getConnection();

    try {
      // co_supervisor ekleniyor
      await conn.query(
        'INSERT INTO university (UNI_NAME) VALUES (?)',
        [_UniversityNameController.text],
      );

      var result = await conn.query(
        'SELECT LAST_INSERT_ID() as UNI_ID',
      );

      if (result.isNotEmpty) {
        uni_Id = result.first['UNI_ID'];
        print('Eklenen supervisor\'un UNI_ID değeri: $uni_Id');
        _institute();
      } else {
        print('Hata: UNI_ID alınamadı.');
      }

    } catch (e) {
      print('Hata: $e');
    } finally {
      await conn.close();
    }
  }

  void _institute() async {
    Mysql mysql = Mysql();
    MySqlConnection conn = await mysql.getConnection();

    try {
      // co_supervisor ekleniyor
      await conn.query(
        'INSERT INTO institute (INS_NAME, UNI_ID) VALUES (?, ?)',
        [_instituteNameController.text, uni_Id],
      );

      var result = await conn.query(
        'SELECT LAST_INSERT_ID() as INS_ID',
      );

      if (result.isNotEmpty) {
        ins_Id = result.first['INS_ID'];
        print('Eklenen institute\'un INS_ID değeri: $ins_Id');
        _createNewThesis();
      } else {
        print('Hata: INS_ID alınamadı.');
      }

    } catch (e) {
      print('Hata: $e');
    } finally {
      await conn.close();
    }
  }



  Future<bool> _onWillPop() async {
    return (await Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => Builder(builder: (_) => UserScreen(username: widget.username, password: widget.password),
            )
        ),
        ModalRoute.withName('/')) );
  }

  void _getMaxThesisNo() async {
    Mysql mysql = Mysql();
    MySqlConnection conn = await mysql.getConnection();

    try {
      Results results = await conn.query(
        'SELECT MAX(THES_NO) AS max_thes_no FROM Thesis',
      );

      if (results.isNotEmpty) {
         setState(() {
           maxThesNo = results.first['max_thes_no'] +1;
         });
        print('En büyük THES_NO değeriİİİİİİİİİİİİİİİİ: $maxThesNo');
      } else {
        print('Thesis tablosunda hiç tez bulunamadı.');
      }
    } catch (e) {
      print('Hata: $e');
    } finally {
      await conn.close();
    }
  }


  void _getUserId() async {
    Mysql mysql = Mysql();
    MySqlConnection conn = await mysql.getConnection();

    try {
      Results results = await conn.query(
        'SELECT AUTHOR_ID FROM Author WHERE AUTHOR_NAME = ? AND AUTHOR_PASSWORD = ?',
        [widget.username, widget.password],
      );

      // Eğer sonuçlar varsa ve sadece bir satır döndüyse
      if (results.isNotEmpty) {
       setState(() {
         author_Id = results.first['AUTHOR_ID'];
       });

        print('User ID: $author_Id');
      } else {
        print('Kullanıcı bulunamadı.');
      }
    } catch (e) {
      print('Hata: $e');
    } finally {
      await conn.close();
    }
  }


// _createNewThesis metodu içinde kullanılacak kısım
  void _createNewThesis() async {
    Mysql mysql = Mysql();
    MySqlConnection conn = await mysql.getConnection();

    try {
      // Şu anki tarih ve saat değerini UTC formatında al
      DateTime now = DateTime.now().toUtc();
      // UTC formatındaki tarih/saat değerini MySQL'ye eklemek için kullanılabilir
      String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

      await conn.query(
        'INSERT INTO Thesis (THES_TITLE, THES_ABS, AUTHOR_ID, CSV_ID, THES_YEAR, THES_TYPE, UNI_ID, INS_ID, THES_NOP, LANG_NAME, THES_SUBDATE) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
        [
          _theseTitledController.text,
          _theseAbstractController.text,
          author_Id,
          csv_Id,
          _theseYearController.text,
          selectedThesType.toString(),
          uni_Id,
          ins_Id,
          _theseNumberOfPagesController.text,
          selectedLanguage.toString(),
          formattedDate, // UTC formatındaki tarih/saat değeri
        ],
      );

      print('Yeni tez oluşturuldu CSV_İD = $csv_Id.  SV_İD = $sv_Id.');
      _thes_SV();
    } catch (e) {
      print('Hata: $e');
    } finally {
      await conn.close();
    }
  }

  void _thes_SV() async {
    Mysql mysql = Mysql();
    MySqlConnection conn = await mysql.getConnection();

    try {
      // co_supervisor ekleniyor
      await conn.query(
        'INSERT INTO thes_sv (SV_ID, THES_NO) VALUES (?, ?)',
        [sv_Id, maxThesNo],
      );

      var result = await conn.query(
        'SELECT LAST_INSERT_ID() as INS_ID',
      );

      if (result.isNotEmpty) {
        print('Eklenen institute\'un thes_sv değeri');
        _updateThesisDeneme();
      } else {
        print('Hata: thes_sv alınamadı.');
      }

    } catch (e) {
      print('Hata: $e');
    } finally {
      await conn.close();
    }
  }

  Future<void> _updateThesisDeneme() async {
    Mysql mysql = Mysql();
    MySqlConnection conn = await mysql.getConnection();

    try {
      await conn.query('''
      UPDATE ThesisDeneme td
      JOIN Thesis t ON td.THES_NO = t.THES_NO
      JOIN Thes_SV tsv ON t.THES_NO = tsv.THES_NO
      JOIN Supervisor s ON tsv.SV_ID = s.SV_ID
      JOIN Co_Supervisor csv ON t.CSV_ID = csv.CSV_ID
      JOIN Author a ON t.AUTHOR_ID = a.AUTHOR_ID
      JOIN University u ON t.UNI_ID = u.UNI_ID
      JOIN Institute i ON t.INS_ID = i.INS_ID
      JOIN Language l ON t.LANG_NAME = l.LANG_NAME
      SET
          td.THES_TITLE = t.THES_TITLE,
          td.THES_ABS = t.THES_ABS,
          td.AUTHOR_NAME = a.AUTHOR_NAME,
          td.CSV_NAME = csv.CSV_NAME,
          td.SV_NAME = s.SV_Name,
          td.THES_YEAR = t.THES_YEAR,
          td.THES_TYPE = t.THES_TYPE,
          td.UNI_NAME = u.UNI_Name,
          td.INS_NAME = i.INS_Name,
          td.THES_NOP = t.THES_NOP,
          td.LANG_NAME = l.LANG_NAME,
          td.THES_SUBDATE = t.THES_SUBDATE;
    ''');
      print('ThesisDeneme table updated successfully.');
    } catch (e) {
      print('Error updating ThesisDeneme table: $e');
    } finally {
      await conn.close();
    }
  }






  @override
  void initState() {
   _getUserId();
   _getMaxThesisNo();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Create Theses"),
        ),
        body: Center(
          child: ListView(
            children: [


              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Container(
                  color: Color(0xffe0d4d6),
                  child: TextField(
                    controller: _theseTitledController,
                    decoration: InputDecoration(
                      labelText: '  Enter These Title *',
                    ),
                    maxLines: 2,
                  ),
                ),
              ),


              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Container(
                  color: Color(0xffe0d4d6),
                  child: TextField(
                    controller: _theseAbstractController,
                    decoration: InputDecoration(
                      labelText: '  Enter These Abstract *',
                    ),
                    maxLines: 5,
                  ),
                ),
              ),


              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Container(
                  color: Color(0xffe0d4d6),
                  child: TextField(
                    controller: _theseSupervisorConrtoller,
                    decoration: InputDecoration(
                      labelText: '  Enter Supervisor Name *',
                    ),
                  ),
                ),
              ),



              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Container(
                  color: Color(0xffe0d4d6),
                  child: TextField(
                    controller: _theseCoSupervisorConrtoller,
                    decoration: InputDecoration(
                      labelText: '  Enter Co-Supervisor Name',
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Container(
                  color: Color(0xffe0d4d6),
                  child: TextField(
                    controller: _theseYearController,
                    decoration: InputDecoration(
                      labelText: '  Enter Year *',
                    ),
                  ),
                ),
              ),

              Padding(
                padding:  EdgeInsets.fromLTRB(0, 15, 0, 10),
                child: Column(
                  children: [
                    Text("These Type"),
                    DropdownButton(
                      alignment: Alignment.center,
                      value: selectedThesType,
                      items : thesType
                          .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Center(child: Text(item,style: TextStyle(fontSize: 20))),
                      )).toList(),
                      onChanged: (item) {
                        setState(() {
                          selectedThesType = item;
                          print("Type = $selectedThesType");
                        });
                      },
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Container(
                  color: Color(0xffe0d4d6),
                  child: TextField(
                    controller: _UniversityNameController,
                    decoration: InputDecoration(
                      labelText: '  Enter University Name *',
                    ),
                  ),
                ),
              ),




              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Container(
                  color: Color(0xffe0d4d6),
                  child: TextField(
                    controller: _instituteNameController,
                    decoration: InputDecoration(
                      labelText: '  Enter Institute Name *',
                    ),
                    maxLines: 2,
                  ),
                ),
              ),


              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Container(
                  color: Color(0xffe0d4d6),
                  child: TextField(
                    controller: _theseNumberOfPagesController,
                    decoration: InputDecoration(
                      labelText: '  Enter How Many Page *',
                    ),
                  ),
                ),
              ),

              Padding(
                padding:  EdgeInsets.fromLTRB(0, 15, 0, 10),
                child: Column(
                  children: [
                    Text("Language"),
                    DropdownButton(
                      alignment: Alignment.center,
                      value: selectedLanguage,
                      items : Language
                          .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Center(child: Text(item,style: TextStyle(fontSize: 20))),
                      )).toList(),
                      onChanged: (item) {
                        setState(() {
                          selectedLanguage = item;
                          print("Language = $selectedLanguage");
                        });
                      },
                    ),
                  ],
                ),
              ),

              ElevatedButton(
                  onPressed: () async {
                    _coSupervisor();
                  },
                  child: Text("deneme"))
            ],
          ),
        ),
      ),
    );
  }
}
