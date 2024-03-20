import 'package:database_management_system_project/Theses_detailed_screen.dart';
import 'package:database_management_system_project/models/Thesis_card_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

import 'Database_connection/Mysql.dart';

class SearchResults extends StatefulWidget {
  const SearchResults({Key? key, required this.searchIn, required this.searchType, required this.searchBarInput});
  final String searchIn;
  final String searchType;
  final String searchBarInput;

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {

  List<Map<String, dynamic>> _results = []; // Sonuçları tutacak değişken
  List<Map<String, dynamic>> get results => _results; // Getter



  void search() async {

    Mysql mysql = Mysql();
    MySqlConnection conn = await mysql.getConnection();

    if(widget.searchIn == "All" && widget.searchType == "All"){
      try {

        Results columnsResults = await conn.query(
          'SHOW COLUMNS FROM thesisdeneme',
        );


        List<String> columnNames = columnsResults.map((r) => r[0].toString()).toList();


        String query = 'SELECT * FROM thesisdeneme WHERE ';
        query += columnNames.map((column) => '$column = ?').join(' OR ');


        List<String> parameters = List.filled(columnNames.length, widget.searchBarInput);


        Results results = await conn.query(query, parameters);

        if (results.isNotEmpty) {
          // Successful query
          setState(() {
            _results = results.map((r) => Map<String, dynamic>.from(r.fields)).toList();
          });
          print("var $results");
        } else {
          // No results
          print("yok");
        }
      } catch (e) {
        print('Hata: $e');
      } finally {
        await conn.close();
      }
    }
    else if(widget.searchIn != "ALL" && widget.searchType == "All"){
      try {
        Results queryResults = await conn.query(
          'SELECT * FROM thesisdeneme WHERE ${widget.searchIn} = ?',
          [widget.searchBarInput],
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
    else if(widget.searchType != "ALL" && widget.searchIn == "All"){
      try {

        Results columnsResults = await conn.query(
          'SHOW COLUMNS FROM thesisdeneme',
        );


        List<String> columnNames = columnsResults.map((r) => r[0].toString()).toList();


        String query = 'SELECT * FROM thesisdeneme WHERE ';
        query += columnNames.map((column) => '$column LIKE ?').join(' OR ');
        query += ' AND THES_TYPE = ?';

        List<String> parameters = List.from(columnNames.map((_) => '%${widget.searchBarInput}%'));
        parameters.add(widget.searchType);


        Results results = await conn.query(query, parameters);


        List<Map<String, dynamic>> doctorateResults = results
            .map((r) => Map<String, dynamic>.from(r.fields))
            .where((thesis) => thesis['THES_TYPE'] == widget.searchType)
            .toList();

        if (doctorateResults.isNotEmpty) {

          setState(() {
            _results = doctorateResults;
          });
          print("var $doctorateResults");
        } else {

          print("yok");
        }
      } catch (e) {
        print('Hata: $e');
      } finally {
        await conn.close();
      }

    }
    else if(widget.searchType != "ALL" && widget.searchIn != "All"){
      try {
        Results queryResults = await conn.query(
          'SELECT * FROM thesisdeneme WHERE ${widget.searchIn}  = ? AND THES_TYPE = ?',
          [widget.searchBarInput, widget.searchType],
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
  }

  @override
  void initState() {
    search();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Results"),
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
                                  builder: (BuildContext context) => Builder(builder: (_) => DetailedTheses(thesNo: _results[index]['THES_NO'], thesTitle: _results[index]['THES_TITLE'], thesAbstract: _results[index]['THES_ABS'], authorName: _results[index]['AUTHOR_NAME'], coSupervisorName: _results[index]['CSV_NAME'], supervisorName: _results[index]['SV_NAME'], thesYear: _results[index]['THES_YEAR'], thesType: _results[index]['THES_TYPE'], uniName: _results[index]['UNI_NAME'], instituteName: _results[index]['INS_NAME'], thesPageNumber: _results[index]['THES_NOP'], langugae: _results[index]['LANG_NAME'], submitDate: _results[index]['THES_SUBDATE']),
                                  )
                              ),
                              );
                        },
                          child: ThesesCard(title: _results[index]['THES_TITLE'], authorName: _results[index]['AUTHOR_NAME'] , subject: _results[index]['THES_ABS'] , thesesNo: _results[index]['THES_NO'] , thesesType: _results[index]['THES_TYPE'], thesesYear: _results[index]['THES_YEAR'],)
                      )
                    );
                  },
                ),
              ),
            if (_results.isEmpty)
              Text("No results found."),
          ],
        ),
      ),
    );
  }
}
