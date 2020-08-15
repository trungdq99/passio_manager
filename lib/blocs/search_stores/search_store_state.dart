import '../../models/store_model.dart';
import '../../bloc_helpers/bloc_event_state.dart';

class SearchStoreState extends BlocState {
  final bool isLoaded;
  final bool isLoading;
  final bool hasFailed;
  final bool showSearch;
  final List<StoreModel> listStores;

  SearchStoreState({
    this.isLoaded: false,
    this.isLoading: false,
    this.hasFailed: false,
    this.listStores: const [],
    this.showSearch: false,
  });

  factory SearchStoreState.showAll(List<StoreModel> listStores) {
    return SearchStoreState(
      isLoaded: true,
      listStores: listStores,
    );
  }

  factory SearchStoreState.showSearch(List<StoreModel> listStores) {
    return SearchStoreState(
      isLoaded: true,
      listStores: listStores,
      showSearch: true,
    );
  }

  factory SearchStoreState.loading() {
    return SearchStoreState(
      isLoading: true,
    );
  }

  factory SearchStoreState.failure() {
    return SearchStoreState(
      hasFailed: true,
    );
  }
}
