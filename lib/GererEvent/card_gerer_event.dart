import 'package:flutter/material.dart';
import 'modifier_evenement_page.dart';
import 'package:codingroomevents/model/Event.dart';
import 'package:codingroomevents/utils/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:typed_data';
import 'dart:io';

Event parseSpecific(Uint8List responseBody) {
  final jsonParsed = json.decode(utf8.decode(responseBody));
  final Event event = Event(
      author: jsonParsed['author'],
      mail: jsonParsed['mail'],
      endDate: jsonParsed['endDate'],
      img: jsonParsed['img'],
      interesses: jsonParsed['interesses'],
      nbLike: jsonParsed['nbLike'],
      startDate: jsonParsed['startDate'],
      texte: jsonParsed['texte'],
      date: jsonParsed['date'],
      title: jsonParsed['title']);

  return event;
}

class CardGererEvent extends StatefulWidget {
  CardGererEvent(
      {Key key,
      this.startDate,
      this.endDate,
      this.texte,
      this.title,
      this.mail,
      this.img,
      this.nbLike,
      this.interesses,
      this.author,
      this.date})
      : super(key: key);

  final startDate;
  final endDate;
  final texte;
  final title;
  final mail;
  final img;
  final nbLike;
  int interesses;
  final author;
  final date;
  String userID = globals.uid;

  @override
  _CardGererEventState createState() => _CardGererEventState();
  static String tag = 'gerer-evenement-page';
}

class _CardGererEventState extends State<CardGererEvent> {
  bool annulerSupression = false;
  Future<Event> fetchPostSpecific(http.Client client) async {
    final response = await http.get(
        'https://io.datasync.orange.com/base/coding-room-events/cardList/${widget.startDate}.json?auth=${globals.token}');

    return compute(parseSpecific, response.bodyBytes);
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

  void annuler() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var body = jsonEncode({
          '${widget.startDate}': {
            'author': '${globals.utilisateur}',
            'mail': '${globals.email}',
            'endDate': '${widget.endDate}',
            'img': '${widget.img}',
            'interesses': widget.interesses,
            'nbLike': widget.nbLike,
            'startDate': '${widget.startDate}',
            'texte': '${widget.texte}',
            'title': '${widget.title}',
            'date': '${widget.date}'
          }
        });

        http.patch(
            Uri.encodeFull(
                'https://io.datasync.orange.com/base/coding-room-events/cardList.json?auth=${globals.token}'),
            body: body,
            headers: {"Content-Type": "application/json"}).then((result) {});

        setState(() {
          annulerSupression = false;
        });
      }
    } on SocketException catch (_) {
      _noConnection();
    }
  }

  void supprimerCard() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        http.delete(
            Uri.encodeFull(
                'https://io.datasync.orange.com/base/coding-room-events/cardList/${widget.startDate}.json?auth=${globals.token}'),
            headers: {"Content-Type": "application/json"}).then((result) {});
        setState(() {
          annulerSupression = true;
        });
        _suppressionDefinitive();
      }
    } on SocketException catch (_) {
      _noConnection();
    }
  }

  void modifierCard() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FutureBuilder<Event>(
                    future: fetchPostSpecific(
                        http.Client()), //Fais le GET en changeant de page
                    builder: (context, snapshot) {
                      if (snapshot.hasError) print(snapshot.error);

                      return snapshot.hasData
                          ? ModifierEvenementPage(dataAll: snapshot.data)
                          : Scaffold(
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
                                  'Modifier vos événements',
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
  }

  void _suppressionDefinitive() {
    AlertDialog suppressionDefinitive = new AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(17.0))),
      content: new SingleChildScrollView(
        child: new Column(
          children: <Widget>[
            new Text("Suppression",
                style: new TextStyle(
                    fontFamily: 'Indie Flower',
                    color: new Color(0xFF263238),
                    fontWeight: FontWeight.bold,
                    fontSize: 22.0)),
            SizedBox(height: 10.0),
            new Text(
                "L'évènement '${widget.title}' sera définitivement supprimé une fois que vous aurez quitté cette page.",
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

    showDialog(
        context: context,
        barrierDismissible: false,
        child: suppressionDefinitive);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mail == globals.email) {
      return Center(
        child: Card(
          color: annulerSupression ? Color(0xFFadadad) : null,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 18, top: 18),
                      child: Text(
                          '${DateFormat('kk:mm').format(DateTime.parse(widget.startDate))} - ${DateFormat('kk:mm').format(DateTime.parse(widget.endDate))}',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: annulerSupression
                                  ? Color(0xFF3d3c3c)
                                  : Color(0xFFf50057))),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(right: 18, top: 18),
                      child: Text('Par ${widget.author}',
                          textAlign: TextAlign.end,
                          style: TextStyle(color: Color(0xFF636363))),
                    ),
                  ),
                ],
              ),
              ListTile(
                leading:
                    CircleAvatar(backgroundImage: NetworkImage(globals.avatar)),
                title: Text('${widget.title}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: annulerSupression
                            ? Color(0xFF3d3c3c)
                            : Color(0xFF2196f3))),
                subtitle: Text('${widget.texte}'),
              ),
              Text('${widget.interesses} personnes seront là  !',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Text(
                  'Le ${DateTime.parse(widget.date).day.toString()}/${DateTime.parse(widget.date).month.toString().padLeft(2, '0')}/${DateTime.parse(widget.date).year.toString()}',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: annulerSupression
                          ? Color(0xFF3d3c3c)
                          : Color(0xFF2196f3))),
              annulerSupression
                  ? ButtonTheme.bar(
                      // make buttons use the appropriate styles for cards
                      child: ButtonBar(children: <Widget>[
                      FlatButton(
                        color: Colors.white70,
                        child: const Text('ANNULER !',
                            style: TextStyle(color: Colors.black)),
                        onPressed: () {
                          annuler();
                        },
                      )
                    ]))
                  : ButtonTheme.bar(
                      // make buttons use the appropriate styles for cards
                      child: ButtonBar(
                        children: <Widget>[
                          Container(
                              height: 45.0,
                              width: 45.0,
                              child: FittedBox(
                                  child: FloatingActionButton(
                                heroTag: null,
                                child: Icon(Icons.create, size: 32),
                                backgroundColor: Color(0xFF2196f3),
                                onPressed: () {
                                  modifierCard();
                                },
                              ))),
                          Container(
                              height: 45.0,
                              width: 45.0,
                              child: FittedBox(
                                  child: FloatingActionButton(
                                heroTag: null,
                                child: Icon(Icons.delete, size: 32),
                                onPressed: () {
                                  supprimerCard();
                                },
                              ))),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      );
    } else {
      return Center();
    }
  }
}
