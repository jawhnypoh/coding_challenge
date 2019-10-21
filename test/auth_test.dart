import 'package:flutter_test/flutter_test.dart';
import 'package:coding_challenge/utils/auth.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';

class MockAuth extends Mock implements ClientAuth {}

void main() {
  final mockAuth = MockAuth();

  test('Test functionality of generating encoded credentials', () {
    final clientAuth = ClientAuth();

    String encodedCredentials = clientAuth.generateEncodedCredentials();
    expect(encodedCredentials, 'Basic Sm9obm55UG8tQ29kaW5nQ2gtUFJELTNiMzFmMTA0ZC1lNjQzOGZkYzpQUkQtYjMxZjEwNGQ0ZDlhLWFmMzYtNDJhNS04MmVhLWYxM2I=');
  });

  test('test functionality of getting the auth token properly from auth API', () async {
    const String encodedCredentials = 'some-fancy-code-01';
    when(mockAuth.getAuthorizationToken(encodedCredentials)).thenAnswer(
        (_) async => Future.value('Bearer some-fancy-access-token'));

    var response = await mockAuth.getAuthorizationToken(encodedCredentials);
    expect(response, 'Bearer some-fancy-access-token');
  });
}