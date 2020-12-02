import 'dart:convert';
import 'dart:io';
import 'package:flutter_app_project1/model/photo.dart';
import 'package:http/http.dart' as http;

Future<List<Photos>> fetchPhotos() async {
  var queryParameters = {
    'per_page': '20',
  };
  var uri = Uri.https('api.pexels.com', '/v1/curated', queryParameters);

  final response = await http.get(
    uri,
    headers: {
      HttpHeaders.authorizationHeader:
          '563492ad6f91700001000001adb390c3512e4c0388c1dee528ba1712'
    },
  );

  if (response.statusCode == 200) {
    final Iterable json = jsonDecode(response.body)['photos'];
    return json.map((e) => Photos.fromJson(e)).toList();
  } else {
    throw Exception('Failed to load : ${response.statusCode}');
  }
}

Future<List<Photos>> searchPhotos(String text) async {
  var queryParameters = {
    'query': '$text',
    'locale': 'ko-KR',
    'per_page': '80',
  };
  var uri = Uri.https('api.pexels.com', '/v1/search', queryParameters);

  final response = await http.get(
    uri,
    headers: {
      HttpHeaders.authorizationHeader:
          '563492ad6f91700001000001adb390c3512e4c0388c1dee528ba1712'
    },
  );

  if (response.statusCode == 200) {
    final Iterable json = jsonDecode(response.body)['photos'];
    return json.map((e) => Photos.fromJson(e)).toList();
  } else {
    throw Exception('Failed to load : ${response.statusCode}');
  }
}
