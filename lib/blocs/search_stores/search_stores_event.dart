import 'package:flutter/material.dart';
import '../../models/store_model.dart';

import '../../bloc_helpers/bloc_event_state.dart';

class SearchStoresEvent extends BlocEvent {
  final List<StoreModel> listStores;
  SearchStoresEvent({@required this.listStores});
}

class SearchStoreEventShowAll extends SearchStoresEvent {}

class SearchStoreEventQuery extends SearchStoresEvent {
  SearchStoreEventQuery({List<StoreModel> listStores})
      : super(listStores: listStores);
}
