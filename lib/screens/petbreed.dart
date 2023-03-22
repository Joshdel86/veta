class PetBreed {
    PetBreed({
        this.petImage,
        this.petName,
        this.petPrice,
        this.petBreed,
        this.petDescription,
    });

    String? petImage;
    String? petName;
    String? petPrice;
    String? petBreed;
    String? petDescription;

    factory PetBreed.fromJson(Map<String, dynamic> json) => PetBreed(
        petImage: json["pet_image"],
        petName: json["pet_name"],
        petPrice: json["pet_price"],
        petBreed: json["pet_breed"],
        petDescription: json["pet_description"],
    );

    Map<String, dynamic> toJson() => {
        "pet_image": petImage,
        "pet_name": petName,
        "pet_price": petPrice,
        "pet_breed": petBreed,
        "pet_description": petDescription,
    };
}
