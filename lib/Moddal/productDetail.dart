class productdetail {
  Product? product;
  List<Null>? size;
  List<Photos>? photos;
  String? profession;
  bool? status;

  productdetail(
      {this.product, this.size, this.photos, this.profession, this.status});

  productdetail.fromJson(Map<String, dynamic> json) {
    product =
    json['product'] != null ? new Product.fromJson(json['product']) : null;
    if (json['size'] != null) {
      size = <Null>[];
      json['size'].forEach((v) {
       // size!.add(new Null.fromJson(v));
      });
    }
    if (json['photos'] != null) {
      photos = <Photos>[];
      json['photos'].forEach((v) {
        photos!.add(new Photos.fromJson(v));
      });
    }
    profession = json['profession'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    if (this.size != null) {
     // data['size'] = this.size!.map((v) => v.toJson()).toList();
    }
    if (this.photos != null) {
      data['photos'] = this.photos!.map((v) => v.toJson()).toList();
    }
    data['profession'] = this.profession;
    data['status'] = this.status;
    return data;
  }
}

class Product {
  int? id;
  String? createdAt;
  String? updatedAt;
  String? name;
  int? series;
  int? category;
  String? price;
  String? code;
  String? moduleSize;
  String? dp;
  String? cartonpack;
  String? masterpack;
  String? size;
  String? discount;
  String? dimension;
  String? description;
  String? image;
  String? images;

  Product(
      {this.id,
        this.createdAt,
        this.updatedAt,
        this.name,
        this.series,
        this.category,
        this.price,
        this.code,
        this.moduleSize,
        this.dp,
        this.cartonpack,
        this.masterpack,
        this.size,
        this.discount,
        this.dimension,
        this.description,
        this.image,
        this.images});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    name = json['name'];
    series = json['series'];
    category = json['category'];
    price = json['price'];
    code = json['code'];
    moduleSize = json['module_size'];
    dp = json['dp'];
    cartonpack = json['cartonpack'];
    masterpack = json['masterpack'];
    size = json['size'];
    discount = json['discount'];
    dimension = json['dimension'];
    description = json['description'];
    image = json['image'];
    images = json['images'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['name'] = this.name;
    data['series'] = this.series;
    data['category'] = this.category;
    data['price'] = this.price;
    data['code'] = this.code;
    data['module_size'] = this.moduleSize;
    data['dp'] = this.dp;
    data['cartonpack'] = this.cartonpack;
    data['masterpack'] = this.masterpack;
    data['size'] = this.size;
    data['discount'] = this.discount;
    data['dimension'] = this.dimension;
    data['description'] = this.description;
    data['image'] = this.image;
    data['images'] = this.images;
    return data;
  }
}

class Photos {
  String? url;

  Photos({this.url});

  Photos.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    return data;
  }
}
class productDataSize{
  static  List<Data1> Items = [

  ];
}
class sizeData {
  List<Data1>? data1;
  bool? status;

  sizeData({this.data1, this.status});

  sizeData.fromJson(Map<String, dynamic> json) {
    if (json['data1'] != null) {
      data1 = <Data1>[];
      json['data1'].forEach((v) {
        data1!.add(new Data1.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data1 != null) {
      data['data1'] = this.data1!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class Data1 {
  int? id;
  String? size;

  Data1({this.id, this.size});

  Data1.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    size = json['size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['size'] = this.size;
    return data;
  }
}