import 'package:http/http.dart' show Response;
import '../../bloc_helpers/bloc_event_state.dart';
import './store_event.dart';
import './store_state.dart';

import '../../repository/repository.dart';
import '../../utils/constant.dart';
import '../../utils/helper.dart';

import '../../models/store_model.dart';
import 'package:rxdart/rxdart.dart';

import '../../bloc_helpers/bloc_base.dart';

class StoreBloc extends BlocEventStateBase<StoreEvent, StoreState>
    implements BlocBase {
  StoreBloc() : super(initialState: StoreState.notSelected());

  // Stores Controller
  final BehaviorSubject<StoreModel> _storeController = BehaviorSubject();
  // Store Stream
  Stream<StoreModel> get storeStream => _storeController.stream;

  selectStore(StoreModel store) {
    _storeController.sink.add(store);
  }

  @override
  void dispose() {
    _storeController?.close();
  }

  Future<StoreModel> loadPreviousStore(String accessToken) async {
    int id = await Helper.loadData(storeIdKey, SavingType.Int);
    if (id == null) {
      id = -2;
    }
    String api = id == -1 ? '$getStoresApi' : '$getStoresApi/$id';
    Repository repository = Repository();
    Response response = await repository.fetchData(
        api, RequestMethod.GET, Helper.getAuthorizeHeader(accessToken), null);
    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = Helper.decodeJson(response.body);
      selectStore(StoreModel.fromMap(responseBody));
    } else if (response.statusCode == 401) {
      _storeController.sink.addError('UnAuthorize');
    }
  }

  @override
  Stream<StoreState> eventHandler(StoreEvent event, StoreState state) async* {
    if (event.type == StoreEventType.notSelected) {
      yield StoreState.notSelected();
    }
    if (event.type == StoreEventType.updating) {
      yield StoreState.updating();
    }
    if (event.type == StoreEventType.selecting) {
      yield StoreState.selecting();
    }
    if (event.type == StoreEventType.selected) {
      yield StoreState.selected(event.store);
    }
  }
}
