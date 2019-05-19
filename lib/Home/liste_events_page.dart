import 'package:flutter/material.dart';
import 'package:codingroomevents/Home/Card.dart';

class ListViewEvents extends StatefulWidget {
  ListViewEvents(
      {Key key,
      this.posts,
      this.pickerDate,
      this.setNextDate,
      this.setPrevDate})
      : super(key: key);

  final posts;
  final pickerDate;
  final setNextDate;
  final setPrevDate;

  @override
  _ListViewEventsState createState() => _ListViewEventsState();
}

class _ListViewEventsState extends State<ListViewEvents>
    with SingleTickerProviderStateMixin {
  int _counter = 0;
  @override
  Widget build(BuildContext context) {
    return new Dismissible(
        resizeDuration: null,
        onDismissed: (DismissDirection direction) {
          setState(() {
            direction == DismissDirection.endToStart
                ? widget.setNextDate()
                : widget.setPrevDate();
            _counter += direction == DismissDirection.endToStart ? 1 : -1;
          });
        },
        key: new ValueKey(_counter),
        child: (widget.posts.isEmpty)
            ? new Center(
                child: Card(
                  child: Container(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                        'Aucun events prévu pour le ${widget.pickerDate}',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Color(0xFFf50057))),
                  ),
                ),
              )
            : new ListView.builder(
                itemCount: widget.posts.length,
                padding: const EdgeInsets.all(15.0),
                itemBuilder: (context, index) {
                  return CardEvent(
                    startDate: widget.posts[index].startDate,
                    endDate: widget.posts[index].endDate,
                    texte: widget.posts[index].texte,
                    title: widget.posts[index].title,
                    interesses: widget.posts[index].interesses,
                    author: widget.posts[index].author,
                    mail: widget.posts[index].mail,
                    img: widget.posts[index].img,
                  );
                },
              ));
  }
}
