import 'package:flutter/material.dart';
import 'package:codingroomevents/Participation/liste_events_user.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:codingroomevents/model/Event.dart';
import 'package:codingroomevents/utils/globals.dart' as globals;

Future<List> fetchPostsUser(http.Client client) async {
  final response = await http.get(
      'https://io.datasync.orange.com/base/coding-room-events/userEvent/${globals.uid}.json?auth=${globals.token}');

  return compute(parsePostsUser, response.body);
}

List parsePostsUser(String responseBody) {
  if (responseBody == "null") {
    return [];
  } else {
    Map<String, dynamic> jsonParsed = json.decode(responseBody);
    List _dates = [];
    jsonParsed.keys.forEach((String key) {
      if (jsonParsed[key]['isInteresses'] == true) {
        _dates.add(key);
      }
    });
    return _dates;
  }
}

class ParticipationPage extends StatefulWidget {
  ParticipationPage({Key key, this.posts, this.userEvents}) : super(key: key);
  static String tag = 'participation-page';
  final posts;
  final userEvents;

  @override
  _ParticipationPageState createState() => _ParticipationPageState();
}

class _ParticipationPageState extends State<ParticipationPage> {
  List<Event> userEvents(List<dynamic> dataUser, List<dynamic> dataAll) {
    List<Event> eventsUser = [];

    for (int index = 0; index < dataUser.length; index++) {
      for (int i = 0; i < dataAll.length; i++) {
        if (dataUser[index] == dataAll[i].startDate) {
          final Event event = Event(
              author: dataAll[i].author,
              endDate: dataAll[i].endDate,
              img: dataAll[i].img,
              interesses: dataAll[i].interesses,
              nbLike: dataAll[i].nbLike,
              startDate: dataAll[i].startDate,
              texte: dataAll[i].texte,
              date: dataAll[i].date,
              title: dataAll[i].title);
          eventsUser.add(event);
        }
      }
    }

    return eventsUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 10),
            width: 55,
            child: Image.asset('assets/logo2.PNG'),
          ),
        ],
        title: Text(
          'Vos participations',
          style: TextStyle(
              fontFamily: 'Indie Flower',
              fontSize: 25.0,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: new Color(0xFF263238),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchPostsUser(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? ListViewUser(posts: userEvents(snapshot.data, widget.posts))
              : Center(
                  child: CircularProgressIndicator(
                  backgroundColor: Color(0xFFf50057),
                ));
        },
      ),
    );
  }
}
