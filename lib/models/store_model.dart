import 'package:flutter/material.dart';

class StoreModel {
  int id;
  // ID = -3 : un authorize
  // ID = -2 : not select
  // ID = -1 : All Stores
  // ID >= 0 : existed store
  String name;
  String address;

  StoreModel({
    @required this.id,
    this.name: 'Tất cả cửa hàng',
    this.address: '',
  });
  // StoreModel is null => UnAuthorize, State is failure
  StoreModel.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.name = map['name'];
    this.address = map['address'];
  }
}
