class ProductModel {
    ProductModel({
        this.image,
        this.productName,
        this.price,
        this.productModel,
        this.description,
    });

    final String? image;
    final String? productName;
    final String? price;
    final String? productModel;
    final String? description;

    factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        image: json["image"],
        productName: json["product_name"],
        price: json["price"],
        productModel: json["product_model"],
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "image": image,
        "product_name": productName,
        "price": price,
        "product_model": productModel,
        "description": description,
    };
}
