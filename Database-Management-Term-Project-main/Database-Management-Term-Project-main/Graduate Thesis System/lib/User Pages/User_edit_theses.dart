import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

import '../Database_connection/Mysql.dart';

class EditTheses extends StatefulWidget {
  const EditTheses({
    super.key,
    required this.thesNo,
    required this.thesTitle,
    required this.thesAbstract,
    required this.authorName,
    required this.coSupervisorName,
    required this.supervisorName,
    required this.thesYear,
    required this.thesType,
    required this.uniName,
    required this.instituteName,
    required this.thesPageNumber,
    required this.langugae,
    required this.submitDate,
  });

  final int thesNo;
  final String thesTitle;
  final String thesAbstract;
  final String authorName;
  final String coSupervisorName;
  final String supervisorName;
  final int thesYear;
  final String thesType;
  final String uniName;
  final String instituteName;
  final int thesPageNumber;
  final String langugae;
  final DateTime submitDate;

  @override
  State<EditTheses> createState() => _EditThesesState();
}

class _EditThesesState extends State<EditTheses> {
  late TextEditingController _authorNameController;
  late TextEditingController _coSupervisorNameController;
  late TextEditingController _supervisorNameController;
  late TextEditingController _uniNameController;
  late TextEditingController _instituteNameController;
  late TextEditingController _thesTitleController;
  late TextEditingController _thesPageNumberController;
  late TextEditingController _thesAbstractController;


  @override
  void initState() {
    super.initState();

    // Controller'ları başlangıç değerleriyle oluştur
    _authorNameController = TextEditingController(text: widget.authorName);
    _coSupervisorNameController = TextEditingController(text: widget.coSupervisorName);
    _supervisorNameController = TextEditingController(text: widget.supervisorName);
    _uniNameController = TextEditingController(text: widget.uniName);
    _instituteNameController = TextEditingController(text: widget.instituteName);
    _thesTitleController = TextEditingController(text: widget.thesTitle);
    _thesPageNumberController = TextEditingController(text: widget.thesPageNumber.toString());
    _thesAbstractController = TextEditingController(text: widget.thesAbstract);
  }
  void _updateTheses(var columnName, var textController, var tableName) async {
    String input = textController.text;

    Mysql mysql = Mysql();
    MySqlConnection conn = await mysql.getConnection();

    try {
      await conn.query(
        'UPDATE $tableName SET $columnName = ? WHERE THES_NO = ?',
        [input, widget.thesNo],
      );
    } catch (e) {
      print('Hata: $e');
    } finally {
      await conn.close();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Theses"),
      ),
      body: Center(
        child: ListView(
          children: [
            Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: Icon(Icons.assignment_turned_in),
                    title: Text('THES NO'),
                    subtitle: Text("${widget.thesNo}"),
                  ),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Author name'),
                    subtitle:  Text("${widget.authorName}"),
                  ),
                  ListTile(
                    leading: Icon(Icons.calendar_today),
                    title: Text('Sub date'),
                    subtitle: Text("${widget.submitDate}"),
                  ),
                  ListTile(
                    leading: Icon(Icons.supervisor_account),
                    title: Text('Supervisor name'),
                    subtitle: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _supervisorNameController,
                            decoration: InputDecoration(
                              hintText: 'Enter supervisor name',
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.change_circle),
                          onPressed: () {
                            _updateTheses("SV_NAME", _supervisorNameController, "thesisdeneme");

                            print('Submit Supervisor Name: ${_supervisorNameController.text}');
                          },
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.supervisor_account),
                    title: Text('Co supervisor name'),
                    subtitle: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _coSupervisorNameController,
                            decoration: InputDecoration(
                              hintText: 'Enter co supervisor name',
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.change_circle),
                          onPressed: () {
                            _updateTheses("CSV_NAME", _coSupervisorNameController, "thesisdeneme");
                            print('Submit Co Supervisor Name: ${_coSupervisorNameController.text}');
                          },
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.school),
                    title: Text('Uni name'),
                    subtitle: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _uniNameController,
                            decoration: InputDecoration(
                              hintText: 'Enter university name',
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.change_circle),
                          onPressed: () {
                            _updateTheses("UNI_NAME", _uniNameController, "thesisdeneme");
                            print('Submit University Name: ${_uniNameController.text}');
                          },
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.school),
                    title: Text('Instute'),
                    subtitle: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _instituteNameController,
                            decoration: InputDecoration(
                              hintText: 'Enter institute name',
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.change_circle),
                          onPressed: () {
                           _updateTheses("INS_NAME", _instituteNameController, "thesisdeneme");
                            print('Submit Institute Name: ${_instituteNameController.text}');
                          },
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.title),
                    title: Text('Thes title'),
                    subtitle: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _thesTitleController,
                            decoration: InputDecoration(
                              hintText: 'Enter thesis title',
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.change_circle),
                          onPressed: () {
                            _updateTheses("THES_TITLE", _thesTitleController,"thesisdeneme");
                            print('Submit Thesis Title: ${_thesTitleController.text}');
                          },
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.pageview),
                    title: Text('Page number'),
                    subtitle: Text("${widget.thesPageNumber}"),
                  ),
                  ListTile(
                    leading: Icon(Icons.description),
                    title: Text('Thes abstract'),
                    subtitle: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _thesAbstractController,
                            maxLines: null,
                            decoration: InputDecoration(
                              hintText: 'Enter thesis abstract',
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.change_circle),
                          onPressed: () {
                            _updateTheses("THES_ABS", _thesAbstractController, "thesisdeneme");
                            print('Submit Thesis Abstract: ${_thesAbstractController.text}');
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Controller'ları dispose et
    _authorNameController.dispose();
    _coSupervisorNameController.dispose();
    _supervisorNameController.dispose();
    _uniNameController.dispose();
    _instituteNameController.dispose();
    _thesTitleController.dispose();
    _thesPageNumberController.dispose();
    _thesAbstractController.dispose();

    super.dispose();
  }
}
