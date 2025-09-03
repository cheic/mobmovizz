part of 'theme_bloc.dart';

class ThemeState extends Equatable {
  final int themeMode;

  const ThemeState(this.themeMode);

  ThemeMode get mode {
    switch (themeMode) {
      case 1:
        return ThemeMode.light;
      case 2:
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  @override
  List<Object> get props => [themeMode];
}
