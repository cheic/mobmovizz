import 'package:flutter/material.dart';
import 'package:mobmovizz/core/theme/colors.dart';

class CommonHeader extends StatelessWidget {
  final String headerTitle;
  final String headerText;
  final VoidCallback onTap;

  const CommonHeader({
    super.key,
    required this.headerTitle,
    required this.headerText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 16, left: 16),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: royalBlueDerived,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                headerTitle,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 16, right: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min, // Keeps the button width tight
              children: [
                Text(
                  headerText,
                  style: TextStyle(
                    color: royalBlueDerived, // Text color
                    fontWeight: FontWeight.w500, // Optional: make it bold
                  ),
                ),
                SizedBox(width: 8), // Space between text and icon
               
              ],
            )),
      ],
    );
  }
}
