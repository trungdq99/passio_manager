import './api_provider.dart';

class Repository {
  ApiProvider _apiProvider = ApiProvider();
  Future fetchData(String api, String method, Map<String, String> header,
          Map<String, dynamic> body) =>
      _apiProvider.fetchData(api, method, header, body);
}
