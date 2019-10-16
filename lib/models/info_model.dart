class Info {
  String itemId;
  String title;
  String subtitle;
  String description;
  Image image;
  Seller seller;
  Price price;

  Info({
    this.itemId,
    this.title,
    this.subtitle,
    this.description,
    this.image,
    this.seller,
    this.price,
  });

  factory Info.fromJson(Map<String, dynamic> parsedJson) => Info(
    itemId: parsedJson['itemId'],
    title: parsedJson['title'],
    subtitle: parsedJson['subtitle'],
    description: parsedJson['shortDescription'],
    image: Image.fromJson(parsedJson['image']),
    seller: Seller.fromJson(parsedJson['seller']),
    price: Price.fromJson(parsedJson['price']),
  );

  Map<String, dynamic> toJson() => {
    'itemId': itemId,
    'title': title,
    'subtitle': subtitle,
    'shortDescription': description,
    'image': image.toJson(),
    'seller': seller.toJson(),
    'price': price.toJson(),
  };
}

class Image {
  String imageUrl;

  Image({
    this.imageUrl,
  });

  factory Image.fromJson(Map<String, dynamic> json) => Image(
    imageUrl: json['imageUrl'],
  );

  Map<String, dynamic> toJson() => {
    'imageUrl': imageUrl,
  };
}

class Seller {
  String username;

  Seller({
    this.username,
  });

  factory Seller.fromJson(Map<String, dynamic> json) => Seller(
    username: json['username'],
  );

  Map<String, dynamic> toJson() => {
    'username': username,
  };
}

class Price {
  String value;
  String currency;

  Price({
    this.value,
    this.currency,
  });

  factory Price.fromJson(Map<String, dynamic> json) => Price(
    value: json["value"],
    currency: json["currency"],
  );

  Map<String, dynamic> toJson() => {
    "value": value,
    "currency": currency,
  };
}