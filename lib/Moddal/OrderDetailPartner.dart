
class OrderDetailParnters{
  static  List<PartnerOrderDetail> Items = [

  ];
}

class getaddresspartner{
  static  List<UserData> Items = [

  ];
}



class OrderDetailParnter {
  List<PartnerOrderDetail>? partnerOrderDetail;
  bool? status;

  OrderDetailParnter({this.partnerOrderDetail, this.status});

  OrderDetailParnter.fromJson(Map<String, dynamic> json) {
    if (json['PartnerOrderDetail'] != null) {
      partnerOrderDetail = <PartnerOrderDetail>[];
      json['PartnerOrderDetail'].forEach((v) {
        partnerOrderDetail!.add(new PartnerOrderDetail.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.partnerOrderDetail != null) {
      data['PartnerOrderDetail'] =
          this.partnerOrderDetail!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class PartnerOrderDetail {
  int? id;
  String? orderId;
  String? productName;
  String? image;
  int? quantity;
  int? series;
  int? price;
  String? size;
  String? code;
  String? createdAt;
  String? updatedAt;

  PartnerOrderDetail(
      {this.id,
        this.orderId,
        this.productName,
        this.image,
        this.quantity,
        this.series,
        this.price,
        this.size,
        this.code,
        this.createdAt,
        this.updatedAt});

  PartnerOrderDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    productName = json['product_name'];
    image = json['image'];
    quantity = json['quantity'];
    series = json['series'];
    price = json['price'];
    size = json['size'];
    code = json['code'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['product_name'] = this.productName;
    data['image'] = this.image;
    data['quantity'] = this.quantity;
    data['series'] = this.series;
    data['price'] = this.price;
    data['size'] = this.size;
    data['code'] = this.code;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
class getaddress {
  List<UserData>? userData;
  bool? status;

  getaddress({this.userData, this.status});

  getaddress.fromJson(Map<String, dynamic> json) {
    if (json['userData'] != null) {
      userData = <UserData>[];
      json['userData'].forEach((v) {
        userData!.add(new UserData.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userData != null) {
      data['userData'] = this.userData!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class UserData {
  int? id;
  String? name;
  String? email;
  Null? role;
  Null? permissions;
  Null? emailVerifiedAt;
  String? mobileNo;
  String? profession;
  String? createdAt;
  String? updatedAt;
  String? uniqId;
  String? gender;
  String? dob;
  int? whatsappNumber;
  String? address;
  int? pincode;
  String? country;
  String? state;
  String? city;
  String? assign;
  Null? bankName;
  Null? acNumber;
  Null? ifscCode;
  Null? holderName;
  Null? paytmNo;
  Null? googlepayNo;
  Null? phonepayNo;
  Null? cancelledCheque;
  Null? passbook;
  Null? paytmKyc;
  int? aadharNo;
  String? aadharFront;
  String? aadharBack;
  Null? panNo;
  Null? gstNo;
  String? panCard;
  String? gstCertificate;
  String? shopImage;
  Null? nationality;
  Null? maritalStatus;
  Null? childrenInfo;
  Null? oneChildName;
  Null? oneChildDate;
  Null? oneChildStudy;
  Null? secondChildName;
  Null? secondChildDate;
  Null? secondChildStudy;
  Null? thirdChildName;
  Null? thirdChildDate;
  Null? thirdChildStudy;
  Null? bloodgroup;
  Null? experiance;
  Null? reading;
  Null? writing;
  Null? speaking;
  Null? partner;
  String? assignDealer;
  Null? identificationId;
  String? businessName;
  String? profilePic;
  String? anniversary;
  String? status;

  UserData(
      {this.id,
        this.name,
        this.email,
        this.role,
        this.permissions,
        this.emailVerifiedAt,
        this.mobileNo,
        this.profession,
        this.createdAt,
        this.updatedAt,
        this.uniqId,
        this.gender,
        this.dob,
        this.whatsappNumber,
        this.address,
        this.pincode,
        this.country,
        this.state,
        this.city,
        this.assign,
        this.bankName,
        this.acNumber,
        this.ifscCode,
        this.holderName,
        this.paytmNo,
        this.googlepayNo,
        this.phonepayNo,
        this.cancelledCheque,
        this.passbook,
        this.paytmKyc,
        this.aadharNo,
        this.aadharFront,
        this.aadharBack,
        this.panNo,
        this.gstNo,
        this.panCard,
        this.gstCertificate,
        this.shopImage,
        this.nationality,
        this.maritalStatus,
        this.childrenInfo,
        this.oneChildName,
        this.oneChildDate,
        this.oneChildStudy,
        this.secondChildName,
        this.secondChildDate,
        this.secondChildStudy,
        this.thirdChildName,
        this.thirdChildDate,
        this.thirdChildStudy,
        this.bloodgroup,
        this.experiance,
        this.reading,
        this.writing,
        this.speaking,
        this.partner,
        this.assignDealer,
        this.identificationId,
        this.businessName,
        this.profilePic,
        this.anniversary,
        this.status});

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    role = json['role'];
    permissions = json['permissions'];
    emailVerifiedAt = json['email_verified_at'];
    mobileNo = json['mobile_no'];
    profession = json['profession'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    uniqId = json['uniq_id'];
    gender = json['gender'];
    dob = json['dob'];
    whatsappNumber = json['whatsapp_number'];
    address = json['address'];
    pincode = json['pincode'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    assign = json['assign'];
    bankName = json['bank_name'];
    acNumber = json['Ac_number'];
    ifscCode = json['ifsc_code'];
    holderName = json['holder_name'];
    paytmNo = json['paytm_no'];
    googlepayNo = json['googlepay_no'];
    phonepayNo = json['phonepay_no'];
    cancelledCheque = json['cancelled_cheque'];
    passbook = json['passbook'];
    paytmKyc = json['paytm_kyc'];
    aadharNo = json['aadhar_no'];
    aadharFront = json['aadhar_front'];
    aadharBack = json['aadhar_back'];
    panNo = json['pan_no'];
    gstNo = json['gst_no'];
    panCard = json['pan_card'];
    gstCertificate = json['gst_certificate'];
    shopImage = json['shop_image'];
    nationality = json['nationality'];
    maritalStatus = json['marital_status'];
    childrenInfo = json['children_info'];
    oneChildName = json['oneChildName'];
    oneChildDate = json['oneChildDate'];
    oneChildStudy = json['oneChildStudy'];
    secondChildName = json['secondChildName'];
    secondChildDate = json['secondChildDate'];
    secondChildStudy = json['secondChildStudy'];
    thirdChildName = json['thirdChildName'];
    thirdChildDate = json['thirdChildDate'];
    thirdChildStudy = json['thirdChildStudy'];
    bloodgroup = json['bloodgroup'];
    experiance = json['experiance'];
    reading = json['reading'];
    writing = json['writing'];
    speaking = json['speaking'];
    partner = json['partner'];
    assignDealer = json['assign_dealer'];
    identificationId = json['identification_id'];
    businessName = json['business_name'];
    profilePic = json['profile_pic'];
    anniversary = json['anniversary'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['role'] = this.role;
    data['permissions'] = this.permissions;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['mobile_no'] = this.mobileNo;
    data['profession'] = this.profession;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['uniq_id'] = this.uniqId;
    data['gender'] = this.gender;
    data['dob'] = this.dob;
    data['whatsapp_number'] = this.whatsappNumber;
    data['address'] = this.address;
    data['pincode'] = this.pincode;
    data['country'] = this.country;
    data['state'] = this.state;
    data['city'] = this.city;
    data['assign'] = this.assign;
    data['bank_name'] = this.bankName;
    data['Ac_number'] = this.acNumber;
    data['ifsc_code'] = this.ifscCode;
    data['holder_name'] = this.holderName;
    data['paytm_no'] = this.paytmNo;
    data['googlepay_no'] = this.googlepayNo;
    data['phonepay_no'] = this.phonepayNo;
    data['cancelled_cheque'] = this.cancelledCheque;
    data['passbook'] = this.passbook;
    data['paytm_kyc'] = this.paytmKyc;
    data['aadhar_no'] = this.aadharNo;
    data['aadhar_front'] = this.aadharFront;
    data['aadhar_back'] = this.aadharBack;
    data['pan_no'] = this.panNo;
    data['gst_no'] = this.gstNo;
    data['pan_card'] = this.panCard;
    data['gst_certificate'] = this.gstCertificate;
    data['shop_image'] = this.shopImage;
    data['nationality'] = this.nationality;
    data['marital_status'] = this.maritalStatus;
    data['children_info'] = this.childrenInfo;
    data['oneChildName'] = this.oneChildName;
    data['oneChildDate'] = this.oneChildDate;
    data['oneChildStudy'] = this.oneChildStudy;
    data['secondChildName'] = this.secondChildName;
    data['secondChildDate'] = this.secondChildDate;
    data['secondChildStudy'] = this.secondChildStudy;
    data['thirdChildName'] = this.thirdChildName;
    data['thirdChildDate'] = this.thirdChildDate;
    data['thirdChildStudy'] = this.thirdChildStudy;
    data['bloodgroup'] = this.bloodgroup;
    data['experiance'] = this.experiance;
    data['reading'] = this.reading;
    data['writing'] = this.writing;
    data['speaking'] = this.speaking;
    data['partner'] = this.partner;
    data['assign_dealer'] = this.assignDealer;
    data['identification_id'] = this.identificationId;
    data['business_name'] = this.businessName;
    data['profile_pic'] = this.profilePic;
    data['anniversary'] = this.anniversary;
    data['status'] = this.status;
    return data;
  }
}