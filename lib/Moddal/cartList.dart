class CarList{
  static  List<CartData> Items = [

  ];
}

class cartList {
  bool? status;
  int? totalProduct;
  List<CartData>? data;

  cartList({this.status, this.totalProduct, this.data});

  cartList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalProduct = json['total_product'];
    if (json['data'] != null) {
      data = <CartData>[];
      json['data'].forEach((v) {
        data!.add(new CartData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['total_product'] = this.totalProduct;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CartData {
  int? id;
  int? userId;
  int? productId;
  int? quantity;
  String? productSize;
  String? productName;
  int? series;
  String? price;
  String? image;
  String? createdAt;
  String? updatedAt;

  CartData(
      {this.id,
        this.userId,
        this.productId,
        this.quantity,
        this.productSize,
        this.productName,
        this.series,
        this.price,
        this.image,
        this.createdAt,
        this.updatedAt});

  CartData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    productId = json['product_id'];
    quantity = json['quantity'];
    productSize = json['product_size'];
    productName = json['product_name'];
    series = json['series'];
    price = json['price'];
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['product_id'] = this.productId;
    data['quantity'] = this.quantity;
    data['product_size'] = this.productSize;
    data['product_name'] = this.productName;
    data['series'] = this.series;
    data['price'] = this.price;
    data['image'] = this.image;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}