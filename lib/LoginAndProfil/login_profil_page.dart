import 'package:flutter/material.dart';
import 'package:codingroomevents/utils/globals.dart' as globals;
import 'package:codingroomevents/Participation/participation_page.dart';
import 'package:codingroomevents/GererEvent/gerer_evenement_page.dart';
import 'package:codingroomevents/CreerEvent/creer_un_evenement_page.dart';
import 'package:codingroomevents/model/Event.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:async';
import 'package:codingroomevents/custom_library/google_library.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'dart:io';

Future<List<Event>> fetchPosts(http.Client client) async {
  final response = await http.get(
      'https://io.datasync.orange.com/base/coding-room-events/cardList.json');
      
  return compute(parsePosts, response.bodyBytes);
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

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool connecter = false;
  static const platform = const MethodChannel('plugin.plb.io/authWebcom');

  Future<void> _authWebcom() async {
    String name;
    String mail;
    String photo;
    String uid;
    String token;
    try {
      final List result = await platform.invokeMethod('authWebcom');
      name = result[0]['name'];
      mail = result[0]['email'];
      photo = result[0]['picture'];
      token = result[1];
      uid = result[2];
    } on PlatformException catch (e) {
      name = "Error: '${e.message}'.";
      mail = "";
      photo = "";
      uid = "";
      token = "";
    }

    setState(() {
      globals.utilisateur = name;
      globals.avatar = photo;
      globals.email = mail;
      globals.uid = uid;
      globals.token = token;
    });
    _alertDialog();
  }

  void _noConnection() {
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
                "Vous n\'êtes plus connecté(e) à internet, reconnectez-vous pour pouvoir accéder à cette fonctionnalité.",
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

  void _alertDialog() {
    AlertDialog alertDialog = new AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(17.0))),
      content: new SingleChildScrollView(
        child: new Column(
          children: <Widget>[
            new Text("Bienvenue",
                style: new TextStyle(
                    fontFamily: 'Indie Flower',
                    color: new Color(0xFF263238),
                    fontWeight: FontWeight.bold,
                    fontSize: 22.0)),
            SizedBox(height: 10.0),
            new CircleAvatar(
              radius: 50.0,
              backgroundColor: Colors.transparent,
              backgroundImage: NetworkImage(globals.avatar),
            ),
            SizedBox(height: 10.0),
            new Text(
                "Tu es maintenant connecté(e) en tant que ${globals.utilisateur} !",
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
                setState(() {
                  connecter = true;
                });
                Navigator.of(context, rootNavigator: true).pop('dialog');
              },
              color: Colors.pink,
            )
          ],
        ),
      ),
    );

    showDialog(context: context, barrierDismissible: false, child: alertDialog);
  }

  void _signOut() {
    AlertDialog signOut = new AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(17.0))),
      content: new SingleChildScrollView(
        child: new Column(
          children: <Widget>[
            new Text("Déconnexion",
                style: new TextStyle(
                    fontFamily: 'Indie Flower',
                    color: new Color(0xFF263238),
                    fontWeight: FontWeight.bold,
                    fontSize: 22.0)),
            SizedBox(height: 10.0),
            new Text("Se déconnecter ${globals.utilisateur} ?",
                textAlign: TextAlign.center,
                style: new TextStyle(color: new Color(0xFF263238))),
          ],
        ),
      ),
      actions: <Widget>[
        RaisedButton(
          child: new Text("NON",
              style: new TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white)),
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0)),
          onPressed: () {
            Navigator.of(context).pop('dialog');
          },
          color: Color(0xFF2196f3),
        ),
        RaisedButton(
          child: new Text("OUI",
              style: new TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white)),
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0)),
          onPressed: () {
            globals.email = "";
            globals.utilisateur = "";
            globals.avatar = "";
            globals.uid = "";
            globals.token = "";
            Navigator.of(context, rootNavigator: true).pop('dialog');
            Navigator.of(context).pop(LoginPage.tag);
          },
          color: Colors.pink,
        )
      ],
    );
    showDialog(context: context, barrierDismissible: false, child: signOut);
  }

  initState() {
    super.initState();
    if (globals.email != "") {
      setState(() {
        connecter = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final pseudo = Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: CircleAvatar(
          radius: 72.0,
          backgroundColor: Colors.transparent,
          backgroundImage: NetworkImage(globals.avatar),
        ),
      ),
    );

    final welcome = Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        '${globals.utilisateur}',
        style: TextStyle(
            fontSize: 28.0, color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );

    final email = Container(
      child: Text(
        '${globals.email}',
        style: TextStyle(fontSize: 15.0, color: Colors.white),
      ),
    );

    final vosParticipations = Padding(
      padding: EdgeInsets.all(16.0),
      child: RaisedButton(
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        onPressed: () async {
          try {
            final result = await InternetAddress.lookup('google.com');
            if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FutureBuilder<List<Event>>(
                          future: fetchPosts(
                              http.Client()), //Fais le GET en changeant de page
                          builder: (context, snapshot) {
                            if (snapshot.hasError) print(snapshot.error);
                            return snapshot.hasData
                                ? ParticipationPage(posts: snapshot.data)
                                : Scaffold(
                                    appBar: AppBar(
                                      centerTitle: true,
                                      actions: <Widget>[
                                        Container(
                                          padding: EdgeInsets.only(right: 10),
                                          width: 55,
                                          child:
                                              Image.asset('assets/logo2.PNG'),
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
                                    body: Center(
                                        child: CircularProgressIndicator(
                                      backgroundColor: Color(0xFFf50057),
                                    )),
                                  );
                          },
                        )),
              );
            }
          } on SocketException catch (_) {
            _noConnection();
          }
        },
        color: Colors.pink,
        child: Text('Vos participations',
            style: TextStyle(fontSize: 18.0, color: Colors.white)),
      ),
    );

    final gerer = Padding(
      padding: EdgeInsets.all(16.0),
      child: RaisedButton(
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        onPressed: () async {
          try {
            final result = await InternetAddress.lookup('google.com');
            if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FutureBuilder<List<Event>>(
                          future: fetchPosts(
                              http.Client()), //Fais le GET en changeant de page
                          builder: (context, snapshot) {
                            if (snapshot.hasError) print(snapshot.error);

                            return snapshot.hasData
                                ? GererEvenementPage(event: snapshot.data)
                                : Scaffold(
                                    appBar: AppBar(
                                      centerTitle: true,
                                      actions: <Widget>[
                                        Container(
                                          padding: EdgeInsets.only(right: 10),
                                          width: 55,
                                          child:
                                              Image.asset('assets/logo2.PNG'),
                                        ),
                                      ],
                                      title: Text(
                                        'Gérer vos événements',
                                        style: TextStyle(
                                            fontFamily: 'Indie Flower',
                                            fontSize: 25.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      backgroundColor: new Color(0xFF263238),
                                    ),
                                    body: Center(
                                        child: CircularProgressIndicator(
                                      backgroundColor: Color(0xFFf50057),
                                    )),
                                  );
                          },
                        )),
              );
            }
          } on SocketException catch (_) {
            _noConnection();
          }
        },
        color: Colors.pink,
        child: Text('Gérer vos événements',
            style: TextStyle(fontSize: 18.0, color: Colors.white)),
      ),
    );

    final body = new Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(28.0),
      child: Column(
        children: <Widget>[pseudo, welcome, email, vosParticipations, gerer],
      ),
    );

    final logologin = Hero(
      tag: 'hero',
      child: new Image.asset('assets/logo1.PNG'),
    );

    final googleButonlogin = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: GoogleSignInButton(
        onPressed: _authWebcom,
      ),
    );

    return connecter
        ? Scaffold(
            appBar: AppBar(
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.exit_to_app,
                      size: 33, color: Colors.pink),
                  onPressed: () => _signOut(),
                ),
              ],
              centerTitle: true,
              title: Text(
                "Profil",
                style: TextStyle(
                    fontFamily: 'Indie Flower',
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold),
              ),
              backgroundColor: new Color(0xFF263238),
            ),
            body: body,
            floatingActionButton: new FloatingActionButton(
                child: new Icon(Icons.add),
                onPressed: () async {
                  try {
                    final result = await InternetAddress.lookup('google.com');
                    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FutureBuilder<List<Event>>(
                                  future: fetchPosts(http
                                      .Client()), //Fais le GET en changeant de page
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError)
                                      print(snapshot.error);

                                    return snapshot.hasData
                                        ? CreerEvenementPage(
                                            dateList: snapshot.data)
                                        : Scaffold(
                                            appBar: AppBar(
                                              centerTitle: true,
                                              actions: <Widget>[
                                                Container(
                                                  padding: EdgeInsets.only(
                                                      right: 10),
                                                  width: 55,
                                                  child: Image.asset(
                                                      'assets/logo2.PNG'),
                                                ),
                                              ],
                                              title: Text(
                                                'Créer un événement',
                                                style: TextStyle(
                                                    fontFamily: 'Indie Flower',
                                                    fontSize: 25.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              backgroundColor:
                                                  new Color(0xFF263238),
                                            ),
                                            body: Center(
                                                child:
                                                    CircularProgressIndicator(
                                              backgroundColor:
                                                  Color(0xFFf50057),
                                            )),
                                          );
                                  },
                                )),
                      );
                    }
                  } on SocketException catch (_) {
                    _noConnection();
                  }
                }))
        : Scaffold(
            appBar: AppBar(
              actions: <Widget>[
                Container(
                    padding: EdgeInsets.only(right: 10),
                    width: 55,
                    child: Image.asset('assets/logo2.PNG')),
              ],
              centerTitle: true,
              title: Text(
                "Se connecter",
                style: TextStyle(
                    fontFamily: 'Indie Flower',
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold),
              ),
              backgroundColor: new Color(0xFF263238),
            ),
            body: Center(
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.only(left: 25.0, right: 25.0),
                children: <Widget>[logologin, googleButonlogin],
              ),
            ));
  }
}
