import 'package:flutter/material.dart';
import 'package:codingroomevents/GererEvent/card_gerer_event.dart';
import 'package:codingroomevents/utils/globals.dart' as globals;

class GererEvenementPage extends StatefulWidget {
  static String tag = 'gerer-evenement-page';
  GererEvenementPage({Key key, this.event}) : super(key: key);

  final event;

  @override
  _GererEvenementPageState createState() => _GererEvenementPageState();
}

class _GererEvenementPageState extends State<GererEvenementPage>
    with SingleTickerProviderStateMixin {
  bool hasEvent() {
    for (var i = 0; i < widget.event.length; i++) {
      if (widget.event[i].mail.contains(globals.email)) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'Gérer vos événements',
          style: TextStyle(
              fontFamily: 'Indie Flower',
              fontSize: 25.0,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: new Color(0xFF263238),
      ),
      body: hasEvent()
          ? ListView.builder(
              itemCount: widget.event.length,
              padding: const EdgeInsets.all(15.0),
              itemBuilder: (context, index) {
                return CardGererEvent(
                  startDate: widget.event[index].startDate,
                  endDate: widget.event[index].endDate,
                  texte: widget.event[index].texte,
                  title: widget.event[index].title,
                  img: widget.event[index].img,
                  interesses: widget.event[index].interesses,
                  author: widget.event[index].author,
                  date: widget.event[index].date,
                  mail: widget.event[index].mail,
                  nbLike: widget.event[index].nbLike,
                );
              },
            )
          : Center(
              child: Card(
                child: Container(
                  padding: EdgeInsets.all(12.0),
                  child: Text('Vous n\'avez pas créé d\'event',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Color(0xFFf50057))),
                ),
              ),
            ),
    );
  }
}
