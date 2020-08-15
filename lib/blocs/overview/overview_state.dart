import '../../bloc_helpers/bloc_event_state.dart';

class OverviewState implements BlocState {
  bool isLoad;
  bool isLoading;
  bool hasFailed;
  bool showRevenue;
  bool showReceipts;

  OverviewState({
    this.isLoad: false,
    this.isLoading: false,
    this.hasFailed: false,
    this.showRevenue: false,
    this.showReceipts: false,
  });

  factory OverviewState.load() {
    return OverviewState(
      isLoad: true,
    );
  }

  factory OverviewState.showRevenue() {
    return OverviewState(
      showRevenue: true,
    );
  }

  factory OverviewState.showReceipts() {
    return OverviewState(
      showRevenue: true,
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
