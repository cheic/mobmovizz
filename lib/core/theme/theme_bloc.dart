import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:mobmovizz/core/utils/app_preferences.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final AppPreferences _appPreferences;

  ThemeBloc(this._appPreferences) : super(ThemeState(_appPreferences.getThemeMode())) {
    on<ThemeChanged>(_onThemeChanged);
    on<ThemeInitialized>(_onThemeInitialized);
  }

  void _onThemeChanged(ThemeChanged event, Emitter<ThemeState> emit) async {
    await _appPreferences.setThemeMode(event.themeMode);
    emit(ThemeState(event.themeMode));
  }

  void _onThemeInitialized(ThemeInitialized event, Emitter<ThemeState> emit) {
    final themeMode = _appPreferences.getThemeMode();
    emit(ThemeState(themeMode));
  }
}
