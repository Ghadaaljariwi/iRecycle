import 'package:irecycle/main.dart';

class PostAdviceTest {
  String post(String content, String img) {
    if (content == "") {
      return "Empty Fields,\nPlease enter required fields";
    }
    return "The post is under review by the admin";
  }
}
