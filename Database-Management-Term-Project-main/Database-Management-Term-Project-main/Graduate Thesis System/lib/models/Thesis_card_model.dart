
import 'package:flutter/material.dart';

class ThesesCard extends StatefulWidget {
  const ThesesCard({Key? key, required this.thesesNo, required this.thesesYear, required this.authorName, required this.title, required this.thesesType, required this.subject});
  final int thesesNo;
  final int thesesYear;
  final String authorName;
  final String title;
  final String thesesType;
  final String subject;

  @override
  State<ThesesCard> createState() => _ThesesCardState();
}

class _ThesesCardState extends State<ThesesCard> {
  @override
  Widget build(BuildContext context) {
    return
      Card(
              shape: RoundedRectangleBorder( //<-- SEE HERE
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(40),
                ),
                side: BorderSide(
                  color: Colors.black,
                ),
              ),
              color: Color(0xffc9c5c8),
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Stack(
                  children: [
                    // Sol Kısım
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(

                        width:  MediaQuery.of(context).size.width / 2 - 15.0,// Sol kısım genişliği
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom:BorderSide(
                                      width: 2
                                  ),
                                  right: BorderSide(
                                    width: 2
                                  )
                                )
                              ),
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width / 2 - 110.0,
                                      child: Column(
                                        children: [
                                          Text("Theses No",style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            decoration: TextDecoration.underline,
                                            decorationThickness: 2.0,
                                          )),
                                          Text("${widget.thesesNo}"),
                                        ],
                                      ),
                                    )
                                  ),
                                  Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border: Border(
                                                left: BorderSide(
                                                    width: 2
                                                )
                                            )
                                        ),
                                        width: MediaQuery.of(context).size.width / 2 - 110.0,
                                        child: Column(
                                          children: [
                                            Text("Year",style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              decoration: TextDecoration.underline,
                                              decorationThickness: 2.0,
                                            )),
                                            Text("${widget.thesesYear}"),
                                          ],
                                        ),
                                      )
                                  ),
                                ]
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom:BorderSide(
                                          width: 2
                                      ),
                                      right: BorderSide(
                                          width: 2
                                      )
                                  )
                              ),

                              width: MediaQuery.of(context).size.width / 2 - 5.0,
                              child: Column(
                                children: [
                                  Text("Author Name",style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                    decorationThickness: 2.0,
                                  )),
                                  Text(widget.authorName),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom:BorderSide(
                                          width: 2
                                      ),
                                      right: BorderSide(
                                          width: 2
                                      )
                                  )
                              ),
                              width: MediaQuery.of(context).size.width / 2 - 5.0,
                              child: Column(
                                children: [
                                  Text("Title",style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                    decorationThickness: 2.0,
                                  )),
                                  Text(widget.title),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      right: BorderSide(
                                          width: 2
                                      )
                                  )
                              ),
                              width: MediaQuery.of(context).size.width / 2 - 5.0,
                              child: Column(
                                children: [
                                  Text("Theses Type",style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                    decorationThickness: 2.0,
                                  )),
                                  Text(widget.thesesType),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Sağ Kısım
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width:  MediaQuery.of(context).size.width / 2 - 10.0, // Sağ kısım genişliği
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Subject",style: TextStyle(
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                              decorationThickness: 2.0,
                            )),
                            Padding(
                              padding: const EdgeInsets.only(left: 40),
                              child: Text(widget.subject),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );



  }
}
