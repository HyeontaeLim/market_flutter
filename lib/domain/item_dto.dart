class ItemDto {
  final int _itemId;
  final String _itemName;
  final int _price;
  final int _quantity;
  final String _img;
  final bool _status;
  final String _catName;
  final int _categoryId;


  ItemDto(this._itemId, this._itemName, this._price, this._quantity, this._img,
      this._status, this._catName, this._categoryId);

  factory ItemDto.fromJson(Map<String, dynamic> json)=>
      ItemDto(
          json["itemId"],
          json["itemName"],
          json["price"],
          json["quantity"],
          json["img"],
          json["status"],
          json["catName"],
          json["categoryId"]);

  Map<String, dynamic> toJson() => {
    'itemId': _itemId,
    'itemName': _itemName,
    'price': _price,
    'quantity': _quantity,
    'img': _img,
    'status': _status,
    'catName': _catName,
    'categoryId': _categoryId
  };


  String get catName => _catName;

  bool get status => _status;

  String get img => _img;

  int get quantity => _quantity;

  int get price => _price;

  String get itemName => _itemName;

  int get itemId => _itemId;

  int get categoryId => _categoryId;

}