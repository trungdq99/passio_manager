import '../../models/date_report_model.dart';
import '../../bloc_helpers/bloc_event_state.dart';

class OverviewEvent extends BlocEvent {
  DateReportModel dateReportModel;
  OverviewEvent({this.dateReportModel});
}
