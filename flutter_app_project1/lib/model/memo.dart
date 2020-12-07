class Memo {
  int id;
  String title;
  String contents;
  String imageurl;
  String datetime;
  int selected;

  Memo({
    this.id,
    this.title,
    this.contents,
    this.imageurl,
    this.datetime,
    this.selected,
  });


  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};

    map["title"] = title;
    map["contents"] = contents;
    map["imageurl"] = imageurl;
    map["datetime"] = datetime;
    map["selected"] = selected;

    if (id != null) {
      map["id"] = id;
    }
    return map;
  }

}
