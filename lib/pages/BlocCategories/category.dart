import 'dart:io';
import 'package:equatable/equatable.dart';

class category extends Equatable {
  late String id;
  late String name;
  late File? image;
  late String description;

  category({
    required this.name,
    //this.id,
    required this.description,
    required this.image,
  });

  factory category.fromMap(Map<String, dynamic> data) {
    return category(
      //id = data["id"];
      name: data['name'],
      image: data['image'],
      description: data['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      //'id': id,
      'name': name,
      'image': image,
      'description': description,
    };
  }

  @override
  // TODO: implement props
  List<Object?> get props => [id, name, image, description];

  category.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        description = json['description'],
        image = json['image'];

  Map<String, dynamic> toJson() => {
        //'id': id,
        'name': name,
        'image': image,
        'description': description,
      };
}
