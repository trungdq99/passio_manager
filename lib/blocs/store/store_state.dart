import 'package:flutter/material.dart';

import '../../models/store_model.dart';

import '../../bloc_helpers/bloc_event_state.dart';

class StoreState extends BlocState {
  final bool isSelected;
  final bool isSelecting;
  final bool hasFailed;

  final StoreModel store;
  StoreState({
    @required this.isSelected,
    this.isSelecting: false,
    this.store,
    this.hasFailed: false,
  });

  factory StoreState.notSelected() {
    return StoreState(
      isSelected: false,
      store: StoreModel(id: -1),
    );
  }
  factory StoreState.selected(StoreModel store) {
    return StoreState(
      isSelected: true,
      store: store,
    );
  }
  factory StoreState.selecting(StoreModel store) {
    return StoreState(
      isSelected: false,
      isSelecting: true,
      store: store,
    );
  }
  factory StoreState.failure() {
    return StoreState(
      isSelected: false,
      hasFailed: true,
    );
  }
}
