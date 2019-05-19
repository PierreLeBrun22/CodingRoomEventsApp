import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:codingroomevents/utils/globals.dart' as globals;
import 'dart:io';

bool parseJointures(String responseBody) {
  if (responseBody ==
          '{"success":false,"status":"invalid_token","error":{"message":"The content or signature of the provided token is invalid.","code":"invalid_token"}}' ||
      responseBody == "null") {
    return false;
  }
  final jsonParsed = json.decode(responseBody);
  return jsonParsed['isInteresses'];
}

class CardEvent extends StatefulWidget {
  CardEvent(
      {Key key,
      this.startDate,
      this.endDate,
      this.texte,
      this.title,
      this.mail,
      this.interesses,
      this.img,
      this.author})
      : super(key: key);

  final startDate;
  final endDate;
  final mail;
  final texte;
  final title;
  final img;
  int interesses;
  final author;
  String userID = globals.uid;
  String userMail = globals.email;

  @override
  _CardEventState createState() => _CardEventState();
}

class _CardEventState extends State<CardEvent> {
  bool dataBool;
  bool isConnected;

  initState() {
    super.initState();
    setState(() {
      widget.userMail = globals.email;
    });
    fetchJointures(http.Client()).then((response) {
      if (dataBool != response) {
        setState(() {
          dataBool = response;
          widget.userID = globals.uid;
        });
      }
    });
  }

  void _checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isConnected = true;
        });
      }
    } on SocketException catch (_) {
      setState(() {
        isConnected = false;
      });
    }
  }

  Future<bool> fetchJointures(http.Client client) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        final response = await http.get(
            'https://io.datasync.orange.com/base/coding-room-events/userEvent/${widget.userID}/${widget.startDate}.json?auth=${globals.token}');

        return compute(parseJointures, response.body);
      }
    } on SocketException catch (_) {
      return compute(parseJointures, "null");
    }
  }

  @override
  void didUpdateWidget(CardEvent oldWidget) {
    setState(() {
      dataBool = null;
      widget.userMail = globals.email;
    });
    fetchJointures(http.Client()).then((response) {
      if (oldWidget.userID != globals.uid || dataBool != response) {
        setState(() {
          dataBool = response;
          widget.userID = globals.uid;
          widget.userMail = globals.email;
        });
      }
    });
    super.didUpdateWidget(oldWidget);
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
          widget.interesses = widget.interesses + 1;
          dataBool = true;
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
          widget.interesses = widget.interesses - 1;
          dataBool = false;
        });
      }
    } on SocketException catch (_) {
      _noConnection();
    }
  }

  @override
  Widget build(BuildContext context) {
    _checkInternet();
    Future<void> _notConnected() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
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
                      "Vous devez être connecté(e) pour pouvoir utiliser cette fonctionnalité.",
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
        },
      );
    }

    return Card(
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
                          color: Color(0xFFf50057))),
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
            leading: isConnected == null
                ? Container(
                    height: 25.0,
                    width: 25.0,
                    child: CircularProgressIndicator(
                      backgroundColor: Color(0xFFf50057),
                      strokeWidth: 3.0,
                    ),
                  )
                : isConnected
                    ? CircleAvatar(backgroundImage: NetworkImage(widget.img))
                    : CircleAvatar(
                        child: Image.asset('assets/images.jfif'),
                      ),
            title: Container(
                padding: EdgeInsets.only(top: 5),
                child: Text('${widget.title}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2196f3)))),
            subtitle: Container(
                padding: EdgeInsets.only(top: 5),
                child: Text('${widget.texte}')),
          ),
          Text('${widget.interesses} personnes seront là !',
              textAlign: TextAlign.left,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          widget.userMail != widget.mail
              ? ButtonTheme.bar(
                  // make buttons use the appropriate styles for cards
                  child: ButtonBar(
                    children: <Widget>[
                      dataBool == null
                          ? Container(
                              height: 25.0,
                              width: 25.0,
                              child: CircularProgressIndicator(
                                backgroundColor: Color(0xFFf50057),
                                strokeWidth: 3.0,
                              ),
                            )
                          : isConnected
                              ? FlatButton(
                                  child: dataBool
                                      ? const Text('INSCRIT !',
                                          style: TextStyle(
                                              color: Color(0xFF636363)))
                                      : const Text('J\'Y VAIS !',
                                          style: TextStyle(
                                              color: Color(0xFFf50057))),
                                  onPressed: () {
                                    widget.userID == ""
                                        ? _notConnected()
                                        : dataBool
                                            ? suppInteresses()
                                            : addInteresses();
                                  },
                                )
                              : Container(
                  height: 30.0,
                  child: CircleAvatar(
                        child: Image.asset('assets/images.jfif'),
                      )
                ),
                    ],
                  ),
                )
              : Container(
                  height: 30.0,
                )
        ],
      ),
    );
  }
}
