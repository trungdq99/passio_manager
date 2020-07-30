import '../../models/store_model.dart';
import '../../utils/constant.dart';
import '../../utils/helper.dart';
import 'package:http/http.dart' show Response;
import '../../bloc_helpers/bloc_base.dart';

import '../../repository/repository.dart';

import '../../bloc_helpers/bloc_event_state.dart';
import './search_stores_event.dart';
import './search_stores_state.dart';
import 'dart:async';

class SearchStoresBloc
    extends BlocEventStateBase<SearchStoresEvent, SearchStoresState>
    implements BlocBase {
  SearchStoresBloc() : super(initialState: SearchStoresState.notSearched());
  @override
  Stream<SearchStoresState> eventHandler(
      SearchStoresEvent event, SearchStoresState currentState) async* {
    if (event.type == SearchStoresEventType.done) {
      yield SearchStoresState.notSearched();
    } else {
      yield SearchStoresState.searching();
      await Future.delayed(const Duration(milliseconds: 1500));

      if (event.listStores == null) {
        yield SearchStoresState.failure();
      } else {
        yield SearchStoresState.searched(event.listStores);
      }
    }
  }

  List<StoreModel> _listStores;
  List<StoreModel> get listStores => _listStores;

  Future<List<StoreModel>> loadAllStores(String accessToken) async {
    Repository repository = Repository();
    Response response = await repository.fetchData(getStoresApi,
        RequestMethod.GET, Helper.getAuthorizeHeader(accessToken), null);
    List<StoreModel> listStores;
    if (response.statusCode == 200) {
      List responseBody = Helper.decodeJson(response.body);
      listStores = <StoreModel>[];
      responseBody.forEach((element) {
        Map<String, dynamic> map = element;
        listStores.add(StoreModel.fromMap(map));
        print(map);
      });
      _listStores = listStores;
    } else {
      listStores = null;
    }

    return listStores;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
