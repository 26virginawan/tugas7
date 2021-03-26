class Item {
  int _id;
  String _name;
  int _price;
  int _stok;
  int _kdbrg;

  int get kdbrg => this._kdbrg;

  set kdbrg(int value) => this._kdbrg = value;

  int get stok => this._stok;

  set stok(int value) => this._stok = value;

  int get id => _id;
  String get name => this._name;
  set name(String value) => this._name = value;
  get price => this._price;
  set price(value) => this._price = value;
// konstruktor versi 1
  Item(this._name, this._price, this._stok, this._kdbrg);

  Item.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
    this._price = map['price'];
    this._stok = map['stok'];
    this._kdbrg = map['kdbrg'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = this._id;
    map['name'] = name;
    map['price'] = price;
    map['stok'] = stok;
    map['kdbrg'] = kdbrg;
    return map;
  }
}
