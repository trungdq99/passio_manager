import 'package:flutter/material.dart';

class StoreModel {
  int id;
  String name;
  String address;

  StoreModel({
    @required this.id,
    this.name: '',
    this.address: '',
  });

  StoreModel.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.name = map['name'];
    this.address = map['address'];
  }

  bool equalTo(StoreModel store) => this.id == store.id;
}
