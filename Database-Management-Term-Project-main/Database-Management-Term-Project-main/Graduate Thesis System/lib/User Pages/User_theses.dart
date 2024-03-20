import 'package:database_management_system_project/User%20Pages/User_Screen.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

import '../Database_connection/Mysql.dart';
import '../models/Thesis_card_model.dart';
import 'User_edit_theses.dart';

class UserThesesPage extends StatefulWidget {
  const UserThesesPage({super.key, required this.username, required this.password});
  final String username;
  final String password;

  @override
  State<UserThesesPage> createState() => _UserThesesPageState();
}

class _UserThesesPageState extends State<UserThesesPage> {

  List<Map<String, dynamic>> _results = []; // Sonuçları tutacak değişken
  List<Map<String, dynamic>> get results => _results; // Getter



  void search() async {

    Mysql mysql = Mysql();
    MySqlConnection conn = await mysql.getConnection();
      try {
        Results queryResults = await conn.query(
          'SELECT * FROM thesisdeneme WHERE AUTHOR_NAME= ?',
          [widget.username],
        );

        if (queryResults.isNotEmpty) {
          setState(() {
            _results = queryResults.map((r) => Map<String, dynamic>.from(r.fields)).toList();
            print("var $_results");
          });
        } else {
          setState(() {
            print("yok");
          });
        }
      } catch (e) {
        print('Hata: $e');
      } finally {
        await conn.close();
      }
    }


  @override
  void initState() {
    search();
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(

      onWillPop: _onWillPop,

      child: Scaffold(
        appBar: AppBar(
          title: Text("Your Theses"),
        ),
        body: Center(
          child: Column(
            children: [
              if (_results.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: _results.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                          title: InkWell(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) => Builder(builder: (_) => EditTheses(thesNo: _results[index]['THES_NO'], thesTitle: _results[index]['THES_TITLE'], thesAbstract: _results[index]['THES_ABS'], authorName: _results[index]['AUTHOR_NAME'], coSupervisorName: _results[index]['CSV_NAME'], supervisorName: _results[index]['SV_NAME'], thesYear: _results[index]['THES_YEAR'], thesType: _results[index]['THES_TYPE'], uniName: _results[index]['UNI_NAME'], instituteName: _results[index]['INS_NAME'], thesPageNumber: _results[index]['THES_NOP'], langugae: _results[index]['LANG_NAME'], submitDate: _results[index]['THES_SUBDATE']),
                                      )
                                  ),
                                );
                              },
                              child: ThesesCard(title: _results[index]['THES_TITLE'], authorName: _results[index]['AUTHOR_NAME'] , subject: _results[index]['THES_ABS'] , thesesNo: _results[index]['THES_NO'] , thesesType: _results[index]['THES_TYPE'], thesesYear: _results[index]['THES_YEAR'],)
                          )


                        // Text("Author Name: ${_results[index]['AUTHOR_NAME']}\n\n"
                        //             "Thesis NO: ${_results[index]['THES_NO']}\n\n"
                        //             "Thesis Title: ${_results[index]['THES_TITLE']}\n\n"
                        //             "Thesis abstract: ${_results[index]['THES_ABS']}\n\n"
                        //             "Thesis Supervisor Name: ${_results[index]['SV_NAME']}\n\n"
                        //             "Thesis Year: ${_results[index]['THES_YEAR']}\n\n"
                        //             "Thesis Type: ${_results[index]['THES_TYPE']}\n\n"
                        //             "Thesis Uni name: ${_results[index]['UNI_NAME']}\n\n"
                        //             "Thesis Ins Name: ${_results[index]['INS_NAME']}\n\n"
                        //             "Thesis Language: ${_results[index]['LANG_NAME']}\n\n"
                        //             "Thesis Sub Date: ${_results[index]['THES_SUBDATE']}\n\n"),
                      );
                    },
                  ),
                ),
              if (_results.isEmpty)
                Text("No results found."),
            ],
          ),
        ),
      ),
    );
  }
}
