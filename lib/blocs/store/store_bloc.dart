import 'package:http/http.dart' show Response;
import '../../bloc_helpers/bloc_event_state.dart';
import './store_event.dart';
import './store_state.dart';
import '../../repository/repository.dart';
import '../../utils/constant.dart';
import '../../utils/helper.dart';
import '../../models/store_model.dart';

class StoreBloc extends BlocEventStateBase<StoreEvent, StoreState> {
  StoreBloc() : super(initialState: StoreState.notSelected());

  Future<StoreModel> loadPreviousStore({String accessToken}) async {
    int id = await Helper.loadData(STORE_ID_KEY, SavingType.Int);
    if (id == null) {
      return StoreModel(id: -2);
    } // Store hasn't selected yet!
    else if (id == -1) {
      return StoreModel(id: -1);
    } // Select all stores
    else {
      return getStore(accessToken: accessToken, storeId: id);
    }
  }

  Future<StoreModel> getStore({String accessToken, int storeId}) async {
    if (storeId == -1) {
      return StoreModel(id: -1);
    } else {
      Repository repository = Repository();
      Response response = await repository.fetchData('$GET_STORES_API/$storeId',
          RequestMethod.GET, Helper.getAuthorizeHeader(accessToken), null);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = Helper.decodeJson(response.body);
        return StoreModel.fromMap(responseBody);
      } // Return valid store
      else if (response.statusCode == 404) {
        return StoreModel(id: -2);
      } // Invalid store return store with id = -2
      else {
        return StoreModel(id: -3);
      } // UnAuthorize and other status return null
    }
  }

  @override
  Stream<StoreState> eventHandler(StoreEvent event, StoreState state) async* {
    StoreModel storeModel;
    if (event is StoreEventSelect) {
      storeModel = await getStore(
        accessToken: event.accessToken,
        storeId: event.storeId,
      );
    } else if (event is StoreEventLoadPrevious) {
      storeModel = await loadPreviousStore(accessToken: event.accessToken);
    } else if (event is StoreEventSelecting) {
      storeModel = null;
      yield StoreState.selecting(storeId: event.storeId);
    }
    if (storeModel != null) {
      if (storeModel.id == -3) {
        yield StoreState.failure();
      } else if (storeModel.id == -2) {
        yield StoreState.selecting(storeId: -1);
      } // Select invalid store return not select
      else if (storeModel.id >= -1) {
        Helper.saveData(STORE_ID_KEY, storeModel.id, SavingType.Int);
        yield StoreState.selected(storeModel: storeModel);
      } // Select store successful!
    }
  }
}
