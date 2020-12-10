class Memo {
  int id;
  String title;
  String contents;
  String original;
  String large2x;
  String large;
  String medium;
  String small;
  String portrait;
  String landscape;
  String tiny;
  String datetime;
  int selected;

  Memo({
    this.id,
    this.title,
    this.contents,
    this.original,
    this.large2x,
    this.large,
    this.medium,
    this.small,
    this.portrait,
    this.landscape,
    this.tiny,
    this.datetime,
    this.selected,
  });


  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};

    map["title"] = title;
    map["contents"] = contents;
    map["original"] = original;
    map["large2x"] = large2x;
    map["large"] = large;
    map["medium"] = medium;
    map["small"] = small;
    map["portrait"] = portrait;
    map["landscape"] = landscape;
    map["tiny"] = tiny;
    map["datetime"] = datetime;
    map["selected"] = selected;

    if (id != null) {
      map["id"] = id;
    }
    return map;
  }

}
