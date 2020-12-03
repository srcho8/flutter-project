class Photo {
  num page;
  num perPage;
  List<Photos> photos;
  String nextPage;

  Photo({this.page, this.perPage, this.photos, this.nextPage});

  Photo.fromJson(dynamic json) {
    page = json["page"];
    perPage = json["per_page"];
    if (json["photos"] != null) {
      photos = [];
      json["photos"].forEach((v) {
        photos.add(Photos.fromJson(v));
      });
    }
    nextPage = json["next_page"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["page"] = page;
    map["per_page"] = perPage;
    if (photos != null) {
      map["photos"] = photos.map((v) => v.toJson()).toList();
    }
    map["next_page"] = nextPage;
    return map;
  }
}

class Photos {
  num id;
  num width;
  num height;
  String url;
  String photographer;
  String photographerUrl;
  num photographerId;
  Src src;
  bool liked;

  Photos(
      {this.id,
      this.width,
      this.height,
      this.url,
      this.photographer,
      this.photographerUrl,
      this.photographerId,
      this.src,
      this.liked});

  Photos.fromJson(dynamic json) {
    id = json["id"];
    width = json["width"];
    height = json["height"];
    url = json["url"];
    photographer = json["photographer"];
    photographerUrl = json["photographer_url"];
    photographerId = json["photographer_id"];
    src = json["src"] != null ? Src.fromJson(json["src"]) : null;
    liked = json["liked"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["width"] = width;
    map["height"] = height;
    map["url"] = url;
    map["photographer"] = photographer;
    map["photographer_url"] = photographerUrl;
    map["photographer_id"] = photographerId;
    if (src != null) {
      map["src"] = src.toJson();
    }
    map["liked"] = liked;
    return map;
  }
}

class Src {
  String original;
  String large2x;
  String large;
  String medium;
  String small;
  String portrait;
  String landscape;
  String tiny;

  Src(
      {this.original,
      this.large2x,
      this.large,
      this.medium,
      this.small,
      this.portrait,
      this.landscape,
      this.tiny});

  Src.fromJson(dynamic json) {
    original = json["original"];
    large2x = json["large2x"];
    large = json["large"];
    medium = json["medium"];
    small = json["small"];
    portrait = json["portrait"];
    landscape = json["landscape"];
    tiny = json["tiny"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["original"] = original;
    map["large2x"] = large2x;
    map["large"] = large;
    map["medium"] = medium;
    map["small"] = small;
    map["portrait"] = portrait;
    map["landscape"] = landscape;
    map["tiny"] = tiny;
    return map;
  }
}
