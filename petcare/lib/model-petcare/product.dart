class Product {
  int? productId;
  String? productName;
  String? image;
  String? brand;
  double? price;
  String? description;
  int? quantity;
  String? createdDate;
  String? updatedDate;
  int? deliveryId;

  Product(
      {this.productId,
        this.productName,
        this.image,
        this.brand,
        this.price,
        this.description,
        this.quantity,
        this.createdDate,
        this.updatedDate,
        this.deliveryId});

  Product.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    productName = json['productName'];
    image = json['image'];
    brand = json['brand'];
    price = json['price'];
    description = json['description'];
    quantity = json['quantity'];
    createdDate = json['createdDate'];
    updatedDate = json['updatedDate'];
    deliveryId = json['deliveryId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['productName'] = this.productName;
    data['image'] = this.image;
    data['brand'] = this.brand;
    data['price'] = this.price;
    data['description'] = this.description;
    data['quantity'] = this.quantity;
    data['createdDate'] = this.createdDate;
    data['updatedDate'] = this.updatedDate;
    data['deliveryId'] = this.deliveryId;
    return data;
  }
}
