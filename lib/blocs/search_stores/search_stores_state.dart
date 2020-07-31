import 'package:flutter/material.dart';
import 'package:passio_manager/models/store_model.dart';
import '../../bloc_helpers/bloc_event_state.dart';

class SearchStoresState extends BlocState {
  final bool isSearched;
  final bool isSearching;
  final bool hasFailed;
  final bool showSearch;
  final List<StoreModel> listStores;
  SearchStoresState({
    @required this.isSearched,
    this.isSearching: false,
    this.hasFailed: false,
    this.listStores: const [],
    this.showSearch: false,
  });

  factory SearchStoresState.notSearched() {
    return SearchStoresState(isSearched: false);
  }

  factory SearchStoresState.searched(
      List<StoreModel> listStores, bool showSearch) {
    return SearchStoresState(
      isSearched: true,
      listStores: listStores,
      showSearch: showSearch,
    );
  }

  factory SearchStoresState.searching() {
    return SearchStoresState(
      isSearched: false,
      isSearching: true,
    );
  }

  factory SearchStoresState.failure() {
    return SearchStoresState(
      isSearched: false,
      hasFailed: true,
    );
  }
}
