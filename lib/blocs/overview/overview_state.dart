import '../../models/date_report_model.dart';
import '../../bloc_helpers/bloc_event_state.dart';

class OverviewState implements BlocState {
  bool isOverview;
  bool isLoading;
  bool hasFailed;
  DateReportModel dateReport;

  OverviewState({
    this.isOverview: false,
    this.isLoading: false,
    this.hasFailed: false,
    this.dateReport,
  });

  factory OverviewState.overview(DateReportModel dateReport) {
    return OverviewState(
      isOverview: true,
      dateReport: dateReport,
    );
  }

  factory OverviewState.loading() {
    return OverviewState(
      isLoading: true,
    );
  }
  factory OverviewState.failure() {
    return OverviewState(
      hasFailed: true,
    );
  }
}
