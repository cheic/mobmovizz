// To parse this JSON data, do
//
//     final searchMovieModel = searchMovieModelFromJson(jsonString);

import 'dart:convert';

import 'dart:convert';

import 'package:flutter/foundation.dart';

SearchMovieModel searchMovieModelFromJson(String str) => SearchMovieModel.fromJson(json.decode(str));

String searchMovieModelToJson(SearchMovieModel data) => json.encode(data.toJson());

class SearchMovieModel {
    int? page;
    List<Result>? results;
    int? totalPages;
    int? totalResults;

    SearchMovieModel({
        this.page,
        this.results,
        this.totalPages,
        this.totalResults,
    });

  factory SearchMovieModel.fromJson(Map<String, dynamic> json) {
  try {
    return SearchMovieModel(
      page: json["page"],
      results: json["results"] == null ? [] : List<Result>.from(json["results"]!.map((x) => Result.fromJson(x))),
      totalPages: json["total_pages"],
      totalResults: json["total_results"],
    );
  } catch (e) {
    if(kDebugMode) print('Error parsing SearchMovieModel: $e');
    return SearchMovieModel();
  }
}

    Map<String, dynamic> toJson() => {
        "page": page,
        "results": results == null ? [] : List<dynamic>.from(results!.map((x) => x.toJson())),
        "total_pages": totalPages,
        "total_results": totalResults,
    };
}

class Result {
    bool? adult;
    String? backdropPath;
    List<int>? genreIds;
    int id;
    String? originalLanguage;
    String? originalTitle;
    String? overview;
    double? popularity;
    String? posterPath;
    String? releaseDate;
    String? title;
    bool? video;
    double? voteAverage;
    int? voteCount;

    Result({
        this.adult,
        this.backdropPath,
        this.genreIds,
        required this.id,
        this.originalLanguage,
        this.originalTitle,
        this.overview,
        this.popularity,
        this.posterPath,
        this.releaseDate,
        this.title,
        this.video,
        this.voteAverage,
        this.voteCount,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        adult: json["adult"],
        backdropPath: json["backdrop_path"],
        genreIds: json["genre_ids"] == null ? [] : List<int>.from(json["genre_ids"]!.map((x) => x)),
        id: json["id"] ?? 0, // Provide a default value if id is null
        originalLanguage: json["original_language"],
        originalTitle: json["original_title"],
        overview: json["overview"],
        popularity: json["popularity"]?.toDouble(),
        posterPath: json["poster_path"],
        releaseDate: json["release_date"],
        title: json["title"],
        video: json["video"],
        voteAverage: json["vote_average"]?.toDouble(),
        voteCount: json["vote_count"],
    );

    Map<String, dynamic> toJson() => {
        "adult": adult,
        "backdrop_path": backdropPath,
        "genre_ids": genreIds == null ? [] : List<dynamic>.from(genreIds!.map((x) => x)),
        "id": id,
        "original_language": originalLanguage,
        "original_title": originalTitle,
        "overview": overview,
        "popularity": popularity,
        "poster_path": posterPath,
        "release_date": releaseDate,
        "title": title,
        "video": video,
        "vote_average": voteAverage,
        "vote_count": voteCount,
    };
}