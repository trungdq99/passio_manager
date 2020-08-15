import 'package:flutter/material.dart';
import '../../bloc_helpers/bloc_event_state.dart';

class DateState extends BlocState {
  final bool isSelected;
  final bool isSelecting;
  final bool hasFailed;

  final DateTimeRange dateTimeRange;
  DateState({
    @required this.isSelected,
    this.isSelecting: false,
    this.dateTimeRange,
    this.hasFailed: false,
  });

  factory DateState.notSelected() {
    return DateState(
      isSelected: false,
      dateTimeRange: DateTimeRange(start: DateTime.now(), end: DateTime.now()),
    );
  }
  factory DateState.selected(DateTimeRange dateTimeRange) {
    return DateState(
      isSelected: true,
      dateTimeRange: dateTimeRange,
    );
  }
  factory DateState.selecting(DateTimeRange dateTimeRange) {
    return DateState(
        isSelected: false, isSelecting: true, dateTimeRange: dateTimeRange);
  }
  factory DateState.failure() {
    return DateState(
      isSelected: false,
      hasFailed: true,
    );
  }
}
