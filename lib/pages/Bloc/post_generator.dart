import 'package:irecycle/pages/Bloc/Post.dart';

class PostGenerator {
  static List<Post> generateDummyPosts() {
    return [
      Post(
        id: "1",
        name: "Post",
        thumbnailURL:
            "https://asset.kompas.com/crops/MrdYDsxogO0J3wGkWCaGLn2RHVc=/84x60:882x592/750x500/data/photo/2021/11/17/61949959e07d3.jpg",
        price: "Rp18.000",
      ),
      Post(
        id: "2",
        name: "Post",
        thumbnailURL:
            "https://photos.smugmug.com/Indonesia-2016/i-9hLVhWh/0/X3/indonesian-sate-ayam-1-X3.jpg",
        price: "Rp20.000",
      ),
      Post(
        id: "3",
        name: "Post",
        thumbnailURL:
            "https://photos.smugmug.com/Indonesia-2016/i-Q4M8Pkt/0/X3/ayam-taliwang-jakarta-1-X3.jpg",
        price: "R25.000",
      ),
      Post(
        id: "4",
        name: "Post",
        thumbnailURL:
            "https://photos.smugmug.com/City-Guides/i-bMfqjcX/0/X3/jakarta-travel-guide-21-X3.jpg",
        price: "Rp18.000",
      ),
      Post(
        id: "5",
        name: "Post",
        thumbnailURL:
            "https://photos.smugmug.com/Indonesia-2016/i-vG378LH/0/X3/indonesian-food-14-X3.jpg",
        price: "Rp17.000",
      ),
    ];
  }
}
