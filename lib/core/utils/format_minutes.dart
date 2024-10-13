String? formatRuntime(int runtimeInMinutes) {
  int hours = runtimeInMinutes ~/ 60; // Get the whole number of hours
  int minutes = runtimeInMinutes % 60; // Get the remaining minutes

  // Build the formatted string
  StringBuffer formattedString = StringBuffer();

  if (hours > 0) {
    formattedString.write('$hours hour${hours > 1 ? 's' : ''}');
  }
  
  if (minutes > 0) {
    if (formattedString.isNotEmpty) {
      formattedString.write(', '); // Add a comma if hours are present
    }
    formattedString.write('$minutes minute${minutes > 1 ? 's' : ''}');
  }

  return formattedString.toString();
}
