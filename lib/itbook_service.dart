import 'dart:convert';

import 'package:http/http.dart' as http;

import 'models.dart';

Future<NewArrivalResp> getNewArrivals() async {
  var dataURL = Uri.parse('https://api.itbook.store/1.0/new');
  http.Response response = await http.get(dataURL);
  var json = jsonDecode(response.body);
  return NewArrivalResp.fromJson(json);
}

Future<SearchResp> search(String query, [int? page]) async {
  final queryParam = Uri.encodeQueryComponent(query);
  final pageParam = page == null ? '' : "/$page";
  final dataURL = Uri.parse('https://api.itbook.store/1.0/search/$queryParam$pageParam');
  http.Response response = await http.get(dataURL);
  var json = jsonDecode(response.body);
  return SearchResp.fromJson(json);
}

