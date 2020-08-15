import 'package:flutter/material.dart';
import '../../models/store_model.dart';
import '../../bloc_helpers/bloc_event_state.dart';

abstract class OverviewEvent extends BlocEvent {
  StoreModel storeModel;
  DateTimeRange dateTimeRange;
  String accessToken;
  OverviewEvent({this.storeModel, this.dateTimeRange, this.accessToken});
}

class OverviewEventLoad extends OverviewEvent {
  OverviewEventLoad({
    StoreModel storeModel,
    DateTimeRange dateTimeRange,
    String accessToken,
  }) : super(
          storeModel: storeModel,
          dateTimeRange: dateTimeRange,
          accessToken: accessToken,
        );
}

class OverviewEventShowRevenue extends OverviewEvent {}

class OverviewEventShowReceipts extends OverviewEvent {}

class OverviewEventShowOverview extends OverviewEvent {}
