class DateReportModel {
  String from;
  String to;
  double totalAmount;
  double finalAmount;
  double discount;
  double discountOrderDetail;
  double totalCash;
  int totalOrder;
  int totalOrderAtStore;
  int totalOrderTakeAway;
  int totalOrderDelivery;
  double totalOrderDetail;
  double totalOrderFeeItem;
  int totalOrderCard;
  int totalOrderCanceled;
  int totalOrderPreCanceled;
  double finalAmountAtStore;
  double finalAmountTakeAway;
  double finalAmountDelivery;
  double finalAmountCard;
  double finalAmountCanceled;
  double finalAmountPreCanceled;

  DateReportModel({
    this.from: '',
    this.to: '',
    this.totalAmount: 0,
    this.finalAmount: 0,
    this.discount: 0,
    this.discountOrderDetail: 0,
    this.totalCash: 0,
    this.totalOrder: 0,
    this.totalOrderAtStore: 0,
    this.totalOrderTakeAway: 0,
    this.totalOrderDelivery: 0,
    this.totalOrderDetail: 0,
    this.totalOrderFeeItem: 0,
    this.totalOrderCard: 0,
    this.totalOrderCanceled: 0,
    this.totalOrderPreCanceled: 0,
    this.finalAmountAtStore: 0,
    this.finalAmountTakeAway: 0,
    this.finalAmountDelivery: 0,
    this.finalAmountCard: 0,
    this.finalAmountCanceled: 0,
    this.finalAmountPreCanceled: 0,
  });

  DateReportModel.fromJson(Map<String, dynamic> json) {
    if (json['from'] != null) {
      this.from = json['from']?.toString();
    }
    if (json['to'] != null) {
      this.to = json['to']?.toString();
    }
    if (json['total_amount'] != null) {
      this.totalAmount = json['total_amount']?.toDouble();
    }
    if (json['final_amount'] != null) {
      this.finalAmount = json['final_amount']?.toDouble();
    }
    if (json['discount'] != null) {
      this.discount = json['discount']?.toDouble();
    }
    if (json['discount_order_detail'] != null) {
      this.discountOrderDetail = json['discount_order_detail']?.toDouble();
    }
    if (json['total_cash'] != null) {
      this.totalCash = json['total_cash']?.toDouble();
    }
    if (json['total_order'] != null) {
      this.totalOrder = json['total_order']?.toInt();
    }
    if (json['total_order_at_store'] != null) {
      this.totalOrderAtStore = json['total_order_at_store']?.toInt();
    }
    if (json['total_order_take_away'] != null) {
      this.totalOrderTakeAway = json['total_order_take_away']?.toInt();
    }
    if (json['total_order_delivery'] != null) {
      this.totalOrderDelivery = json['total_order_delivery']?.toInt();
    }
    if (json['total_order_detail'] != null) {
      this.totalOrderDetail = json['total_order_detail']?.toDouble();
    }
    if (json['total_order_fee_item'] != null) {
      this.totalOrderFeeItem = json['total_order_fee_item']?.toDouble();
    }
    if (json['total_order_card'] != null) {
      this.totalOrderCard = json['total_order_card']?.toInt();
    }
    if (json['total_order_canceled'] != null) {
      this.totalOrderCanceled = json['total_order_canceled']?.toInt();
    }
    if (json['total_order_pre_canceled'] != null) {
      this.totalOrderPreCanceled = json['total_order_pre_canceled']?.toInt();
    }
    if (json['final_amount_at_store'] != null) {
      this.finalAmountAtStore = json['final_amount_at_store']?.toDouble();
    }
    if (json['final_amount_take_away'] != null) {
      this.finalAmountTakeAway = json['final_amount_take_away']?.toDouble();
    }
    if (json['final_amount_delivery'] != null) {
      this.finalAmountDelivery = json['final_amount_delivery']?.toDouble();
    }
    if (json['final_amount_card'] != null) {
      this.finalAmountCard = json['final_amount_card']?.toDouble();
    }
    if (json['final_amount_canceled'] != null) {
      this.finalAmountCanceled = json['final_amount_canceled']?.toDouble();
    }
    if (json['final_amount_pre_canceled'] != null) {
      this.finalAmountPreCanceled =
          json['final_amount_pre_canceled']?.toDouble();
    }
  }

  Map<String, dynamic> dateReportModelToJson(DateReportModel dateReportModel) {
    final Map<String, dynamic> map = new Map<String, dynamic>();
    map['from'] = dateReportModel.from;
    map['to'] = dateReportModel.to;
    map['total_amount'] = dateReportModel.totalAmount;
    map['final_amount'] = dateReportModel.finalAmount;
    map['discount'] = dateReportModel.discount;
    map['discount_order_detail'] = dateReportModel.discountOrderDetail;
    map['total_cash'] = dateReportModel.totalCash;
    map['total_order'] = dateReportModel.totalOrder;
    map['total_order_at_store'] = dateReportModel.totalOrderAtStore;
    map['total_order_take_away'] = dateReportModel.totalOrderTakeAway;
    map['total_order_delivery'] = dateReportModel.totalOrderDelivery;
    map['total_order_detail'] = dateReportModel.totalOrderDetail;
    map['total_order_fee_item'] = dateReportModel.totalOrderFeeItem;
    map['total_order_card'] = dateReportModel.totalOrderCard;
    map['total_order_canceled'] = dateReportModel.totalOrderCanceled;
    map['total_order_pre_canceled'] = dateReportModel.totalOrderPreCanceled;
    map['final_amount_at_store'] = dateReportModel.finalAmountAtStore;
    map['final_amount_take_away'] = dateReportModel.finalAmountTakeAway;
    map['final_amount_delivery'] = dateReportModel.finalAmountDelivery;
    map['final_amount_card'] = dateReportModel.finalAmountCard;
    map['final_amount_canceled'] = dateReportModel.finalAmountCanceled;
    map['final_amount_pre_canceled'] = dateReportModel.finalAmountPreCanceled;
    return map;
  }

  @override
  String toString() {
    return 'DateReportModel{from: $from, to: $to, totalAmount: $totalAmount, finalAmount: $finalAmount, discount: $discount, discountOrderDetail: $discountOrderDetail, totalCash: $totalCash, totalOrder: $totalOrder, totalOrderAtStore: $totalOrderAtStore, totalOrderTakeAway: $totalOrderTakeAway, totalOrderDelivery: $totalOrderDelivery, totalOrderDetail: $totalOrderDetail, totalOrderFeeItem: $totalOrderFeeItem, totalOrderCard: $totalOrderCard, totalOrderCanceled: $totalOrderCanceled, totalOrderPreCanceled: $totalOrderPreCanceled, finalAmountAtStore: $finalAmountAtStore, finalAmountTakeAway: $finalAmountTakeAway, finalAmountDelivery: $finalAmountDelivery, finalAmountCard: $finalAmountCard, finalAmountCanceled: $finalAmountCanceled, finalAmountPreCanceled: $finalAmountPreCanceled}';
  }
}
