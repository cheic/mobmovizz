// To parse this JSON data, do
//
//     final movieGenresListModel = movieGenresListModelFromJson(jsonString);

import 'dart:convert';

MovieGenresListModel movieGenresListModelFromJson(String str) => MovieGenresListModel.fromJson(json.decode(str));

String movieGenresListModelToJson(MovieGenresListModel data) => json.encode(data.toJson());

class MovieGenresListModel {
    List<Genre>? genres;

    MovieGenresListModel({
        this.genres,
    });

    factory MovieGenresListModel.fromJson(Map<String, dynamic> json) => MovieGenresListModel(
        genres: json["genres"] == null ? [] : List<Genre>.from(json["genres"]!.map((x) => Genre.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "genres": genres == null ? [] : List<dynamic>.from(genres!.map((x) => x.toJson())),
    };
}

class Genre {
    int? id;
    String? name;

    Genre({
        this.id,
        this.name,
    });

    factory Genre.fromJson(Map<String, dynamic> json) => Genre(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
