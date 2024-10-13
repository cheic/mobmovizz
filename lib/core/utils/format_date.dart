import 'package:intl/intl.dart';

String? formatReleaseDate(String? releaseDate) {
  if (releaseDate == null) return null;

  // Split the date string and take the first part
  String dateString = releaseDate.split(' ')[0];

  // Parse the date string into a DateTime object
  DateTime? dateTime = DateTime.tryParse(dateString);
  
  if (dateTime == null) return null;

  // Format the date to MM/DD/YYYY
  return DateFormat('MM/dd/yyyy').format(dateTime);
}

String? formatReleaseDateWithMonthName(String? releaseDate) {
  if (releaseDate == null) return null;

  // Split the date string and take the first part
  String dateString = releaseDate.split(' ')[0];

  // Parse the date string into a DateTime object
  DateTime? dateTime = DateTime.tryParse(dateString);
  
  if (dateTime == null) return null;

  // Format the date to "Month Day, Year"
  return DateFormat('MMMM d, yyyy').format(dateTime);
}
