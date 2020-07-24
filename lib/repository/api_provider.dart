import 'package:http/http.dart' show Client, Response;
import 'dart:convert' show json;
import 'dart:async';
import '../utils/constant.dart';

class ApiProvider {
  Client client = Client();

  Future fetchData(String api, String method, Map<String, String> header,
      Map<String, dynamic> body) async {
    Response response;
    var encodeBody = json.encode(body);
    if (method.compareTo('get') == 0) {
      response = await client.get('$baseUrl/$api', headers: header);
    } else if (method.compareTo('post') == 0) {
      response =
          await client.post('$baseUrl/$api', headers: header, body: encodeBody);
    } else if (method.compareTo('put') == 0) {
      response =
          await client.put('$baseUrl/$api', headers: header, body: encodeBody);
    } else if (method.compareTo('patch') == 0) {
      response = await client.patch('$baseUrl/$api',
          headers: header, body: encodeBody);
    }
    if (response.statusCode == 200) {
      print('Status code is 200');
      return json.decode(response.body);
    } else {
      print('Failed to load post');
      return null;
    }
  }
}
