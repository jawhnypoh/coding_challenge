import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:async';

class ClientAuth {
  final dio = Dio();
  // Enter your client_ID and client_secret here
  final String identifier = '';
  final String secret = '';

  // Generate base64 encoded credentials from ClientID and ClientSecret
  String generateEncodedCredentials() {
    String credentials = identifier + ':' + secret;
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    final String encoded = 'Basic ' + stringToBase64.encode(credentials);
    return encoded;
  }

  // Use encoded credentials to generate authorization token from OAuth2 API
  Future<String> getAuthorizationToken(String encodedCredentials) async {
    final String oauthURL = 'https://api.ebay.com/identity/v1/oauth2/token';

    var header_params = {
      'Content-Type' : 'application/x-www-form-urlencoded',
      'Authorization' : encodedCredentials
    };

    var body_params = {
      'grant_type': 'client_credentials',
      'scope': 'https://api.ebay.com/oauth/api_scope'
    };
    dio.options.headers = header_params;
    var response = await dio.post(oauthURL, queryParameters: body_params);

    final String authToken = 'Bearer ' + await response.data['access_token'];
    return authToken;
  }
}