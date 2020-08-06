import '../../utils/constant.dart';
import '../../utils/helper.dart';
import '../../models/date_report_model.dart';
import '../../repository/repository.dart';
import '../../bloc_helpers/bloc_event_state.dart';
import './overview_event.dart';
import './overview_state.dart';
import 'package:http/http.dart' show Response;

class OverviewBloc extends BlocEventStateBase<OverviewEvent, OverviewState> {
  OverviewBloc() : super(initialState: OverviewState.loading());
  @override
  Stream<OverviewState> eventHandler(
      OverviewEvent event, OverviewState state) async* {
    yield OverviewState.loading();
    await Future.delayed(Duration(milliseconds: 1500));
    if (event.dateReportModel == null) {
      yield OverviewState.failure();
    } else {
      yield OverviewState.overview(event.dateReportModel);
    }
  }

  Future<DateReportModel> getDateReport(
      String accessToken, String from, String to, int storeId) async {
    if (storeId < -1) {
      return null;
    } else {
      Repository repository = Repository();
      String api = GET_DATE_REPORT_API;
      if (storeId == -1) {
        api += '/all-stores?from=$from&to=$to';
      } else {
        api += '?from=$from&to=$to&storeId=$storeId';
      }
      DateReportModel dateReportModel;
      Response response = await repository.fetchData('$api', RequestMethod.GET,
          Helper.getAuthorizeHeader(accessToken), null);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = Helper.decodeJson(response.body);
        dateReportModel = DateReportModel.fromJson(responseBody);
        print(dateReportModel.toString());
      } else if (response.statusCode == 404) {
        dateReportModel = DateReportModel();
      } else {
        dateReportModel = null;
      }
      return dateReportModel;
    }
  }
}
