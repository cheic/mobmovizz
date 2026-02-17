// To parse this JSON data, do
//
//     final discoverModel = discoverModelFromJson(jsonString);

import 'dart:convert';

PopularMovieModel popularMovieModelFromJson(String str) => PopularMovieModel.fromJson(json.decode(str));

String popularMovieModelToJson(PopularMovieModel data) => json.encode(data.toJson());

class PopularMovieModel {
    int page;
    List<Result> results;
    int totalPages;
    int totalResults;

    PopularMovieModel({
        required this.page,
        required this.results,
        required this.totalPages,
        required this.totalResults,
    });

    factory PopularMovieModel.fromJson(Map<String, dynamic> json) => PopularMovieModel(
        page: json["page"],
        results: List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
    );

    Map<String, dynamic> toJson() => {
        "page": page,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
        "total_pages": totalPages,
        "total_results": totalResults,
    };
}

class Result {
    bool adult;
    String? backdropPath;
    List<int> genreIds;
    int id;
    String? originalLanguage;
    String originalTitle;
    String overview;
    double popularity;
    String? posterPath;
    DateTime? releaseDate;
    String title;
    bool video;
    double voteAverage;
    int voteCount;

    Result({
        required this.adult,
        this.backdropPath,
        required this.genreIds,
        required this.id,
        this.originalLanguage,
        required this.originalTitle,
        required this.overview,
        required this.popularity,
        this.posterPath,
        this.releaseDate,
        required this.title,
        required this.video,
        required this.voteAverage,
        required this.voteCount,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        adult: json["adult"] ?? false,
        backdropPath: json["backdrop_path"],
        genreIds: json["genre_ids"] != null
            ? List<int>.from(json["genre_ids"].map((x) => x))
            : [],
        id: json["id"],
        originalLanguage: json["original_language"],
        originalTitle: json["original_title"] ?? '',
        overview: json["overview"] ?? '',
        popularity: (json["popularity"] as num?)?.toDouble() ?? 0.0,
        posterPath: json["poster_path"],
        releaseDate: json["release_date"] != null && json["release_date"].toString().isNotEmpty
            ? DateTime.tryParse(json["release_date"])
            : null,
        title: json["title"] ?? '',
        video: json["video"] ?? false,
        voteAverage: (json["vote_average"] as num?)?.toDouble() ?? 0.0,
        voteCount: json["vote_count"] ?? 0,
    );

    Map<String, dynamic> toJson() => {
        "adult": adult,
        "backdrop_path": backdropPath,
        "genre_ids": List<dynamic>.from(genreIds.map((x) => x)),
        "id": id,
        "original_language": originalLanguage,
        "original_title": originalTitle,
        "overview": overview,
        "popularity": popularity,
        "poster_path": posterPath,
        "release_date": releaseDate != null
            ? "${releaseDate!.year.toString().padLeft(4, '0')}-${releaseDate!.month.toString().padLeft(2, '0')}-${releaseDate!.day.toString().padLeft(2, '0')}"
            : null,
        "title": title,
        "video": video,
        "vote_average": voteAverage,
        "vote_count": voteCount,
    };
}
