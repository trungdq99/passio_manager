import '../../models/store_model.dart';
import 'package:rxdart/rxdart.dart';

import '../../bloc_helpers/bloc_base.dart';

class SelectedStoreBloc implements BlocBase {
  final BehaviorSubject<int> _selectedStoreController = BehaviorSubject();
  Stream<int> get selectedIndex => _selectedStoreController.stream;

  setIndex(int index) {
    _selectedStoreController.sink.add(index);
  }

  @override
  void dispose() {
    _selectedStoreController?.close();
  }
}
