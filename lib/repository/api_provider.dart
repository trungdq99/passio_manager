import 'package:http/http.dart' show Client, Response;
import 'dart:async';
import '../utils/constant.dart';

class ApiProvider {
  Client client = Client();

  Future fetchData(String api, RequestMethod method, Map<String, String> header,
      String body) async {
    Response response;
    if (method == RequestMethod.GET) {
      response = await client.get('$BASE_URL/$api', headers: header);
    } else if (method == RequestMethod.POST) {
      response =
          await client.post('$BASE_URL/$api', headers: header, body: body);
    } else if (method == RequestMethod.PUT) {
      response =
          await client.put('$BASE_URL/$api', headers: header, body: body);
    } else if (method == RequestMethod.PATCH) {
      response =
          await client.patch('$BASE_URL/$api', headers: header, body: body);
    } else if (method == RequestMethod.DELETE) {
      response = await client.delete('$BASE_URL/$api', headers: header);
    }
    return response;
  }
}
