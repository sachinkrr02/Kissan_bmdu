class mainPage {
  String? name;
  String? mobileNo;
  String? cinNo;
  String? registerAt;
  String? userStatus;
  String? profession;
  int? totalPoint;
  int? redeem;
  List<Banner>? banner;
  int? percentage;
  String? location;
  bool? status;

  mainPage(
      {this.name,
        this.mobileNo,
        this.cinNo,
        this.registerAt,
        this.userStatus,
        this.profession,
        this.totalPoint,
        this.redeem,
        this.banner,
        this.percentage,
        this.location,
        this.status});

  mainPage.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    mobileNo = json['mobile_no'];
    cinNo = json['Cin_no'];
    registerAt = json['register_at'];
    userStatus = json['user_status'];
    profession = json['profession'];
    totalPoint = json['total_point'];
    redeem = json['redeem'];
    if (json['banner'] != null) {
      banner = <Banner>[];
      json['banner'].forEach((v) {
        banner!.add(new Banner.fromJson(v));
      });
    }
    percentage = json['percentage'];
    location = json['location'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['mobile_no'] = this.mobileNo;
    data['Cin_no'] = this.cinNo;
    data['register_at'] = this.registerAt;
    data['user_status'] = this.userStatus;
    data['profession'] = this.profession;
    data['total_point'] = this.totalPoint;
    data['redeem'] = this.redeem;
    if (this.banner != null) {
      data['banner'] = this.banner!.map((v) => v.toJson()).toList();
    }
    data['percentage'] = this.percentage;
    data['location'] = this.location;
    data['status'] = this.status;
    return data;
  }
}

class Banner {
  int? id;
  String? banner;
  Null? createdAt;
  Null? updatedAt;

  Banner({this.id, this.banner, this.createdAt, this.updatedAt});

  Banner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    banner = json['banner'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['banner'] = this.banner;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}