import 'package:flutter/material.dart';
import '../common/app_dimensions.dart';

/// Collection of reusable spacing widgets to maintain consistent spacing throughout the app
class AppSpacing {
  // Vertical spacing
  static const Widget verticalXs = SizedBox(height: AppDimensions.spacingXs);
  static const Widget verticalSm = SizedBox(height: AppDimensions.spacingSm);
  static const Widget verticalMd = SizedBox(height: AppDimensions.spacingMd);
  static const Widget verticalLg = SizedBox(height: AppDimensions.spacingLg);
  static const Widget verticalXl = SizedBox(height: AppDimensions.spacingXl);
  static const Widget verticalXxl = SizedBox(height: AppDimensions.spacingXxl);
  static const Widget verticalXxxl = SizedBox(height: AppDimensions.spacingXxxl);
  static const Widget verticalHuge = SizedBox(height: AppDimensions.spacingHuge);
  
  // Horizontal spacing
  static const Widget horizontalXs = SizedBox(width: AppDimensions.spacingXs);
  static const Widget horizontalSm = SizedBox(width: AppDimensions.spacingSm);
  static const Widget horizontalMd = SizedBox(width: AppDimensions.spacingMd);
  static const Widget horizontalLg = SizedBox(width: AppDimensions.spacingLg);
  static const Widget horizontalXl = SizedBox(width: AppDimensions.spacingXl);
  static const Widget horizontalXxl = SizedBox(width: AppDimensions.spacingXxl);
  static const Widget horizontalXxxl = SizedBox(width: AppDimensions.spacingXxxl);
  static const Widget horizontalHuge = SizedBox(width: AppDimensions.spacingHuge);
  
  // Flexible spacing that can adapt to available space
  static const Widget flexibleVertical = Spacer();
  static const Widget flexibleHorizontal = Spacer();
}

/// Collection of reusable padding EdgeInsets
class AppPadding {
  // Symmetric padding
  static const EdgeInsets allXs = EdgeInsets.all(AppDimensions.paddingXs);
  static const EdgeInsets allSm = EdgeInsets.all(AppDimensions.paddingSm);
  static const EdgeInsets allMd = EdgeInsets.all(AppDimensions.paddingMd);
  static const EdgeInsets allLg = EdgeInsets.all(AppDimensions.paddingLg);
  static const EdgeInsets allXl = EdgeInsets.all(AppDimensions.paddingXl);
  static const EdgeInsets allXxl = EdgeInsets.all(AppDimensions.paddingXxl);
  static const EdgeInsets allXxxl = EdgeInsets.all(AppDimensions.paddingXxxl);
  
  // Horizontal padding
  static const EdgeInsets horizontalXs = EdgeInsets.symmetric(horizontal: AppDimensions.paddingXs);
  static const EdgeInsets horizontalSm = EdgeInsets.symmetric(horizontal: AppDimensions.paddingSm);
  static const EdgeInsets horizontalMd = EdgeInsets.symmetric(horizontal: AppDimensions.paddingMd);
  static const EdgeInsets horizontalLg = EdgeInsets.symmetric(horizontal: AppDimensions.paddingLg);
  static const EdgeInsets horizontalXl = EdgeInsets.symmetric(horizontal: AppDimensions.paddingXl);
  static const EdgeInsets horizontalXxl = EdgeInsets.symmetric(horizontal: AppDimensions.paddingXxl);
  static const EdgeInsets horizontalXxxl = EdgeInsets.symmetric(horizontal: AppDimensions.paddingXxxl);
  
  // Vertical padding
  static const EdgeInsets verticalXs = EdgeInsets.symmetric(vertical: AppDimensions.paddingXs);
  static const EdgeInsets verticalSm = EdgeInsets.symmetric(vertical: AppDimensions.paddingSm);
  static const EdgeInsets verticalMd = EdgeInsets.symmetric(vertical: AppDimensions.paddingMd);
  static const EdgeInsets verticalLg = EdgeInsets.symmetric(vertical: AppDimensions.paddingLg);
  static const EdgeInsets verticalXl = EdgeInsets.symmetric(vertical: AppDimensions.paddingXl);
  static const EdgeInsets verticalXxl = EdgeInsets.symmetric(vertical: AppDimensions.paddingXxl);
  static const EdgeInsets verticalXxxl = EdgeInsets.symmetric(vertical: AppDimensions.paddingXxxl);
  
  // Screen edge padding (responsive)
  static EdgeInsets get screen {
    // This could be made responsive based on screen size
    return const EdgeInsets.all(AppDimensions.screenPaddingPhone);
  }
  
  // Common padding combinations
  static const EdgeInsets pageDefault = EdgeInsets.all(AppDimensions.paddingLg);
  static const EdgeInsets cardDefault = EdgeInsets.all(AppDimensions.paddingMd);
  static const EdgeInsets buttonDefault = EdgeInsets.symmetric(
    horizontal: AppDimensions.paddingXl,
    vertical: AppDimensions.paddingMd,
  );
}

/// Collection of reusable margin EdgeInsets
class AppMargin {
  // Symmetric margins
  static const EdgeInsets allXs = EdgeInsets.all(AppDimensions.marginXs);
  static const EdgeInsets allSm = EdgeInsets.all(AppDimensions.marginSm);
  static const EdgeInsets allMd = EdgeInsets.all(AppDimensions.marginMd);
  static const EdgeInsets allLg = EdgeInsets.all(AppDimensions.marginLg);
  static const EdgeInsets allXl = EdgeInsets.all(AppDimensions.marginXl);
  static const EdgeInsets allXxl = EdgeInsets.all(AppDimensions.marginXxl);
  static const EdgeInsets allXxxl = EdgeInsets.all(AppDimensions.marginXxxl);
  
  // Horizontal margins
  static const EdgeInsets horizontalXs = EdgeInsets.symmetric(horizontal: AppDimensions.marginXs);
  static const EdgeInsets horizontalSm = EdgeInsets.symmetric(horizontal: AppDimensions.marginSm);
  static const EdgeInsets horizontalMd = EdgeInsets.symmetric(horizontal: AppDimensions.marginMd);
  static const EdgeInsets horizontalLg = EdgeInsets.symmetric(horizontal: AppDimensions.marginLg);
  static const EdgeInsets horizontalXl = EdgeInsets.symmetric(horizontal: AppDimensions.marginXl);
  static const EdgeInsets horizontalXxl = EdgeInsets.symmetric(horizontal: AppDimensions.marginXxl);
  static const EdgeInsets horizontalXxxl = EdgeInsets.symmetric(horizontal: AppDimensions.marginXxxl);
  
  // Vertical margins
  static const EdgeInsets verticalXs = EdgeInsets.symmetric(vertical: AppDimensions.marginXs);
  static const EdgeInsets verticalSm = EdgeInsets.symmetric(vertical: AppDimensions.marginSm);
  static const EdgeInsets verticalMd = EdgeInsets.symmetric(vertical: AppDimensions.marginMd);
  static const EdgeInsets verticalLg = EdgeInsets.symmetric(vertical: AppDimensions.marginLg);
  static const EdgeInsets verticalXl = EdgeInsets.symmetric(vertical: AppDimensions.marginXl);
  static const EdgeInsets verticalXxl = EdgeInsets.symmetric(vertical: AppDimensions.marginXxl);
  static const EdgeInsets verticalXxxl = EdgeInsets.symmetric(vertical: AppDimensions.marginXxxl);
  
  // Common margin combinations
  static const EdgeInsets cardDefault = EdgeInsets.symmetric(
    horizontal: AppDimensions.marginLg,
    vertical: AppDimensions.marginSm,
  );
  static const EdgeInsets listItemDefault = EdgeInsets.symmetric(
    horizontal: AppDimensions.marginLg,
    vertical: AppDimensions.marginSm,
  );
}

/// Collection of common BorderRadius values
class AppBorderRadius {
  static const BorderRadius none = BorderRadius.zero;
  static const BorderRadius small = BorderRadius.all(Radius.circular(AppDimensions.borderRadiusSmall));
  static const BorderRadius medium = BorderRadius.all(Radius.circular(AppDimensions.borderRadius));
  static const BorderRadius large = BorderRadius.all(Radius.circular(AppDimensions.borderRadiusLarge));
  static const BorderRadius xLarge = BorderRadius.all(Radius.circular(AppDimensions.borderRadiusXLarge));
  
  // Circular borders
  static BorderRadius circular(double radius) => BorderRadius.circular(radius);
}

/// Collection of reusable Decoration objects
class AppDecoration {
  static BoxDecoration card(BuildContext context) => BoxDecoration(
    color: Theme.of(context).colorScheme.surface,
    borderRadius: AppBorderRadius.medium,
    boxShadow: [
      BoxShadow(
        color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
        blurRadius: AppDimensions.cardElevation,
        offset: const Offset(0, 2),
      ),
    ],
  );
  
  static BoxDecoration cardElevated(BuildContext context) => BoxDecoration(
    color: Theme.of(context).colorScheme.surface,
    borderRadius: AppBorderRadius.medium,
    boxShadow: [
      BoxShadow(
        color: Theme.of(context).colorScheme.shadow.withOpacity(0.15),
        blurRadius: AppDimensions.cardElevationHigh,
        offset: const Offset(0, 4),
      ),
    ],
  );
  
  static BoxDecoration roundedContainer(BuildContext context, {Color? color}) => BoxDecoration(
    color: color ?? Theme.of(context).colorScheme.surfaceContainer,
    borderRadius: AppBorderRadius.medium,
  );
}
