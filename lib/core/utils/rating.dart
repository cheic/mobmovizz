import 'package:flutter/material.dart';

double? normalizeRatingToFive(double? voteAverage) {
  if (voteAverage == null) return null;
  return voteAverage / 2;
}

String formatRatingOutOfFive(double? voteAverage) {
  final normalizedRating = normalizeRatingToFive(voteAverage);
  if (normalizedRating == null) return 'N/A';
  return normalizedRating.toStringAsFixed(1);
}

Widget buildVoteAverageStars(double? voteAverage) {
      if (voteAverage == null) return Text('N/A');

      // Convert 0-10 scale to 0-5 scale
      final normalizedRating = normalizeRatingToFive(voteAverage)!;

      return Row(
        children: List.generate(5, (index) {
          final starPosition = index + 1;

          IconData iconData;
          if (normalizedRating >= starPosition) {
            iconData = Icons.star;
          } else if (normalizedRating >= starPosition - 0.5) {
            iconData = Icons.star_half;
          } else {
            iconData = Icons.star_border;
          }

          return Icon(
            iconData,
            color: Colors.amber,
            size: 20,
          );
        }),
      );
    }
