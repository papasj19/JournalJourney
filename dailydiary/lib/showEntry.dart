import 'package:dailydiary/addEntry.dart';
import 'package:flutter/material.dart';

class ShowEntry extends StatelessWidget {
  final JournalEntry entry;


  const ShowEntry({super.key, required this.entry});


  @override
  Widget build(BuildContext context) {
    String datePrint = "Log: ${entry.date}";
    String scorePrint = "Score Given: ${entry.score}";
    return Scaffold(
        appBar: AppBar(
          title: Text(datePrint),
        ),
        body: Container(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                   //i tried for the picture location but it yelled at me :(
                    Text(
                      entry.title,
                      style:
                      TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),

                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      entry.entry,textDirection: TextDirection.ltr,
                      style: new TextStyle(fontSize: 20.0, color: Colors.black),
                      maxLines: 7,
                    ),
                  ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        scorePrint,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}