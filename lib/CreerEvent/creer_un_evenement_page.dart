import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:codingroomevents/model/Event.dart';
import 'package:flutter/foundation.dart';
import 'package:datetime_picker_formfield/time_picker_formfield.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:codingroomevents/utils/globals.dart' as globals;
import 'dart:io';

class CreerEvenementPage extends StatefulWidget {
  static String tag = 'creer-un-evenement-page';
  CreerEvenementPage({Key key, this.dateList}) : super(key: key);

  final List<Event> dateList;
  @override
  _CreerEvenementPageState createState() => new _CreerEvenementPageState();
}

class _CreerEvenementPageState extends State<CreerEvenementPage> {
  final dateFormat = DateFormat(
    "d/M/y",
  );
  final _formKey = GlobalKey<FormState>();
  var jsonMap = {};
  void dispose() {
    titreController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  //Format de la date
  final timeFormat = DateFormat("H:mm"); //format de l'heure
  final titreController = TextEditingController();
  final descriptionController = TextEditingController();
  DateTime date, dateTimeStart, dateTimeEnd;
  TimeOfDay timeStart, timeEnd;

  Future<void> _sameDate() async {
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
                new Text("Créneau indisponible",
                    style: new TextStyle(
                        fontFamily: 'Indie Flower',
                        color: new Color(0xFF263238),
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0)),
                SizedBox(height: 10.0),
                new Text("Il existe déjà un événement pendant ce créneau.",
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

  Future<void> _noDate() async {
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
                new Text("Pas de date et/ou heure",
                    style: new TextStyle(
                        fontFamily: 'Indie Flower',
                        color: new Color(0xFF263238),
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0)),
                SizedBox(height: 10.0),
                new Text("Veuillez rentrer une date et une heure",
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

  void _itWorked() {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(17.0))),
          content: new SingleChildScrollView(
            child: new Column(
              children: <Widget>[
                new Text("Création réussite",
                    style: new TextStyle(
                        fontFamily: 'Indie Flower',
                        color: new Color(0xFF263238),
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0)),
                SizedBox(height: 10.0),
                new Text("Votre événement a bien été créé.",
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

  Widget build(BuildContext context) {
    final titre = TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return 'Veuillez rentrer un titre';
        }
      },
      controller: titreController,
      maxLines: null,
      obscureText: false,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: 'Titre',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );
    final description = TextFormField(
      controller: descriptionController,
      validator: (value) {
        if (value.isEmpty) {
          return 'Veuillez rentrer une description';
        }
      },
      maxLines:
          null, //La textfield démare sur une ligne puis s'aggrandi en fonction du text écrit
      //autofocus: true, :Centre le curseur directemet sur cette TextField
      //obscureText: false, /Si true cache le text (pour mdp)
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors
            .white, // les deux lignes permettent un fond blanc a la textbox
        hintText: 'Description', //Le texte gris avant l'input de l'utilisateur
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    return Form(
      key: _formKey,
      child: Scaffold(
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
            'Créer un événement',
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
            padding: EdgeInsets.only(top: 24.0, left: 24.0, right: 24.0),
            children: <Widget>[
              Text(
                'Titre: ',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17.0),
              ),
              Padding(
                  padding: EdgeInsets.all(17.0),
                  child:
                      titre), //La TextField est le child d'un padding pour faire de l'espace entre lui et les autres textfields
              Text(
                'Description: ',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17.0),
              ),
              Padding(padding: EdgeInsets.all(17.0), child: description),
              Text(
                'Date: ',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17.0),
              ),
              Padding(
                padding: EdgeInsets.all(17.0),
                child: DateTimePickerFormField(
                  dateOnly: true,
                  format: dateFormat,
                  decoration: InputDecoration(
                    hintText: 'Date',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    filled: true,
                    fillColor: Colors.white,
                    //contentPadding: EdgeInsets.fromLTRB(17.0, 10.0, 17.0, 10.0),
                  ),
                  onChanged: (dt) => setState(() => date = dt),
                ),
              ),
              Text(
                'Heure de début: ',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17.0),
              ),
              Padding(
                padding: EdgeInsets.all(17.0),
                child: TimePickerFormField(
                  format: timeFormat,
                  decoration: InputDecoration(
                    hintText: 'Heure début',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40.0)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (t) => setState(() => timeStart = t),
                ),
              ),
              Text(
                'Heure de fin: ',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17.0),
              ),
              Padding(
                padding: EdgeInsets.all(17.0),
                child: TimePickerFormField(
                  format: timeFormat,
                  decoration: InputDecoration(
                    hintText: 'Heure Fin',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40.0)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (t) => setState(() => timeEnd = t),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                  onPressed: () async {
                    try {
                      final result = await InternetAddress.lookup('google.com');
                      if (result.isNotEmpty &&
                          result[0].rawAddress.isNotEmpty) {
                        if (_formKey.currentState.validate()) {
                          var checkDate = false;
                          var checkText = false;
                          if (date != null &&
                              timeEnd != null &&
                              timeStart != null) {
                            var formattedDate = DateFormat('yyyy-MM-dd').format(
                                new DateTime(date.year, date.month, date.day));
                            var startDateWithTime = new DateTime(
                                date.year,
                                date.month,
                                date.day,
                                timeStart.hour,
                                timeStart.minute);
                            var endDateWithTime = new DateTime(
                                date.year,
                                date.month,
                                date.day,
                                timeEnd.hour,
                                timeEnd.minute);
                            String formattedDateStart =
                                DateFormat('yyyy-MM-dd kk:mm')
                                    .format(startDateWithTime);
                            String formattedDateEnd =
                                DateFormat('yyyy-MM-dd kk:mm')
                                    .format(endDateWithTime);

                            for (int i = 0; i < widget.dateList.length; i++) {
                              if (formattedDateStart ==
                                      widget.dateList[i].startDate ||
                                  startDateWithTime.isAfter(DateTime.parse(
                                          widget.dateList[i].startDate)) &&
                                      startDateWithTime.isBefore(DateTime.parse(
                                          widget.dateList[i].endDate)) ||
                                  startDateWithTime.isBefore(DateTime.parse(
                                          widget.dateList[i].startDate)) &&
                                      DateTime.parse(
                                              widget.dateList[i].startDate)
                                          .isBefore(endDateWithTime)) {
                                checkDate = true;
                              }
                            }

                            if (checkDate != true && checkText != true) {
                              var body = jsonEncode({
                                '$formattedDateStart': {
                                  'author': '${globals.utilisateur}',
                                  'endDate': '$formattedDateEnd',
                                  'img': '${globals.avatar}',
                                  'mail': '${globals.email}',
                                  'interesses': 0,
                                  'nbLike': 0,
                                  'startDate': '$formattedDateStart',
                                  'texte': '${descriptionController.text}',
                                  'title': '${titreController.text}',
                                  'date': '$formattedDate'
                                }
                              });
                              http.patch(
                                  Uri.encodeFull(
                                      'https://io.datasync.orange.com/base/coding-room-events/cardList.json?auth=${globals.token}'),
                                  body: body,
                                  headers: {
                                    "Content-Type": "application/json"
                                  }).then((result) {});
                              _itWorked();
                            } else {
                              _sameDate();
                            }
                          } else {
                            _noDate();
                          }
                        }
                      }
                    } on SocketException catch (_) {
                      _noConnection();
                    }
                  },
                  padding: EdgeInsets.all(12),
                  color: Colors.pink,
                  child: Text('Confirmer',
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
              )
            ],
          ),
        ),
        backgroundColor: new Color(0xFF263238),
      ),
    );
  }
}
