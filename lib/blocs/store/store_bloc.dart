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
      return StoreModel(id: -2);
    } // Store hasn't selected yet!
    else if (id == -1) {
      return StoreModel(id: -1);
    } // Select all stores
    else {
      return getStore(accessToken, id);
    }
  }

  Future<StoreModel> getStore(String accessToken, int id) async {
    Repository repository = Repository();
    Response response = await repository.fetchData('$getStoresApi/$id',
        RequestMethod.GET, Helper.getAuthorizeHeader(accessToken), null);
    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = Helper.decodeJson(response.body);
      return StoreModel.fromMap(responseBody);
    } // Return valid store
    else if (response.statusCode == 404) {
      return StoreModel(id: -2);
    } // Invalid store return store with id = -2
    else {
      return null;
    } // UnAuthorize and other status return null
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
      if (event.store == null) {
        yield StoreState.failure();
      } // UnAuthorize
      else if (event.store.id == -2) {
        yield StoreState.notSelected();
      } // Select invalid store return not select
      else if (event.store.id >= -1) {
        yield StoreState.selected(event.store);
      } // Select store successful!
    }
  }
}
