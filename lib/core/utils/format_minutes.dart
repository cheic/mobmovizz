String? formatRuntime(int runtimeInMinutes) {
  int hours = runtimeInMinutes ~/ 60; 
  int minutes = runtimeInMinutes % 60;

 
  StringBuffer formattedString = StringBuffer();

  if (hours > 0) {
    formattedString.write('$hours hour${hours > 1 ? 's' : ''}');
  }
  
  if (minutes > 0) {
    if (formattedString.isNotEmpty) {
      formattedString.write(', '); 
    }
    formattedString.write('$minutes minute${minutes > 1 ? 's' : ''}');
  }

  return formattedString.toString();
}
