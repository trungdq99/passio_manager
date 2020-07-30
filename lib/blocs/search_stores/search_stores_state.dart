import 'package:flutter/material.dart';
import 'package:passio_manager/models/store_model.dart';
import '../../bloc_helpers/bloc_event_state.dart';

class SearchStoresState extends BlocState {
  final bool isSearched;
  final bool isSearching;
  final bool hasFailed;

  final List<StoreModel> listStores;
  SearchStoresState(
      {@required this.isSearched,
      this.isSearching: false,
      this.hasFailed: false,
      this.listStores: const []});

  factory SearchStoresState.notSearched() {
    return SearchStoresState(isSearched: false);
  }

  factory SearchStoresState.searched(List<StoreModel> listStores) {
    return SearchStoresState(isSearched: true, listStores: listStores);
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
