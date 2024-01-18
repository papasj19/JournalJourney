import 'package:dailydiary/addEntry.dart';
import 'package:flutter/material.dart';

class ShowEntry extends StatelessWidget {
  final JournalEntry entryGiven;


  const ShowEntry({super.key, required this.entryGiven});


  @override
  Widget build(BuildContext context) {
    String datePrint = "Log: ${entryGiven.date}";
    String scorePrint = "Score Given: ${entryGiven.score}";
    String entryPrint = "Your journal reads:\n\n ${entryGiven.entry}";
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
                   Text(
                      entryGiven.title,
                      style:
                      TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),

                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),

                        //depending on how you want to do it we could
                        //child: Image.asset('entryGiven.picture')
                        //    or
                        /*
                          Something like this that we did above
                            String pictureAccess = "${entryGiven.picture}";
                            child: Image.asset(pictureAccess)
                         */
                        child: Image.asset('assets/tbd.jpeg')
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        scorePrint,
                        style: TextStyle(fontSize: 16),
                      ),

                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        entryPrint,
                        style: TextStyle(fontSize: 20),
                        maxLines: 7,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 40),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.blue,
                          side: const BorderSide(
                            color: Colors.blue,
                          ),
                        ),
                        onPressed: () {
                        //------TO DO-------
                          //change as needed

                        },
                        child: const Text("Listen To Voice Note"),
                      ),
                    )

                  ],
                ),
              ),
            ),
          ),
        ));
  }
}