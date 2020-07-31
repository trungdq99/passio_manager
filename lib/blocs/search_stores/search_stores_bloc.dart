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
      SearchStoresEvent event, SearchStoresState state) async* {
    if (_listStores == null && state.isSearched) {
      yield SearchStoresState.failure();
    } else {
      yield SearchStoresState.searching();
      if (_listStores == null) {
        await Future.delayed(Duration(seconds: 2));
      }
      if (event is SearchStoreEventShowAll) {
        yield SearchStoresState.searched(_listStores, false);
      } else {
        if (event.listStores == null) {
          yield SearchStoresState.failure();
        } else {
          yield SearchStoresState.searched(event.listStores, true);
        }
      }
    }
  }

  List<StoreModel> _listStores;
  List<StoreModel> get listStores => _listStores;

  Future loadAllStores(String accessToken) async {
    Repository repository = Repository();
    Response response = await repository.fetchData(getStoresApi,
        RequestMethod.GET, Helper.getAuthorizeHeader(accessToken), null);
    if (response.statusCode == 200) {
      List responseBody = Helper.decodeJson(response.body);
      _listStores = [StoreModel(id: -1)];
      responseBody.forEach((element) {
        Map<String, dynamic> map = element;
        _listStores.add(StoreModel.fromMap(map));
      });
    } else {
      _listStores = null;
    }
  }

  List<StoreModel> searchStores(String query) {
    List<StoreModel> stores = [];
    if (query.isNotEmpty) {
      for (int i = 1; i < _listStores.length; i++) {
        StoreModel store = _listStores[i];
        if (store.name.contains(query) || store.address.contains(query)) {
          stores.add(store);
        }
      }
    }
    return stores;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
