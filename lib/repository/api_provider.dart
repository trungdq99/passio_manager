import 'package:http/http.dart' show Client, Response;
import 'dart:async';
import '../utils/constant.dart';

class ApiProvider {
  Client client = Client();

  Future fetchData(String api, RequestMethod method, Map<String, String> header,
      String body) async {
    Response response;
    if (method == RequestMethod.GET) {
      response = await client.get('$baseUrl/$api', headers: header);
    } else if (method == RequestMethod.POST) {
      response =
          await client.post('$baseUrl/$api', headers: header, body: body);
    } else if (method == RequestMethod.PUT) {
      response = await client.put('$baseUrl/$api', headers: header, body: body);
    } else if (method == RequestMethod.PATCH) {
      response =
          await client.patch('$baseUrl/$api', headers: header, body: body);
    } else if (method == RequestMethod.DELETE) {
      response = await client.delete('$baseUrl/$api', headers: header);
    }
//    if (response.statusCode == 200) {
//      print('Status code is 200');
//      return json.decode(response.body);
//    } else {
//      print('Failed to load post');
//      return null;
//    }
    return response;
  }
}
