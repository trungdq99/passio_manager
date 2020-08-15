import '../../bloc_helpers/bloc_event_state.dart';

abstract class SearchStoreEvent extends BlocEvent {
  String searchValue;
  String accessToken;
  SearchStoreEvent({
    this.searchValue: '',
    this.accessToken: '',
  });
}

class SearchStoreEventShowAll extends SearchStoreEvent {}

class SearchStoreEventLoad extends SearchStoreEvent {
  SearchStoreEventLoad({String accessToken}) : super(accessToken: accessToken);
}

class SearchStoreEventSearch extends SearchStoreEvent {
  SearchStoreEventSearch({
    String searchValue,
  }) : super(
          searchValue: searchValue,
        );
}
