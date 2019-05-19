import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:codingroomevents/Home/Card.dart';
 
void main() {
  // Define a test. The TestWidgets function will also provide a WidgetTester
  // for us to work with. The WidgetTester will allow us to build and interact
  // with Widgets in the test environment.
  testWidgets('Succes if the card display the data in param', (WidgetTester tester) async {
  // Build the Widget
  Widget testWidget = new MediaQuery(
      data: new MediaQueryData(),
      child: new MaterialApp(home: new CardEvent(startDate:'2019-02-20 10:00',
                                                 endDate:'2019-02-20 08:00',
                                                 texte:'Description',
                                                 title:'Titre',
                                                 mail:'mail@mail.com',
                                                 interesses:0,
                                                 img:'https://lh6.googleusercontent.com/-s6bpq5ZKT4s/AAAAAAAAAAI/AAAAAAAAAAA/P4Uw0hQjcxE/photo.jpg',
                                                 author:'Auteur'))
);

  await tester.pumpWidget(testWidget);

  expect(find.text('Par Auteur'), findsOneWidget);

});
}
