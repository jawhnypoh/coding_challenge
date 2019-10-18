// Overall Info Class for DetailedItem Screen
class Info {
  String itemId;
  String title;
  String condition;
  String brand;
  String description;
  ItemImage itemImage;
  Seller seller;
  Price price;
  List<ShippingOption> shippingOptions;

  Info({
    this.itemId,
    this.title,
    this.condition,
    this.brand,
    this.description,
    this.itemImage,
    this.seller,
    this.price,
    this.shippingOptions,
  });

  factory Info.fromJson(Map<String, dynamic> parsedJson) => Info(
    itemId: parsedJson['itemId'],
    title: parsedJson['title'],
    condition: parsedJson['condition'],
    brand: parsedJson['brand'],
    description: parsedJson['shortDescription'],
    itemImage: ItemImage.fromJson(parsedJson['image']),
    seller: Seller.fromJson(parsedJson['seller']),
    price: Price.fromJson(parsedJson['price']),
    shippingOptions: List<ShippingOption>.from(parsedJson['shippingOptions'].map((x) => ShippingOption.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    'itemId': itemId,
    'title': title,
    'condition': condition,
    'brand': brand,
    'shortDescription': description,
    'itemImage': itemImage.toJson(),
    'seller': seller.toJson(),
    'price': price.toJson(),
    'shippingOptions': List<dynamic>.from(shippingOptions.map((x) => x.toJson())),
  };
}

// ItemImage class for image that loads at the top of the screen
class ItemImage {
  String imageUrl;

  ItemImage({
    this.imageUrl,
  });

  factory ItemImage.fromJson(Map<String, dynamic> parsedJson) => ItemImage(
    imageUrl: parsedJson['imageUrl'],
  );

  Map<String, dynamic> toJson() => {
    'imageUrl': imageUrl,
  };
}

// Seller class for Sold By:
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

// Price class for determining the price
class Price {
  String value;
  String currency;

  Price({
    this.value,
    this.currency,
  });

  factory Price.fromJson(Map<String, dynamic> parsedJson) => Price(
    value: parsedJson['value'],
    currency: parsedJson['currency'],
  );

  Map<String, dynamic> toJson() => {
    'value': value,
    'currency': currency,
  };
}

// Shipping Options class for estimating shipping dates
class ShippingOption {
  Price shippingCost;
  int quantityUsedForEstimate;
  DateTime minEstimatedDeliveryDate;
  DateTime maxEstimatedDeliveryDate;

  ShippingOption({
    this.shippingCost,
    this.quantityUsedForEstimate,
    this.minEstimatedDeliveryDate,
    this.maxEstimatedDeliveryDate,
  });

  factory ShippingOption.fromJson(Map<String, dynamic> json) => ShippingOption(
    shippingCost: Price.fromJson(json['shippingCost']),
    quantityUsedForEstimate: json['quantityUsedForEstimate'],
    minEstimatedDeliveryDate: DateTime.parse(json['minEstimatedDeliveryDate']),
    maxEstimatedDeliveryDate: DateTime.parse(json['maxEstimatedDeliveryDate']),
  );

  Map<String, dynamic> toJson() => {
    'shippingCost': shippingCost.toJson(),
    'quantityUsedForEstimate': quantityUsedForEstimate,
    'minEstimatedDeliveryDate': minEstimatedDeliveryDate.toIso8601String(),
    'maxEstimatedDeliveryDate': maxEstimatedDeliveryDate.toIso8601String(),
  };
}