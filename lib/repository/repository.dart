import '../utils/constant.dart';
import './api_provider.dart';

class Repository {
  ApiProvider _apiProvider = ApiProvider();
  Future fetchData(String api, RequestMethod method, Map<String, String> header,
          String body) =>
      _apiProvider.fetchData(api, method, header, body);
}
