import 'dart:core';

class allProduct {
  List<DataProduct>? dataProduct;
  String? profession;

  bool? status;

  allProduct({this.dataProduct, this.profession, this.status});

  allProduct.fromJson(Map<String, dynamic> json) {
    if (json['DataProduct'] != null) {
      dataProduct = <DataProduct>[];
      json['DataProduct'].forEach((v) { dataProduct!.add(new DataProduct.fromJson(v)); });
    }
    profession = json['profession'];

    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.dataProduct != null) {
      data['DataProduct'] = this.dataProduct!.map((v) => v.toJson()).toList();
    }
    data['profession'] = this.profession;

    data['status'] = this.status;
    return data;
  }
}

class DataProduct {
  String? name;
  String? price;
  String? image;
  int? category;
  late int id;

  DataProduct({this.name, this.price, this.image, this.category, required this.id});

  DataProduct.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    price = json['price'];
    image = json['image'];
    category = json['category'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['price'] = this.price;
    data['image'] = this.image;
    data['category'] = this.category;
    data['id'] = this.id;
    return data;
  }
}

