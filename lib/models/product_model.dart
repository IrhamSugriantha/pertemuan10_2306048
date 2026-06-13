import 'dart:convert';

class ProductModel {
  // membuat variabel data
  final String name;
  final String description;
  final int price;
  //jika data tidak wjib
  //final string? tidak_wajib;

  // constructor
  ProductModel({
    required this.name,
    required this.description,
    required this.price,
    //this.tidak_wajib
  });

  //object->Map
  Map<String, dynamic> toMap(){
    return{
      'name':name,
      'description':description,
      'price':price,
    };
  }

  // map->object
  factory ProductModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return ProductModel(
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: map['price'] ?? 0,
    );
  }

  // object->string
  String toJson() => jsonEncode(toMap());

  // json string->object
  factory ProductModel.fromJson(String source){
    return ProductModel.fromMap(
      jsonDecode(source),
    );
  }
}