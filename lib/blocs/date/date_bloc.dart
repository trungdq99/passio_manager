import './date_state.dart';
import './date_event.dart';
import '../../bloc_helpers/bloc_event_state.dart';

class DateBloc extends BlocEventStateBase<DateEvent, DateState> {
  DateBloc() : super(initialState: DateState.notSelected());

  @override
  Stream<DateState> eventHandler(DateEvent event, DateState state) async* {
    if (event is DateEventSelected) {
      if (event.dateTimeRange.duration.isNegative) {
        yield DateState.failure();
      } else {
        yield DateState.selected(event.dateTimeRange);
      } // Select Date successful!
    } else {
      yield DateState.selecting(event.dateTimeRange);
    }
  }
}
