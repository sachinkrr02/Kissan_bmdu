class orderHistory {
  List<Data>? data;
  bool? status;

  orderHistory({this.data, this.status});

  orderHistory.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class Data {
  int? id;
  int? userId;
  String? orderId;
  String? totalAmount;
  String? status;
  String? name;
  String? cinNo;
  String? address;
  int? quantity;
  String? assignId;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
        this.userId,
        this.orderId,
        this.totalAmount,
        this.status,
        this.name,
        this.cinNo,
        this.address,
        this.quantity,
        this.assignId,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    orderId = json['order_id'];
    totalAmount = json['total_amount'];
    status = json['status'];
    name = json['name'];
    cinNo = json['cin_no'];
    address = json['address'];
    quantity = json['quantity'];
    assignId = json['assign_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['order_id'] = this.orderId;
    data['total_amount'] = this.totalAmount;
    data['status'] = this.status;
    data['name'] = this.name;
    data['cin_no'] = this.cinNo;
    data['address'] = this.address;
    data['quantity'] = this.quantity;
    data['assign_id'] = this.assignId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}