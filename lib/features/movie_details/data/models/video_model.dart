class VideoResultsModel {
  final int id;
  final List<VideoResult> results;

  VideoResultsModel({
    required this.id,
    required this.results,
  });

  factory VideoResultsModel.fromJson(Map<String, dynamic> json) => VideoResultsModel(
    id: json["id"],
    results: List<VideoResult>.from(json["results"].map((x) => VideoResult.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
  };
}

class VideoResult {
  final String iso639_1;
  final String iso3166_1;
  final String name;
  final String key;
  final String site;
  final int size;
  final String type;
  final bool official;
  final DateTime publishedAt;
  final String id;

  VideoResult({
    required this.iso639_1,
    required this.iso3166_1,
    required this.name,
    required this.key,
    required this.site,
    required this.size,
    required this.type,
    required this.official,
    required this.publishedAt,
    required this.id,
  });

  factory VideoResult.fromJson(Map<String, dynamic> json) => VideoResult(
    iso639_1: json["iso_639_1"],
    iso3166_1: json["iso_3166_1"],
    name: json["name"],
    key: json["key"],
    site: json["site"],
    size: json["size"],
    type: json["type"],
    official: json["official"],
    publishedAt: DateTime.parse(json["published_at"]),
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "iso_639_1": iso639_1,
    "iso_3166_1": iso3166_1,
    "name": name,
    "key": key,
    "site": site,
    "size": size,
    "type": type,
    "official": official,
    "published_at": publishedAt.toIso8601String(),
    "id": id,
  };
}