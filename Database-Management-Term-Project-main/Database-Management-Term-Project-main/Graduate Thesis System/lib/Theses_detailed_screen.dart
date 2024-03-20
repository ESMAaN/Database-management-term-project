import 'package:flutter/material.dart';

class DetailedTheses extends StatefulWidget {
  const DetailedTheses({super.key,required this.thesNo, required this.thesTitle, required this.thesAbstract, required this.authorName, required this.coSupervisorName, required this.supervisorName, required this.thesYear, required this.thesType, required this.uniName, required this.instituteName, required this.thesPageNumber, required this.langugae, required this.submitDate,});
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
  State<DetailedTheses> createState() => _DetailedThesesState();
}

class _DetailedThesesState extends State<DetailedTheses> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detailed Theses"),
      ),
      body: Center(
        child: ListView(
          children: [Card(
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
        subtitle: Text("${widget.authorName}"),
      ),
      ListTile(
        leading: Icon(Icons.calendar_today),
        title: Text('Sub date'),
        subtitle: Text("${widget.submitDate}"),
      ),
      ListTile(
        leading: Icon(Icons.supervisor_account),
        title: Text('Supervisor name'),
        subtitle: Text("${widget.supervisorName}"),
      ),
      ListTile(
        leading: Icon(Icons.supervisor_account),
        title: Text('Co supervisor name'),
        subtitle: Text("${widget.coSupervisorName}"),
      ),
      ListTile(
        leading: Icon(Icons.school),
        title: Text('Uni name'),
        subtitle: Text("${widget.uniName}"),
      ),
      ListTile(
        leading: Icon(Icons.school),
        title: Text('Instute'),
        subtitle: Text("${widget.instituteName}"),
      ),
      ListTile(
        leading: Icon(Icons.title),
        title: Text('Thes title'),
        subtitle: Text("${widget.thesTitle}"),
      ),
      ListTile(
        leading: Icon(Icons.pageview),
        title: Text('Page number'),
        subtitle: Text("${widget.thesPageNumber}"),
      ),
      ListTile(
        leading: Icon(Icons.description),
        title: Text('Thes abstract'),
        subtitle: Text("${widget.thesAbstract}"),
        ),
        ],
      ),
    ),
          ]
        ),
      ),
    );
  }
}
