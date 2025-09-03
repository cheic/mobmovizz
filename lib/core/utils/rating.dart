import 'package:flutter/material.dart';

Widget buildVoteAverageStars(double? voteAverage) {
      if (voteAverage == null) return Text('N/A');

      // Convert 0-10 scale to 0-5 scale
      final normalizedRating = (voteAverage / 2).round();

      return Row(
        children: List.generate(5, (index) {
          return Icon(
            index < normalizedRating ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 20,
          );
        }),
      );
    }
