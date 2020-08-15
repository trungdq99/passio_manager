import '../../bloc_helpers/bloc_event_state.dart';

abstract class StoreEvent extends BlocEvent {
  StoreEvent({
    this.storeId,
    this.accessToken,
  });
  int storeId;
  String accessToken;
}

class StoreEventLoadPrevious extends StoreEvent {
  StoreEventLoadPrevious({String accessToken})
      : super(accessToken: accessToken);
}

class StoreEventSelect extends StoreEvent {
  StoreEventSelect({
    int storeId,
    String accessToken,
  }) : super(
          storeId: storeId,
          accessToken: accessToken,
        );
}

class StoreEventSelecting extends StoreEvent {
  StoreEventSelecting({int storeId}) : super(storeId: storeId);
}
