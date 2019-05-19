import 'package:flutter/material.dart';
import 'package:codingroomevents/Participation/CardUser.dart';

class ListViewUser extends StatefulWidget {
  ListViewUser({Key key, this.posts}) : super(key: key);

  final posts;

  @override
  _ListViewUserState createState() => _ListViewUserState();
}

class _ListViewUserState extends State<ListViewUser>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    if (widget.posts.isEmpty) {
      return Center(
        child: Card(
          child: Container(
            padding: EdgeInsets.all(12.0),
            child: Text('Vous ne participez à aucun events',
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Color(0xFFf50057))),
          ),
        ),
      );
    }
    return ListView.builder(
      itemCount: widget.posts.length,
      padding: const EdgeInsets.all(15.0),
      itemBuilder: (context, index) {
        return CardUser(
          startDate: widget.posts[index].startDate,
          endDate: widget.posts[index].endDate,
          texte: widget.posts[index].texte,
          title: widget.posts[index].title,
          interesses: widget.posts[index].interesses,
          author: widget.posts[index].author,
          date: widget.posts[index].date,
          img: widget.posts[index].img,
        );
      },
    );
  }
}
