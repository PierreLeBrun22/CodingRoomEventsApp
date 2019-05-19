import 'package:flutter/material.dart';
import 'package:codingroomevents/LoginAndProfil/login_profil_page.dart';
import 'package:codingroomevents/Home/home_page.dart';
import 'package:codingroomevents/Participation/participation_page.dart';
import 'package:codingroomevents/GererEvent/gerer_evenement_page.dart';
import 'package:codingroomevents/CreerEvent/creer_un_evenement_page.dart';
import 'package:codingroomevents/GererEvent/modifier_evenement_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    HomePage.tag: (context) => HomePage(),
    ParticipationPage.tag: (context) => ParticipationPage(),
    GererEvenementPage.tag: (context) => GererEvenementPage(),
    ModifierEvenementPage.tag: (context) => ModifierEvenementPage(),
    CreerEvenementPage.tag: (context) => CreerEvenementPage(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Coding Room Events',
      theme: ThemeData(
        scaffoldBackgroundColor: new Color(0xFF263238),
        primarySwatch: Colors.pink,
        fontFamily: 'Arvo',
      ),
      home: HomePage(),
      routes: routes,
    );
  }
}
