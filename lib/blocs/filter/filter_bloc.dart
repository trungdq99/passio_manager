import 'package:flutter/material.dart';
import 'package:http/http.dart' show Response;
import '../../models/store_model.dart';
import '../../repository/repository.dart';
import '../../utils/constant.dart';
import '../../utils/helper.dart';

import '../../bloc_helpers/bloc_event_state.dart';
import './filter_event.dart';
import './filter_state.dart';

class FilterBloc extends BlocEventStateBase<FilterEvent, FilterState> {
  FilterBloc() : super(initialState: FilterState.defaultReport());
  @override
  Stream<FilterState> eventHandler(
      FilterEvent event, FilterState state) async* {
    if (event is FilterEventLoadPreviousStore) {
      yield FilterState.selecting();
      _storeModel = null;
      _storeModel = await loadPreviousStore(accessToken: event.accessToken);
      await Future.delayed(Duration(milliseconds: 1000));
      if (_storeModel != null) {
        if (_storeModel.id == -3) {
          yield FilterState.failure();
        } else if (_storeModel.id == -2) {
          yield FilterState.notSelectStore();
        } // Select invalid store return not select
        else if (_storeModel.id >= -1) {
          yield FilterState.selected(
            storeModel: _storeModel,
            dateTimeRange: state.dateTimeRange,
          );
        } // Select store successful!
      }
    } // Load previous store
    else if (event is FilterEventSelected) {
      Helper.saveData(STORE_ID_KEY, event.storeModel.id, SavingType.Int);
      _storeModel = event.storeModel;
      _dateTimeRange = event.dateTimeRange;
      yield FilterState.selected(
        dateTimeRange: _dateTimeRange,
        storeModel: _storeModel,
      );
    } else if (event is FilterEventOverview) {
      yield FilterState.overview(
        storeModel: _storeModel,
        dateTimeRange: _dateTimeRange,
      );
    } else if (event is FilterEventUpdate) {
      yield FilterState.update(
        storeModel: event.storeModel,
        dateTimeRange: event.dateTimeRange,
      );
    } else if (event is FilterEventReport) {
      yield FilterState.report(event.dateTimeRange, event.storeModel);
    } else if (event is FilterEventDefaultOverview) {
      yield FilterState.defaultOverview();
    }
  }

  Future<StoreModel> loadPreviousStore({String accessToken}) async {
    int storeId = await Helper.loadData(STORE_ID_KEY, SavingType.Int);
    if (storeId == null) {
      return StoreModel(id: -2);
    } // Store hasn't selected yet!
    else if (storeId == -1) {
      return StoreModel(id: -1);
    } // Select all stores
    else {
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

  StoreModel _storeModel;
  DateTimeRange _dateTimeRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );
  StoreModel get storeModel => _storeModel;
  DateTimeRange get dateTimeRange => _dateTimeRange;
}
