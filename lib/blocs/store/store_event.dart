import '../../models/store_model.dart';

import '../../bloc_helpers/bloc_event_state.dart';

class StoreEvent extends BlocEvent {
  StoreEvent({
    this.store,
  });

  StoreModel store;
}

class StoreEventSelected extends StoreEvent {
  StoreEventSelected({StoreModel store}) : super(store: store);
}

class StoreEventSelecting extends StoreEvent {
  StoreEventSelecting({StoreModel store}) : super(store: store);
}
