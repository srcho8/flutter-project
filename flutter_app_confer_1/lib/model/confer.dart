class Confer {
  String name;
  String link;
  String start;
  String end;
  String location;

  Confer({this.name, this.link, this.start, this.end, this.location});

  Confer.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    link = json["link"];
    start = json["start"];
    end = json["end"];
    location = json["location"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["name"] = name;
    map["link"] = link;
    map["start"] = start;
    map["end"] = end;
    map["location"] = location;
    return map;
  }
}
