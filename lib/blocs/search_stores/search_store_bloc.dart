import '../../models/store_model.dart';
import '../../utils/constant.dart';
import '../../utils/helper.dart';
import 'package:http/http.dart' show Response;
import '../../repository/repository.dart';
import '../../bloc_helpers/bloc_event_state.dart';
import './search_store_event.dart';
import './search_store_state.dart';
import 'dart:async';

class SearchStoreBloc
    extends BlocEventStateBase<SearchStoreEvent, SearchStoreState> {
  SearchStoreBloc() : super(initialState: SearchStoreState());
  @override
  Stream<SearchStoreState> eventHandler(
      SearchStoreEvent event, SearchStoreState state) async* {
    if (event is SearchStoreEventLoad) {
      yield SearchStoreState.loading();
      _listStores = null;
      loadAllStores(event.accessToken);
      await Future.delayed(Duration(milliseconds: 1000));
      if (_listStores != null) {
        if (_listStores.length == 0) {
          yield SearchStoreState.failure();
        } else {
          yield SearchStoreState.showAll(_listStores);
        }
      }
    } else if (event is SearchStoreEventShowAll) {
      if (_listStores != null) {
        yield SearchStoreState.showAll(_listStores);
      }
    } else if (event is SearchStoreEventSearch) {
      List<StoreModel> listStores;
      listStores = searchStores(event.searchValue);
      if (listStores != null) {
        yield SearchStoreState.showSearch(listStores);
      }
    }
  }

  List<StoreModel> _listStores;
  List<StoreModel> get listStores => _listStores;

  Future loadAllStores(String accessToken) async {
    Repository repository = Repository();
    Response response = await repository.fetchData(GET_STORES_API,
        RequestMethod.GET, Helper.getAuthorizeHeader(accessToken), null);
    _listStores = [StoreModel(id: -1)];
    if (response.statusCode == 200) {
      List responseBody = Helper.decodeJson(response.body);
      responseBody.forEach((element) {
        Map<String, dynamic> map = element;
        print(element);
        _listStores.add(StoreModel.fromMap(map));
      });
    } else if (response.statusCode == 401) {
      _listStores = [];
    }
  }

  List<StoreModel> searchStores(String searchValue) {
    searchValue = searchValue.toLowerCase();
    List<StoreModel> stores = [];
    if (searchValue.isNotEmpty) {
      for (int i = 1; i < _listStores.length; i++) {
        StoreModel store = _listStores[i];
        if (store.name.contains(searchValue) ||
            store.address.contains(searchValue) ||
            store.name.contains(searchValue.toUpperCase()) ||
            store.address.contains(searchValue.toUpperCase())) {
          stores.add(store);
        }
      }
    }
    return stores;
  }
}
