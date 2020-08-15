import '../../models/store_model.dart';
import '../../bloc_helpers/bloc_event_state.dart';

class StoreState extends BlocState {
  final bool isSelected;
  final bool isSelecting;
  final bool hasFailed;
  final StoreModel storeModel;

  StoreState({
    this.isSelected: false,
    this.isSelecting: false,
    this.storeModel,
    this.hasFailed: false,
  });

  factory StoreState.notSelected() {
    return StoreState(
      storeModel: StoreModel(id: -1),
    );
  }

  factory StoreState.selected({StoreModel storeModel}) {
    return StoreState(
      isSelected: true,
      storeModel: storeModel,
    );
  }

  factory StoreState.selecting({int storeId}) {
    return StoreState(
      isSelecting: true,
      storeModel: StoreModel(id: storeId),
    );
  }

  factory StoreState.failure() {
    return StoreState(
      hasFailed: true,
    );
  }
}
