class PostAdviceTest {
  String post(String content, String img) {
    if (content == "") {
      return "Empty Fields,\nPlease enter required fields";
    }
    return "The post is under review by the admin";
  }
}

class EditAdviceTest {
  String edit(String content) {
    if (content == "") {
      return "Empty Fields,\nPlease enter required fields";
    }
    return "The post is under review by the admin";
  }
}

class AddCategoryTest {
  String addCat(String name, String img) {
    if (name == "" && img == "") {
      return "Empty Fields,\nPlease enter required fields";
    }
    return "The category has been added successfully";
  }
}

class CodeRecTest {
  String takeImage(String img) {
    if (img == "8BABA77D-4D45-4455-B2AA-E7346F29DB8A.png") {
      return "This is PETE";
    }
    return "Empty Fields,\nPlease enter required fields";
  }
}

class AcceptDeclineTest {
  String updateStatus(String status) {
    if (status == "True") {
      return "The post has been accepted successfully";
    }
    return "The post has been declined successfully";
  }
}
