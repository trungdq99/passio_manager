import 'package:passio_manager/models/store_model.dart';

import '../../bloc_helpers/bloc_event_state.dart';

class SearchStoresEvent extends BlocEvent {
  final SearchStoresEventType type;
  final List<StoreModel> listStores;
  SearchStoresEvent(
      {this.type: SearchStoresEventType.searching, this.listStores: const []});
}

enum SearchStoresEventType {
  searching,
  done,
}
