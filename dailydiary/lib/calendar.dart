import "package:googleapis_auth/auth_io.dart";
import 'package:googleapis/calendar/v3.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Calendar {

  static const _scopes = [CalendarApi.calendarScope];
  final _apiKey = "AIzaSyBemHqmQ1DhO6OEc_y6RrZoJ4jqBaQLssw";
  final _credentials = ClientId(
      "724840386223-jf77fl6ur589b91avfd0lsfh30h3aqqu.apps.googleusercontent.com",
      "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");

  Future<void> addEvent() async {
    print("--------------ADDING EVENT TO CALENDAR------------");
    Event event = Event(); // Create object of eventa
    event.summary = "Journal Entry reminder !"; //Setting summary of object

    EventDateTime start = EventDateTime(); //Setting start time
    start.dateTime =
        DateTime.now().add(const Duration(hours: 23)).add(const Duration(minutes: 50));
    start.timeZone = "GMT+02:00";
    event.start = start;


    EventDateTime end = EventDateTime(); //setting end time
    end.timeZone = "GMT+02:00";
    end.dateTime =
        DateTime.now().add(const Duration(hours: 23)).add(const Duration(minutes: 55));
    event.end = end;

    try {
      clientViaUserConsent(_credentials, _scopes, prompt).then((
          AuthClient client) {
        var calendar = CalendarApi(client);
        String calendarId = "primary";
        calendar.events.insert(event, calendarId).then((value) {
          print("ADDEDDD_________________${value.status}");
          if (value.status == "confirmed") {
            print('Event added in google calendar');
          } else {
            print("Unable to add event in google calendar");
          }
        });
      });
    } catch (e) {
      print('Error creating event $e');
    }
  }

  void prompt(String url) async {
    print("Please go to the following URL and grant access:");
    print("  => $url");
    print("");
    try {
      await launchUrlString(url);
    } catch (e) {
      print(e.toString());
    }
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}




  /*/ GPT shit

  Future<void>  addEventToCalendar() async {
    // Authenticate with Google using Firebase credentials
    final auth.AuthClient client = await auth.clientViaUserConsent(
      auth.ClientId('<YOUR_CLIENT_ID>', '<YOUR_CLIENT_SECRET>'),
      <String>[calendar.CalendarApi.calendarScope],
      prompt,
    );

    // Create a new calendar API client
    final calendar.CalendarApi calendarApi = calendar.CalendarApi(client);

    // Create a new event
    final calendar.Event event = calendar.Event()
      ..summary = 'Test Event'
      ..description = 'This is a test event'
      ..start = calendar.EventDateTime()
      ..dateTime = DateTime.now().add(Duration(days: 1))
      ..timeZone = 'UTC'
      ..end = calendar.EventDateTime()
      ..dateTime = DateTime.now().add(Duration(days: 1, hours: 1))
      ..timeZone = 'UTC';

    // Insert the event into the user's calendar
    await calendarApi.events.insert(event, '<YOUR_CALENDAR_ID>');

    // Log a message to indicate that the event was added successfully
    print('Event added to calendar!');
  }*/
