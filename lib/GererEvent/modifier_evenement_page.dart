import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:codingroomevents/utils/globals.dart' as globals;

class ModifierEvenementPage extends StatefulWidget {
  static String tag = 'modification-page';
  ModifierEvenementPage({Key key, this.dataAll}) : super(key: key);

  final dataAll;
  @override
  ModifierEvenementPageState createState() => new ModifierEvenementPageState();
}

class ModifierEvenementPageState extends State<ModifierEvenementPage> {
  void _modification() {
    AlertDialog modification = new AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(17.0))),
      content: new SingleChildScrollView(
        child: new Column(
          children: <Widget>[
            new Text("Modification",
                style: new TextStyle(
                    fontFamily: 'Indie Flower',
                    color: new Color(0xFF263238),
                    fontWeight: FontWeight.bold,
                    fontSize: 22.0)),
            SizedBox(height: 10.0),
            new Text(
                "L'évènement du ${DateTime.parse(widget.dataAll.date).day.toString()}/${DateTime.parse(widget.dataAll.date).month.toString().padLeft(2, '0')}/${DateTime.parse(widget.dataAll.date).year.toString()} de ${DateFormat('kk:mm').format(DateTime.parse(widget.dataAll.startDate))} à ${DateFormat('kk:mm').format(DateTime.parse(widget.dataAll.endDate))} a bien été modifié.",
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
                Navigator.pop(context);
              },
              color: Colors.pink,
            )
          ],
        ),
      ),
    );

    showDialog(
        context: context, barrierDismissible: false, child: modification);
  }

  void initState() {
    super.initState();
    titreController.text = widget.dataAll.title;
    descriptionController.text = widget.dataAll.texte;
  }

  void dispose() {
    titreController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  final dateFormat = DateFormat(
    "d/M/y",
  );
  var jsonMap = {};

  //Format de la date
  final timeFormat = DateFormat("H:mm"); //format de l'heure
  final titreController = TextEditingController();
  final descriptionController = TextEditingController();

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
        hintText: "Titre",
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );
    final description = TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return 'Veuillez rentrer une description';
        }
      },
      controller: descriptionController,
      maxLines:
          null, //La textfield démare sur une ligne puis s'aggrandi en fonction du text écrit
      //autofocus: true, :Centre le curseur directemet sur cette TextField
      //obscureText: false, /Si true cache le text (pour mdp)
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors
            .white, // les deux lignes permettent un fond blanc a la textbox
        hintText: "Description", //Le texte gris avant l'input de l'utilisateur
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );
    final date = TextFormField(
      initialValue: widget.dataAll.startDate,
      focusNode: new AlwaysDisabledFocusNode(),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey,
        hintText: widget.dataAll.title,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );
    final endDate = TextFormField(
      initialValue: widget.dataAll.endDate,
      focusNode: new AlwaysDisabledFocusNode(),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey,
        hintText: widget.dataAll.title,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            Container(
              padding: EdgeInsets.only(right: 10),
              width: 55,
              child: Image.asset('assets/logo2.PNG'),
            ),
          ],
          centerTitle: true,
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
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 24.0, right: 24.0, top: 24.0),
            children: <Widget>[
              Text(
                'Titre: ',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17.0),
              ),
              Padding(
                  padding: EdgeInsets.all(20.0),
                  child:
                      titre), //La TextField est le child d'un padding pour faire de l'espace entre lui et les autres textfields
              Text(
                'Description: ',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17.0),
              ),
              Padding(padding: EdgeInsets.all(20.0), child: description),
              Text(
                'Date et heure de début: ',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17.0),
              ),
              Padding(padding: EdgeInsets.all(20.0), child: date),
              Text(
                'Date et heure de fin: ',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17.0),
              ),
              Padding(padding: EdgeInsets.all(20.0), child: endDate),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Center(
                  child: Text(
                    'Si vous voulez changer la date ou le créneau, merci de supprimer cet évènement et de créer un nouveau',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                  onPressed: () {
                    var body = jsonEncode({
                      'texte': '${descriptionController.text}',
                      'title': '${titreController.text}',
                    });

                    http.patch(
                        Uri.encodeFull(
                            'https://io.datasync.orange.com/base/coding-room-events/cardList/${widget.dataAll.startDate}.json?auth=${globals.token}'),
                        body: body,
                        headers: {
                          "Content-Type": "application/json"
                        }).then((result) {});
                    _modification();
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

class AlwaysDisabledFocusNode extends FocusNode {
  //J'appelle cette class pour que l'utilisateur ne peut pas intéragir avec les TextFormField startDate et endDate
  @override
  bool get hasFocus => false;
}
