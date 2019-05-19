import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:codingroomevents/utils/globals.dart' as globals;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

class CardUser extends StatefulWidget {
  CardUser({
    Key key,
    this.startDate,
    this.img,
    this.endDate,
    this.texte,
    this.title,
    this.interesses,
    this.author,
    this.date,
  }) : super(key: key);

  final startDate;
  final endDate;
  final texte;
  final title;
  final img;
  int interesses;
  final author;
  final date;
  String userID = globals.uid;

  @override
  _CardUserState createState() => _CardUserState();
}

class _CardUserState extends State<CardUser> {
  bool plusInteresses = false;

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

  void addInteresses() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var body = jsonEncode({"interesses": widget.interesses + 1});
        var bodyIsInteresses = jsonEncode({"isInteresses": true});

        http.patch(
            Uri.encodeFull(
                'https://io.datasync.orange.com/base/coding-room-events/cardList/${widget.startDate}.json?auth=${globals.token}'),
            body: body,
            headers: {"Content-Type": "application/json"}).then((result) {});

        http.patch(
            Uri.encodeFull(
                'https://io.datasync.orange.com/base/coding-room-events/userEvent/${widget.userID}/${widget.startDate}.json?auth=${globals.token}'),
            body: bodyIsInteresses,
            headers: {"Content-Type": "application/json"}).then((result) {});

        setState(() {
          plusInteresses = false;
          widget.interesses = widget.interesses + 1;
        });
      }
    } on SocketException catch (_) {
      _noConnection();
    }
  }

  void suppInteresses() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var bodyInteresses = jsonEncode({"interesses": widget.interesses - 1});
        var bodyIsInteresses = jsonEncode({"isInteresses": false});

        http.patch(
            Uri.encodeFull(
                'https://io.datasync.orange.com/base/coding-room-events/cardList/${widget.startDate}.json?auth=${globals.token}'),
            body: bodyInteresses,
            headers: {"Content-Type": "application/json"}).then((result) {});

        http.patch(
            Uri.encodeFull(
                'https://io.datasync.orange.com/base/coding-room-events/userEvent/${widget.userID}/${widget.startDate}.json?auth=${globals.token}'),
            body: bodyIsInteresses,
            headers: {"Content-Type": "application/json"}).then((result) {});

        setState(() {
          plusInteresses = true;
          widget.interesses = widget.interesses - 1;
        });
        _suppressionDefinitive();
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
                "Vous ne participerez plus à l'event: '${widget.title}' une fois que vous aurez quitté cette page.",
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
    return Card(
      color: plusInteresses ? Color(0xFFadadad) : null,
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
                          color: plusInteresses
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
            leading: CircleAvatar(backgroundImage: NetworkImage(widget.img)),
            title: Container(
              padding: EdgeInsets.only(top: 5),
              child: Text('${widget.title}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: plusInteresses
                          ? Color(0xFF3d3c3c)
                          : Color(0xFF2196f3))),
            ),
            subtitle: Container(
                padding: EdgeInsets.only(top: 5),
                child: Text('${widget.texte}')),
          ),
          Text('${widget.interesses} personnes seront là !',
              textAlign: TextAlign.left,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          Text(
              'Le ${DateTime.parse(widget.date).day.toString()}/${DateTime.parse(widget.date).month.toString().padLeft(2, '0')}/${DateTime.parse(widget.date).year.toString()}',
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color:
                      plusInteresses ? Color(0xFF3d3c3c) : Color(0xFF2196f3))),
          ButtonTheme.bar(
            // make buttons use the appropriate styles for cards
            child: ButtonBar(
              children: <Widget>[
                plusInteresses
                    ? FlatButton(
                        color: Colors.white70,
                        child: const Text('ANNULER !',
                            style: TextStyle(color: Colors.black)),
                        onPressed: () {
                          addInteresses();
                        },
                      )
                    : FlatButton(
                        child: const Text('JE NE SUIS PLUS DISPONIBLE !',
                            style: TextStyle(color: Color(0xFFf50057))),
                        onPressed: () {
                          suppInteresses();
                        },
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
