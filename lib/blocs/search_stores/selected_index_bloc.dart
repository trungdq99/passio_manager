import 'package:rxdart/rxdart.dart';
import '../../bloc_helpers/bloc_base.dart';

class SelectedIndexBloc implements BlocBase {
  final BehaviorSubject<int> _selectedIndexController = BehaviorSubject();
  Stream<int> get selectedIndex => _selectedIndexController.stream;

  setIndex(int index) {
    _selectedIndexController.sink.add(index);
  }

  @override
  void dispose() {
    _selectedIndexController?.close();
  }
}
