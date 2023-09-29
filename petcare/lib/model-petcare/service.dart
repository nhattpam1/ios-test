class Service {
  int? serviceId;
  String? serviceName;
  String? image;
  String? description;
  double? price;
  String? createdDate;
  String? updatedDate;

  Service(
      {this.serviceId,
        this.serviceName,
        this.image,
        this.description,
        this.price,
        this.createdDate,
        this.updatedDate});

  Service.fromJson(Map<String, dynamic> json) {
    serviceId = json['serviceId'];
    serviceName = json['serviceName'];
    image = json['image'];
    description = json['description'];
    price = json['price'];
    createdDate = json['createdDate'];
    updatedDate = json['updatedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['serviceId'] = this.serviceId;
    data['serviceName'] = this.serviceName;
    data['image'] = this.image;
    data['description'] = this.description;
    data['price'] = this.price;
    data['createdDate'] = this.createdDate;
    data['updatedDate'] = this.updatedDate;
    return data;
  }
}
