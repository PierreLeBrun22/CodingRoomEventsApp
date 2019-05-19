import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:codingroomevents/LoginAndProfil/login_profil_page.dart';
import 'package:codingroomevents/model/Event.dart';
// Create a MockClient using the Mock class provided by the Mockito package.
// Create new instances of this class in each test.
class MockClient extends Mock implements http.Client {}

main() {
  group('fetchPosts', () {
    test('returns a List of Events if the http call completes successfully', () async {
      final client = MockClient();

      // Use Mockito to return a successful response when it calls the
      // provided http.Client.
      when(client.get('https://io.datasync.orange.com/base/coding-room-events/cardList.json'))
          .thenAnswer((varInvocation) async => http.Response('OK', 200));

      expect(await fetchPosts(client), isInstanceOf<List<Event>>());
    });
  });
}