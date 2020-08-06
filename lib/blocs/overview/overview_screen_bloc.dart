import 'package:flutter/material.dart';
import '../../utils/constant.dart';

import '../../bloc_helpers/bloc_base.dart';
import 'package:rxdart/rxdart.dart';

class OverviewScreenBloc implements BlocBase {
  onScroll(double offset) {
    if (offset < 300) {
      _filterIconController.sink.add(FILTER_WHITE_ICON_PATH);
      _shareIconController.sink.add(SHARE_WHITE_ICON_PATH);
      _appBarColorController.sink.add(Colors.white);
    } else {
      _filterIconController.sink.add(FILTER_ICON_PATH);
      _shareIconController.sink.add(SHARE_ICON_PATH);
      _appBarColorController.sink.add(Colors.black);
    }
  }

  BehaviorSubject<String> _filterIconController = BehaviorSubject();
  BehaviorSubject<String> _shareIconController = BehaviorSubject();
  BehaviorSubject<Color> _appBarColorController = BehaviorSubject();

  Stream<String> get filterIcon => _filterIconController.stream;
  Stream<String> get shareIcon => _shareIconController.stream;
  Stream<Color> get appBarColor => _appBarColorController.stream;

  @override
  void dispose() {
    _filterIconController.close();
    _shareIconController.close();
    _appBarColorController.close();
  }
}
