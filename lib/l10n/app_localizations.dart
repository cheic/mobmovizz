import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @app_title.
  ///
  /// In en, this message translates to:
  /// **'MobMovizz'**
  String get app_title;

  /// No description provided for @welcome_message.
  ///
  /// In en, this message translates to:
  /// **'Welcome to MobMovizz!'**
  String get welcome_message;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @genre.
  ///
  /// In en, this message translates to:
  /// **'Genre'**
  String get genre;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @add_to_watchlist.
  ///
  /// In en, this message translates to:
  /// **'Add to Watchlist'**
  String get add_to_watchlist;

  /// No description provided for @movie.
  ///
  /// In en, this message translates to:
  /// **'Movie'**
  String get movie;

  /// No description provided for @release_date.
  ///
  /// In en, this message translates to:
  /// **'Release Date'**
  String get release_date;

  /// No description provided for @reminder_question.
  ///
  /// In en, this message translates to:
  /// **'When do you want to be reminded?'**
  String get reminder_question;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @notify_again.
  ///
  /// In en, this message translates to:
  /// **'Notify again if I miss it'**
  String get notify_again;

  /// No description provided for @additional_reminders.
  ///
  /// In en, this message translates to:
  /// **'Send additional reminders'**
  String get additional_reminders;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @edit_reminder.
  ///
  /// In en, this message translates to:
  /// **'Edit Reminder'**
  String get edit_reminder;

  /// No description provided for @set_reminder_for.
  ///
  /// In en, this message translates to:
  /// **'Set reminder for'**
  String get set_reminder_for;

  /// No description provided for @enable_reminder.
  ///
  /// In en, this message translates to:
  /// **'Enable reminder'**
  String get enable_reminder;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @movie_releases_on.
  ///
  /// In en, this message translates to:
  /// **'Movie releases on'**
  String get movie_releases_on;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @no_title.
  ///
  /// In en, this message translates to:
  /// **'No Title'**
  String get no_title;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @no_overview_available.
  ///
  /// In en, this message translates to:
  /// **'No overview available'**
  String get no_overview_available;

  /// No description provided for @runtime.
  ///
  /// In en, this message translates to:
  /// **'Runtime'**
  String get runtime;

  /// No description provided for @vote_average.
  ///
  /// In en, this message translates to:
  /// **'Vote Average'**
  String get vote_average;

  /// No description provided for @vote_count.
  ///
  /// In en, this message translates to:
  /// **'Vote Count'**
  String get vote_count;

  /// No description provided for @budget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get budget;

  /// No description provided for @revenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get revenue;

  /// No description provided for @added_to_watchlist.
  ///
  /// In en, this message translates to:
  /// **'Added to watchlist!'**
  String get added_to_watchlist;

  /// No description provided for @removed_from_watchlist.
  ///
  /// In en, this message translates to:
  /// **'Removed from watchlist!'**
  String get removed_from_watchlist;

  /// No description provided for @remove_from_watchlist.
  ///
  /// In en, this message translates to:
  /// **'Remove from Watchlist'**
  String get remove_from_watchlist;

  /// No description provided for @add_to_watchlist_button.
  ///
  /// In en, this message translates to:
  /// **'Add to Watchlist'**
  String get add_to_watchlist_button;

  /// No description provided for @my_watchlist.
  ///
  /// In en, this message translates to:
  /// **'My Watchlist'**
  String get my_watchlist;

  /// No description provided for @your_watchlist_is_empty.
  ///
  /// In en, this message translates to:
  /// **'Your watchlist is empty'**
  String get your_watchlist_is_empty;

  /// No description provided for @add_movies_you_want_to_watch_later.
  ///
  /// In en, this message translates to:
  /// **'Add movies you want to watch later'**
  String get add_movies_you_want_to_watch_later;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @no_date_set.
  ///
  /// In en, this message translates to:
  /// **'No date set'**
  String get no_date_set;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @remove_from_watchlist_title.
  ///
  /// In en, this message translates to:
  /// **'Remove from Watchlist'**
  String get remove_from_watchlist_title;

  /// No description provided for @search_for_movies.
  ///
  /// In en, this message translates to:
  /// **'Search for movies...'**
  String get search_for_movies;

  /// No description provided for @search_for_a_movie.
  ///
  /// In en, this message translates to:
  /// **'Search for a movie'**
  String get search_for_a_movie;

  /// No description provided for @sort_by.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get sort_by;

  /// No description provided for @popularity_desc.
  ///
  /// In en, this message translates to:
  /// **'Popularity ↓'**
  String get popularity_desc;

  /// No description provided for @popularity_asc.
  ///
  /// In en, this message translates to:
  /// **'Popularity ↑'**
  String get popularity_asc;

  /// No description provided for @release_date_desc.
  ///
  /// In en, this message translates to:
  /// **'Newest First'**
  String get release_date_desc;

  /// No description provided for @release_date_asc.
  ///
  /// In en, this message translates to:
  /// **'Oldest First'**
  String get release_date_asc;

  /// No description provided for @vote_average_desc.
  ///
  /// In en, this message translates to:
  /// **'Highest Rated'**
  String get vote_average_desc;

  /// No description provided for @vote_average_asc.
  ///
  /// In en, this message translates to:
  /// **'Lowest Rated'**
  String get vote_average_asc;

  /// No description provided for @title_asc.
  ///
  /// In en, this message translates to:
  /// **'Title A-Z'**
  String get title_asc;

  /// No description provided for @title_desc.
  ///
  /// In en, this message translates to:
  /// **'Title Z-A'**
  String get title_desc;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @no_movies_available.
  ///
  /// In en, this message translates to:
  /// **'No movies available.'**
  String get no_movies_available;

  /// No description provided for @some_error_occurs.
  ///
  /// In en, this message translates to:
  /// **'Some error occurs'**
  String get some_error_occurs;

  /// No description provided for @no_date.
  ///
  /// In en, this message translates to:
  /// **'No date'**
  String get no_date;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today!'**
  String get today;

  /// No description provided for @tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// No description provided for @coming_up_in_watchlist.
  ///
  /// In en, this message translates to:
  /// **'Coming Up in Watchlist'**
  String get coming_up_in_watchlist;

  /// No description provided for @view_all.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get view_all;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @choose_your_preferred_theme.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred theme'**
  String get choose_your_preferred_theme;

  /// No description provided for @system_default.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get system_default;

  /// No description provided for @follow_system_theme.
  ///
  /// In en, this message translates to:
  /// **'Follow system theme'**
  String get follow_system_theme;

  /// No description provided for @light_theme.
  ///
  /// In en, this message translates to:
  /// **'Light Theme'**
  String get light_theme;

  /// No description provided for @always_use_light_theme.
  ///
  /// In en, this message translates to:
  /// **'Always use light theme'**
  String get always_use_light_theme;

  /// No description provided for @dark_theme.
  ///
  /// In en, this message translates to:
  /// **'Dark Theme'**
  String get dark_theme;

  /// No description provided for @always_use_dark_theme.
  ///
  /// In en, this message translates to:
  /// **'Always use dark theme'**
  String get always_use_dark_theme;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @manage_notification_settings.
  ///
  /// In en, this message translates to:
  /// **'Manage notification settings'**
  String get manage_notification_settings;

  /// No description provided for @test_complete.
  ///
  /// In en, this message translates to:
  /// **'Test Complete'**
  String get test_complete;

  /// No description provided for @test_notification.
  ///
  /// In en, this message translates to:
  /// **'Test Notification'**
  String get test_notification;

  /// No description provided for @sending_in_progress.
  ///
  /// In en, this message translates to:
  /// **'Sending in progress...'**
  String get sending_in_progress;

  /// No description provided for @programming_in_progress.
  ///
  /// In en, this message translates to:
  /// **'Programming in progress...'**
  String get programming_in_progress;

  /// No description provided for @test_movie.
  ///
  /// In en, this message translates to:
  /// **'Test Movie'**
  String get test_movie;

  /// No description provided for @pending_notifications.
  ///
  /// In en, this message translates to:
  /// **'Pending notifications'**
  String get pending_notifications;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @app_information.
  ///
  /// In en, this message translates to:
  /// **'App information'**
  String get app_information;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @build.
  ///
  /// In en, this message translates to:
  /// **'Build'**
  String get build;

  /// No description provided for @no_genres_available.
  ///
  /// In en, this message translates to:
  /// **'No genres available.'**
  String get no_genres_available;

  /// No description provided for @search_for_genres.
  ///
  /// In en, this message translates to:
  /// **'Search for genres'**
  String get search_for_genres;

  /// No description provided for @movie_is_already_in_your_watchlist.
  ///
  /// In en, this message translates to:
  /// **'Movie is already in your watchlist'**
  String get movie_is_already_in_your_watchlist;

  /// No description provided for @movie_not_found_in_watchlist.
  ///
  /// In en, this message translates to:
  /// **'Movie not found in watchlist'**
  String get movie_not_found_in_watchlist;

  /// No description provided for @location_permissions_are_denied.
  ///
  /// In en, this message translates to:
  /// **'Location permissions are denied'**
  String get location_permissions_are_denied;

  /// No description provided for @top_rated.
  ///
  /// In en, this message translates to:
  /// **'Top Rated'**
  String get top_rated;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @notification_title.
  ///
  /// In en, this message translates to:
  /// **'🎬 MobMovizz Reminder'**
  String get notification_title;

  /// No description provided for @notification_body.
  ///
  /// In en, this message translates to:
  /// **'Don\'t forget about the movie \"{movieTitle}\"!'**
  String notification_body(String movieTitle);

  /// No description provided for @vote_count_label.
  ///
  /// In en, this message translates to:
  /// **'Vote count'**
  String get vote_count_label;

  /// No description provided for @release_label.
  ///
  /// In en, this message translates to:
  /// **'Release'**
  String get release_label;

  /// No description provided for @added_label.
  ///
  /// In en, this message translates to:
  /// **'Added'**
  String get added_label;

  /// No description provided for @reminder_label.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get reminder_label;

  /// No description provided for @search_for_movies_text.
  ///
  /// In en, this message translates to:
  /// **'Search for movies'**
  String get search_for_movies_text;

  /// No description provided for @quick_add_title.
  ///
  /// In en, this message translates to:
  /// **'Movie Title'**
  String get quick_add_title;

  /// No description provided for @add_button.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add_button;

  /// No description provided for @data_source_disclaimer.
  ///
  /// In en, this message translates to:
  /// **'Data Source Disclaimer'**
  String get data_source_disclaimer;

  /// No description provided for @third_party_data_notice.
  ///
  /// In en, this message translates to:
  /// **'Third-Party Data Notice'**
  String get third_party_data_notice;

  /// No description provided for @important_notice.
  ///
  /// In en, this message translates to:
  /// **'Important Notice'**
  String get important_notice;

  /// No description provided for @tmdb_not_endorsed.
  ///
  /// In en, this message translates to:
  /// **'This application uses TMDB and the TMDB APIs but is not endorsed, certified, or otherwise approved by TMDB.'**
  String get tmdb_not_endorsed;

  /// No description provided for @disclaimer_text_1.
  ///
  /// In en, this message translates to:
  /// **'By using this application, you acknowledge and agree to the following:'**
  String get disclaimer_text_1;

  /// No description provided for @disclaimer_point_1.
  ///
  /// In en, this message translates to:
  /// **'Data Source: This application utilizes The Movie Database (TMDB) APIs to provide movie information, ratings, and related content.'**
  String get disclaimer_point_1;

  /// No description provided for @disclaimer_point_2.
  ///
  /// In en, this message translates to:
  /// **'No Official Affiliation: This application is independently developed and is not officially affiliated with, endorsed by, sponsored by, or certified by TMDB or any of its subsidiaries.'**
  String get disclaimer_point_2;

  /// No description provided for @disclaimer_point_3.
  ///
  /// In en, this message translates to:
  /// **'Content Accuracy: While we strive to provide accurate information, the data is sourced from TMDB and we cannot guarantee its completeness or accuracy. Users should verify critical information independently.'**
  String get disclaimer_point_3;

  /// No description provided for @disclaimer_point_4.
  ///
  /// In en, this message translates to:
  /// **'Intellectual Property: All movie titles, descriptions, images, and related content remain the intellectual property of their respective owners and TMDB.'**
  String get disclaimer_point_4;

  /// No description provided for @disclaimer_point_5.
  ///
  /// In en, this message translates to:
  /// **'TMDB Terms: Use of this application implies acceptance of TMDB\'s terms of service and privacy policy, which can be found at www.themoviedb.org.'**
  String get disclaimer_point_5;

  /// No description provided for @disclaimer_point_6.
  ///
  /// In en, this message translates to:
  /// **'Data Usage: This application may cache movie data locally for performance purposes. No personal viewing data is shared with third parties without your consent.'**
  String get disclaimer_point_6;

  /// No description provided for @disclaimer_point_7.
  ///
  /// In en, this message translates to:
  /// **'Liability: This application is provided \'as is\' without any warranties. We are not liable for any issues arising from the use of third-party data or services.'**
  String get disclaimer_point_7;

  /// No description provided for @tmdb_attribution.
  ///
  /// In en, this message translates to:
  /// **'This product uses the TMDB API but is not endorsed or certified by TMDB.'**
  String get tmdb_attribution;

  /// No description provided for @filters_and_sort.
  ///
  /// In en, this message translates to:
  /// **'Filters and Sort'**
  String get filters_and_sort;

  /// No description provided for @filter_by_year.
  ///
  /// In en, this message translates to:
  /// **'Filter by year'**
  String get filter_by_year;

  /// No description provided for @all_years.
  ///
  /// In en, this message translates to:
  /// **'All years'**
  String get all_years;

  /// No description provided for @no_internet_connection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get no_internet_connection;

  /// No description provided for @check_your_connection.
  ///
  /// In en, this message translates to:
  /// **'Check your connection and try again'**
  String get check_your_connection;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
