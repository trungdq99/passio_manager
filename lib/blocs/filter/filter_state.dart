import 'package:flutter/material.dart';
import '../../models/store_model.dart';
import '../../bloc_helpers/bloc_event_state.dart';

class FilterState extends BlocState {
  final bool isSelected;
  final bool isSelecting;
  final bool isOverview;
  final bool isReport;
  final bool hasFailed;
  final bool notSelectStore;
  final isUpdate;
  final DateTimeRange dateTimeRange;
  final StoreModel storeModel;

  FilterState({
    this.isSelected: false,
    this.isSelecting: false,
    this.isOverview: false,
    this.isReport: false,
    this.isUpdate: false,
    this.notSelectStore: false,
    this.dateTimeRange,
    this.storeModel,
    this.hasFailed: false,
  });

  factory FilterState.selected({
    DateTimeRange dateTimeRange,
    StoreModel storeModel,
  }) {
    return FilterState(
      isSelected: true,
      dateTimeRange: dateTimeRange,
      storeModel: storeModel,
    );
  }

  factory FilterState.update({
    DateTimeRange dateTimeRange,
    StoreModel storeModel,
  }) {
    return FilterState(
      isUpdate: true,
      dateTimeRange: dateTimeRange,
      storeModel: storeModel,
    );
  }

  factory FilterState.notSelectStore() {
    return FilterState(
      notSelectStore: true,
      dateTimeRange: DateTimeRange(
        start: DateTime.now(),
        end: DateTime.now(),
      ),
      storeModel: StoreModel(id: -1),
    );
  }

  factory FilterState.selecting() {
    return FilterState(
      isSelecting: true,
    );
  }

  factory FilterState.overview({
    DateTimeRange dateTimeRange,
    StoreModel storeModel,
  }) {
    return FilterState(
      isOverview: true,
      dateTimeRange: dateTimeRange,
      storeModel: storeModel,
    );
  }

  factory FilterState.defaultOverview() {
    return FilterState(
      isSelected: true,
      dateTimeRange: DateTimeRange(
        start: DateTime.now(),
        end: DateTime.now(),
      ),
      storeModel: StoreModel(id: -1),
    );
  }

  factory FilterState.defaultReport() {
    return FilterState(
      isSelected: true,
      dateTimeRange: DateTimeRange(
        start: DateTime.now(),
        end: DateTime.now(),
      ),
      storeModel: StoreModel(id: -1),
    );
  }

  factory FilterState.report(
      DateTimeRange dateTimeRange, StoreModel storeModel) {
    return FilterState(
      isOverview: true,
      dateTimeRange: dateTimeRange,
      storeModel: storeModel,
    );
  }

  factory FilterState.failure() {
    return FilterState(
      hasFailed: true,
    );
  }
}
