class Info {
  String itemId;
  String title;
  String condition;
  String description;
  ItemImage itemImage;
  Seller seller;
  Price price;

  Info({
    this.itemId,
    this.title,
    this.condition,
    this.description,
    this.itemImage,
    this.seller,
    this.price,
  });

  factory Info.fromJson(Map<String, dynamic> parsedJson) => Info(
    itemId: parsedJson['itemId'],
    title: parsedJson['title'],
    condition: parsedJson['condition'],
    description: parsedJson['shortDescription'],
    itemImage: ItemImage.fromJson(parsedJson['image']),
    seller: Seller.fromJson(parsedJson['seller']),
    price: Price.fromJson(parsedJson['price']),
  );

  Map<String, dynamic> toJson() => {
    'itemId': itemId,
    'title': title,
    'condition': condition,
    'shortDescription': description,
    'itemImage': itemImage.toJson(),
    'seller': seller.toJson(),
    'price': price.toJson(),
  };
}

class ItemImage {
  String imageUrl;

  ItemImage({
    this.imageUrl,
  });

  factory ItemImage.fromJson(Map<String, dynamic> json) => ItemImage(
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