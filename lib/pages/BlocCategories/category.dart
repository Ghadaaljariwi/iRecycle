import 'package:equatable/equatable.dart';

class category extends Equatable {
  late String id;
  late String name;
  late String image;
  late String description;

  category(
    this.name,
    //this.id,
    //this.description,
    // this.image,
  );

  category.fromMap(Map<String, dynamic> data) {
    id = data["id"];
    name = data['name'];
    image = data['image'];
    description = data['description'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'description': description,
    };
  }

  @override
  // TODO: implement props
  List<Object?> get props => [id, name, image, description];
}
