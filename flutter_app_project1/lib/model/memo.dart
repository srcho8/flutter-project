class Memo {
  int id;
  String title;
  String contents;
  String imageurl;
  String datetime;

  Memo({
    this.id,
    this.title,
    this.contents,
    this.imageurl,
    this.datetime,
  });

  // Memo.fromJson(Map<String, dynamic> json) {
  //   id = json["id"];
  //   title = json["title"];
  //   contents = json["content"];
  //   imageurl = json["date"];
  //   datetime = json["datetime"];
  // }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};

    map["title"] = title;
    map["contents"] = contents;
    map["imageurl"] = imageurl;
    map["datetime"] = datetime;

    if (id != null) {
      map["id"] = id;
    }
    return map;
  }

  // Map<String, dynamic> toMap() {
  //   var map = <String, dynamic>{};
  //
  //   map["title"] = title;
  //   map["contents"] = contents;
  //   map["imageurl"] = imageurl;
  //   map["datetime"] = datetime;
  //
  //   if (id != null) {
  //     map["id"] = id;
  //   }
  //   return map;
  // }
}
