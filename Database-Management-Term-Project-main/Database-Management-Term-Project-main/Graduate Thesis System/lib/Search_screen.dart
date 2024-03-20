import 'package:database_management_system_project/Search_results.dart';
import 'package:database_management_system_project/models/Text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

import 'Database_connection/Mysql.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  final TextEditingController _searcBarController = TextEditingController();
  List<String> itemsSelectIn = [ "All", "Tittle", "Author Name", "Supervisor Name", "Keyword", "Abstract", "Thesis No"];
  String? selectedSearcInItem = "All";
  String sendingSearchInItem = "All";
  List<String> itemSearchType = ["All", "Master", "Doctorate", "Specialization in Medicine", "Proficiency in Art"];
  String? selectedSearchType = "All";
  String searchText = "";


  List<Map<String, dynamic>> _results = [];
  List<Map<String, dynamic>> get results => _results; // Getter
  var thesNooo;

  void search() async {
    Mysql mysql = Mysql();
    MySqlConnection conn = await mysql.getConnection();

    try {
      Results queryResults = await conn.query(
        'SELECT THES_NO FROM Keyword WHERE KEYWORD_NAME = ?',
        [_searcBarController.text],
      );

      if (queryResults.isNotEmpty) {
        setState(() {
          _results = queryResults.map((r) => Map<String, dynamic>.from(r.fields)).toList();
          var thesNo = _results[0]["THES_NO"];
          print("thes no test =  $thesNo");
          searchText = "$thesNo";
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFCFCFC),
      appBar: AppBar(
        title: const Text("Search Screen"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFieldModel(
                controller: _searcBarController,
                hintText: "Search"),
            Column(
              children: [

                Padding(
                  padding:  EdgeInsets.fromLTRB(0, 15, 0, 10),
                  child: Column(
                    children: [
                      Text("Search in"),
                      DropdownButton(
                        alignment: Alignment.center,
                        value: selectedSearcInItem,
                        items : itemsSelectIn
                            .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Center(child: Text(item,style: TextStyle(fontSize: 20))),
                        )).toList(),
                        onChanged: (item) {
                          setState(() {
                            selectedSearcInItem = item;
                            print("üstteki = $selectedSearcInItem");

                            switch (selectedSearcInItem) {
                              case "All":
                                setState(() {
                                  sendingSearchInItem = "All";
                                });

                                break;

                              case "Tittle":
                                setState(() {
                                  sendingSearchInItem = "THES_TITLE";
                                });

                                break;

                              case "Author Name":
                                setState(() {
                                  sendingSearchInItem = "AUTHOR_NAME";
                                });

                                break;

                              case "Supervisor Name":
                                setState(() {
                                  sendingSearchInItem = "SV_NAME";
                                });

                                break;

                              case "Keyword":
                                setState(() {
                                  sendingSearchInItem = "THES_NO";
                                });

                                break;

                              case "Abstract":
                                setState(() {

                                  sendingSearchInItem = "THES_ABS";
                                });

                                break;

                              case "Thesis No":
                                setState(() {
                                  sendingSearchInItem = "THES_NO";
                                });

                                break;

                            }

                            print("sendingSearchInItem = $sendingSearchInItem");

                          });
                        },
                      ),
                    ],
                  ),
                ),

                Column(
                  children: [
                    Text("Thesis type"),
                    DropdownButton(
                      alignment: Alignment.center,
                      value: selectedSearchType,
                      items : itemSearchType
                          .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Center(
                          child: Text(item,style: TextStyle(fontSize: 20)),
                        ),
                      )).toList(),
                      onChanged: (item) {
                        setState(() {
                          selectedSearchType= item;
                          print("alttaki = $selectedSearchType");
                        });
                      },
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            searchText = _searcBarController.text;
                          });
                          if(selectedSearcInItem == "Keyword"){
                            search();
                            await Future.delayed(Duration(milliseconds: 100));

                          }

                          print("Search Text: $searchText");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (
                                      BuildContext context) => Builder(builder: (_) =>
                                      SearchResults(
                                          searchIn: sendingSearchInItem,
                                          searchType: "$selectedSearchType",
                                          searchBarInput: searchText
                                      ),
                                  )
                              ),
                          );
                        },
                        child: Text("Search")),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
