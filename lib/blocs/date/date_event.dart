import 'package:flutter/material.dart';
import '../../bloc_helpers/bloc_event_state.dart';

class DateEvent extends BlocEvent {
  DateEvent({this.dateTimeRange});

  DateTimeRange dateTimeRange;
}

class DateEventSelected extends DateEvent {
  DateEventSelected({DateTimeRange dateTimeRange})
      : super(dateTimeRange: dateTimeRange);
}

class DateEventSelecting extends DateEvent {
  DateEventSelecting({DateTimeRange dateTimeRange})
      : super(dateTimeRange: dateTimeRange);
}
