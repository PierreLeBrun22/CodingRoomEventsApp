import 'package:flutter/material.dart';
import 'package:codingroomevents/LoginAndProfil/login_profil_page.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:codingroomevents/utils/globals.dart' as globals;
import 'package:codingroomevents/model/Event.dart';
import 'liste_events_page.dart';
import 'package:codingroomevents/custom_library/datepicker_library.dart'
    as globalsDatePicker;
import 'dart:typed_data';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<Event>> fetchPosts(http.Client client) async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      final response = await http.get(
          'https://io.datasync.orange.com/base/coding-room-events/cardList.json');

      DateTime _date = DateTime.now();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getString('Date') == null) {
        prefs.setString('Date', _date.toString());
        prefs.setString('cardList', utf8.decode(response.bodyBytes).toString());
      } else {
        prefs.remove('Date');
        prefs.remove('cardList');
        prefs.setString('Date', _date.toString());
        prefs.setString('cardList', utf8.decode(response.bodyBytes).toString());
      }
      return compute(parsePosts, response.bodyBytes);
    }
  } on SocketException catch (_) {
    final prefs = await SharedPreferences.getInstance();
    final _date = DateTime.now();
    if (prefs.getString('Date') == null) {
    } else {
      final _prevDate = DateTime.parse(prefs.getString('Date'));
      final difference = _date.difference(_prevDate).inDays;
      if (difference < 2) {
        final response = prefs.getString('cardList');
        return compute(parsePostsCache, response);
      } else {
        prefs.remove('cardList');
        final response = "{}";
        return compute(parsePostsCache, response);
      }
    }
  }
}

List<Event> parsePosts(Uint8List responseBody) {
  Map<String, dynamic> jsonParsed = json.decode(utf8.decode(responseBody));
  List<Event> _events = [];
  List _dates = [];
  jsonParsed.keys.forEach((String key) {
    _dates.add(key);
  });
  for (int i = 0; i < _dates.length; i++) {
    final Event event = Event(
        author: jsonParsed[_dates[i]]['author'],
        endDate: jsonParsed[_dates[i]]['endDate'],
        img: jsonParsed[_dates[i]]['img'],
        interesses: jsonParsed[_dates[i]]['interesses'],
        nbLike: jsonParsed[_dates[i]]['nbLike'],
        startDate: jsonParsed[_dates[i]]['startDate'],
        texte: jsonParsed[_dates[i]]['texte'],
        date: jsonParsed[_dates[i]]['date'],
        mail: jsonParsed[_dates[i]]['mail'],
        title: jsonParsed[_dates[i]]['title']);
    _events.add(event);
  }
  return _events;
}

List<Event> parsePostsCache(String responseBody) {
  Map<String, dynamic> jsonParsed = json.decode(responseBody);
  List<Event> _events = [];
  List _dates = [];
  jsonParsed.keys.forEach((String key) {
    _dates.add(key);
  });
  for (int i = 0; i < _dates.length; i++) {
    final Event event = Event(
        author: jsonParsed[_dates[i]]['author'],
        endDate: jsonParsed[_dates[i]]['endDate'],
        img: jsonParsed[_dates[i]]['img'],
        interesses: jsonParsed[_dates[i]]['interesses'],
        nbLike: jsonParsed[_dates[i]]['nbLike'],
        startDate: jsonParsed[_dates[i]]['startDate'],
        texte: jsonParsed[_dates[i]]['texte'],
        date: jsonParsed[_dates[i]]['date'],
        mail: jsonParsed[_dates[i]]['mail'],
        title: jsonParsed[_dates[i]]['title']);
    _events.add(event);
  }
  return _events;
}

class HomePage extends StatefulWidget {
  static String tag = 'home-page';

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = globals.scaffoldKey;
  bool showDatePicker = false;
  bool isConnectionChecked = false;

  void _noConnection() {
    AlertDialog alertDialog = new AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(17.0))),
      content: new SingleChildScrollView(
        child: new Column(
          children: <Widget>[
            new Text("Mode hors-ligne",
                style: new TextStyle(
                    fontFamily: 'Indie Flower',
                    color: new Color(0xFF263238),
                    fontWeight: FontWeight.bold,
                    fontSize: 22.0)),
            SizedBox(height: 10.0),
            new Text(
                "Vous pouvez uniquement consulter les différents events que vous avez chargés la dernière fois que vous avez lancé l'application.",
                textAlign: TextAlign.center,
                style: new TextStyle(color: new Color(0xFF263238))),
            SizedBox(height: 10.0),
            new RaisedButton(
              child: new Text("OK",
                  style: new TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white)),
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
              onPressed: () {
                Navigator.pop(context);
              },
              color: Colors.pink,
            )
          ],
        ),
      ),
    );

    showDialog(context: context, barrierDismissible: false, child: alertDialog);
  }

  void _noCache() {
    AlertDialog alertDialog = new AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(17.0))),
      content: new SingleChildScrollView(
        child: new Column(
          children: <Widget>[
            new Text("Attention",
                style: new TextStyle(
                    fontFamily: 'Indie Flower',
                    color: new Color(0xFF263238),
                    fontWeight: FontWeight.bold,
                    fontSize: 22.0)),
            SizedBox(height: 10.0),
            new Text(
                "L'application est en mode hors-ligne depuis trop longtemps.",
                textAlign: TextAlign.center,
                style: new TextStyle(color: new Color(0xFF263238))),
          ],
        ),
      ),
    );

    showDialog(context: context, barrierDismissible: false, child: alertDialog);
  }

  void _firstRun() {
    AlertDialog alertDialog = new AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(17.0))),
      content: new SingleChildScrollView(
        child: new Column(
          children: <Widget>[
            new Text("Attention",
                style: new TextStyle(
                    fontFamily: 'Indie Flower',
                    color: new Color(0xFF263238),
                    fontWeight: FontWeight.bold,
                    fontSize: 22.0)),
            SizedBox(height: 10.0),
            new Text(
                "Cette application requiert une connexion internet la première fois qu'elle est lancé.",
                textAlign: TextAlign.center,
                style: new TextStyle(color: new Color(0xFF263238))),
          ],
        ),
      ),
    );

    showDialog(context: context, barrierDismissible: false, child: alertDialog);
  }

  //int selectedDateClient;
  void _snackBar(String text) {
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text(text), duration: Duration(seconds: 1)));
  }

  List<Event> eventsSelected(List<Event> data) {
    List<Event> eventsSelected = new List<Event>();
    for (var index = 0; index < data.length; index++) {
      if (data[index].date ==
          '${globalsDatePicker.dobYear}-${globalsDatePicker.month}-${globalsDatePicker.dobDate}') {
        eventsSelected.add(data[index]);
      }
    }
    eventsSelected.sort((m1, m2) {
      var r =
          DateTime.parse(m1.startDate).compareTo(DateTime.parse(m2.startDate));
      if (r != 0) return r;
      return DateTime.parse(m1.startDate)
          .compareTo(DateTime.parse(m2.startDate));
    });
    return eventsSelected;
  }

  void _setDateOfBirth() {
    _snackBar(globalsDatePicker.dobStrMonth +
        ' ${globalsDatePicker.dobDate}' +
        ' ${globalsDatePicker.dobYear}');
    setState(() {});
  }

  void _setNextPage() {
    if (int.parse(globalsDatePicker.dobDate) + 1 == 32 &&
        globalsDatePicker.dobMonth + 1 == 12) {
      globalsDatePicker.scrollControlDate.animateToItem(0,
          duration: Duration(milliseconds: 200), curve: Curves.easeIn);
      globalsDatePicker.scrollControlMonth.animateToItem(0,
          duration: Duration(milliseconds: 200), curve: Curves.easeIn);
      globalsDatePicker.scrollControlYear.animateToItem(
          globalsDatePicker.dobYear - 2015,
          duration: Duration(milliseconds: 200),
          curve: Curves.easeIn);
      setState(() {});
      _snackBar(globalsDatePicker.dobStrMonth +
          ' ${(int.parse(globalsDatePicker.dobDate) + 1).toString()}' +
          ' ${globalsDatePicker.dobYear}');
    } else if (int.parse(globalsDatePicker.dobDate) + 1 == 32) {
      globalsDatePicker.scrollControlDate.animateToItem(0,
          duration: Duration(milliseconds: 200), curve: Curves.easeIn);
      globalsDatePicker.scrollControlMonth.animateToItem(
          globalsDatePicker.dobMonth + 1,
          duration: Duration(milliseconds: 200),
          curve: Curves.easeIn);
      setState(() {});
      _snackBar(globalsDatePicker.dobStrMonth +
          ' ${(int.parse(globalsDatePicker.dobDate) + 1).toString()}' +
          ' ${globalsDatePicker.dobYear}');
    } else {
      globalsDatePicker.scrollControlDate.animateToItem(
          int.parse(globalsDatePicker.dobDate),
          duration: Duration(milliseconds: 200),
          curve: Curves.easeIn);
      setState(() {});
      _snackBar(globalsDatePicker.dobStrMonth +
          ' ${(int.parse(globalsDatePicker.dobDate) + 1).toString()}' +
          ' ${globalsDatePicker.dobYear}');
    }
  }

  void _setPrevPage() {
    if (int.parse(globalsDatePicker.dobDate) - 1 == 0 &&
        globalsDatePicker.dobMonth + 1 == 1) {
      globalsDatePicker.scrollControlMonth.animateToItem(11,
          duration: Duration(milliseconds: 200), curve: Curves.easeIn);
      globalsDatePicker.scrollControlDate.animateToItem(30,
          duration: Duration(milliseconds: 200), curve: Curves.easeIn);
      globalsDatePicker.scrollControlYear.animateToItem(
          globalsDatePicker.dobYear - 2017,
          duration: Duration(milliseconds: 200),
          curve: Curves.easeIn);
      setState(() {});
      _snackBar(globalsDatePicker.dobStrMonth +
          ' ${(int.parse(globalsDatePicker.dobDate) + 1).toString()}' +
          ' ${globalsDatePicker.dobYear}');
    } else if (int.parse(globalsDatePicker.dobDate) - 1 == 0) {
      globalsDatePicker.scrollControlDate.animateToItem(30,
          duration: Duration(milliseconds: 200), curve: Curves.easeIn);
      globalsDatePicker.scrollControlMonth.animateToItem(
          globalsDatePicker.dobMonth - 1,
          duration: Duration(milliseconds: 200),
          curve: Curves.easeIn);
      setState(() {});
      _snackBar(globalsDatePicker.dobStrMonth +
          ' ${(int.parse(globalsDatePicker.dobDate) + 1).toString()}' +
          ' ${globalsDatePicker.dobYear}');
    } else {
      globalsDatePicker.scrollControlDate.animateToItem(
          int.parse(globalsDatePicker.dobDate) - 2,
          duration: Duration(milliseconds: 200),
          curve: Curves.easeIn);
      setState(() {});
      _snackBar(globalsDatePicker.dobStrMonth +
          ' ${(int.parse(globalsDatePicker.dobDate) + 1).toString()}' +
          ' ${globalsDatePicker.dobYear}');
    }
  }

  void _checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {}
    } on SocketException catch (_) {
      final prefs = await SharedPreferences.getInstance();
      final _date = DateTime.now();
      if (prefs.getString('Date') == null) {
        _firstRun();
      } else {
        final _prevDate = DateTime.parse(prefs.getString('Date'));
        final difference = _date.difference(_prevDate).inDays;
        if (difference < 2) {
          _noConnection();
        } else {
          _noCache();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isConnectionChecked == false) {
      _checkInternet();
      setState(() {
        isConnectionChecked = true;
      });
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: Container(
            padding: EdgeInsets.only(left: 10),
            child: Image.asset('assets/logo2.PNG')),
        actions: <Widget>[
          globals.email == ""
              ? IconButton(
                  icon: const Icon(Icons.account_circle,
                      size: 33, color: Colors.pink),
                  onPressed: () {
                    Navigator.of(context).pushNamed(LoginPage.tag);
                  },
                )
              : IconButton(
                  icon: const Icon(Icons.face, size: 33, color: Colors.pink),
                  onPressed: () {
                    Navigator.of(context).pushNamed(LoginPage.tag);
                  },
                )
        ],
        centerTitle: true,
        title: Text(
          'Coding Room Events',
          style: TextStyle(
              fontFamily: 'Indie Flower',
              fontSize: 25.0,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: new Color(0xFF263238),
      ),
      body: FutureBuilder<List<Event>>(
        future: fetchPosts(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? ListViewEvents(
                  posts: eventsSelected(snapshot.data),
                  pickerDate: '${globalsDatePicker.dobDate} ' +
                      globalsDatePicker.dobStrMonth +
                      ' ${globalsDatePicker.dobYear}',
                  setNextDate: _setNextPage,
                  setPrevDate: _setPrevPage)
              : Center(
                  child: CircularProgressIndicator(
                  backgroundColor: Color(0xFFf50057),
                ));
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 100.0,
          alignment: Alignment.topCenter,
          child: globalsDatePicker.DatePicker(
            key: globalsDatePicker.dobKey,
            setDate: _setDateOfBirth,
            customItemColor: Color(0xFFf50057),
            customGradient:
                LinearGradient(begin: Alignment(-0.5, 2.8), colors: [
              Color(0xFFf50057),
              Color(0xFFffcece),
              Color(0xFFf50057),
            ]),
          ),
        ),
      ),
      // new ScaffoldState(_scaffoldKey: new GlobalKey<ScaffoldState>();
    );
  }
}
