import '../../models/store_model.dart';

import '../../bloc_helpers/bloc_event_state.dart';

class StoreEvent extends BlocEvent {
  StoreEvent({this.store, this.type: StoreEventType.notSelected})
      : assert(type != null);
  final StoreModel store;
  final StoreEventType type;
}

enum StoreEventType {
  notSelected,
  selected,
  selecting,
  updating,
}
