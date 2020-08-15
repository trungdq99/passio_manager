import 'package:flutter/material.dart';
import '../../models/store_model.dart';
import '../../bloc_helpers/bloc_event_state.dart';

abstract class FilterEvent extends BlocEvent {
  DateTimeRange dateTimeRange;
  StoreModel storeModel;
  String accessToken;
  FilterEvent({
    this.dateTimeRange,
    this.storeModel,
    this.accessToken,
  });
}

class FilterEventSelected extends FilterEvent {
  FilterEventSelected({
    DateTimeRange dateTimeRange,
    StoreModel storeModel,
  }) : super(
          dateTimeRange: dateTimeRange,
          storeModel: storeModel,
        );
}

class FilterEventLoadPreviousStore extends FilterEvent {
  FilterEventLoadPreviousStore({String accessToken})
      : super(accessToken: accessToken);
}

class FilterEventDefaultOverview extends FilterEvent {}

class FilterEventDefaultReport extends FilterEvent {}

class FilterEventOverview extends FilterEvent {}

class FilterEventUpdate extends FilterEvent {
  FilterEventUpdate({
    StoreModel storeModel,
    DateTimeRange dateTimeRange,
  }) : super(
          storeModel: storeModel,
          dateTimeRange: dateTimeRange,
        );
}

class FilterEventReport extends FilterEvent {}
