import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class ProviderService {
  static const Map<String, List<String>> _regionProviders = {
    // Europe
    'FR': ['Netflix', 'Amazon Prime Video', 'Disney+', 'Canal+', 'OCS', 'Paramount+'],
    'DE': ['Netflix', 'Amazon Prime Video', 'Disney+', 'Sky Deutschland', 'RTL+', 'Paramount+'],
    'ES': ['Netflix', 'Amazon Prime Video', 'Disney+', 'HBO Max', 'Movistar+', 'Filmin'],
    'IT': ['Netflix', 'Amazon Prime Video', 'Disney+', 'Sky Italia', 'Infinity+', 'Now TV'],
    'GB': ['Netflix', 'Amazon Prime Video', 'Disney+', 'Sky Go', 'BBC iPlayer', 'ITV Hub'],
    'NL': ['Netflix', 'Amazon Prime Video', 'Disney+', 'Videoland', 'NPO Start', 'RTL XL'],
    
    // Americas
    'US': ['Netflix', 'Amazon Prime Video', 'Disney+', 'Hulu', 'HBO Max', 'Apple TV+', 'Paramount+'],
    'CA': ['Netflix', 'Amazon Prime Video', 'Disney+', 'Crave', 'CBC Gem', 'Paramount+'],
    'BR': ['Netflix', 'Amazon Prime Video', 'Disney+', 'Globoplay', 'Paramount+', 'Apple TV+'],
    'MX': ['Netflix', 'Amazon Prime Video', 'Disney+', 'Claro Video', 'Paramount+', 'Apple TV+'],
    
    // Asia-Pacific
    'JP': ['Netflix', 'Amazon Prime Video', 'Disney+', 'Hulu Japan', 'U-NEXT', 'dTV'],
    'KR': ['Netflix', 'Amazon Prime Video', 'Disney+', 'Wavve', 'Tving', 'Coupang Play'],
    'AU': ['Netflix', 'Amazon Prime Video', 'Disney+', 'Stan', 'Foxtel Now', 'Paramount+'],
    'IN': ['Netflix', 'Amazon Prime Video', 'Disney+ Hotstar', 'SonyLIV', 'Zee5', 'Voot'],
    
    // Middle East & Africa
    'AE': ['Netflix', 'Amazon Prime Video', 'Disney+', 'Shahid VIP', 'OSN+', 'Apple TV+'],
    'SA': ['Netflix', 'Amazon Prime Video', 'Disney+', 'Shahid VIP', 'STC TV', 'Apple TV+'],
    'ZA': ['Netflix', 'Amazon Prime Video', 'Disney+', 'Showmax', 'DStv Now', 'Apple TV+'],
  };

  static const Map<String, String> _regionDisplayNames = {
    'FR': 'France',
    'DE': 'Germany', 
    'ES': 'Spain',
    'IT': 'Italy',
    'GB': 'United Kingdom',
    'NL': 'Netherlands',
    'US': 'United States',
    'CA': 'Canada',
    'BR': 'Brazil',
    'MX': 'Mexico',
    'JP': 'Japan',
    'KR': 'South Korea',
    'AU': 'Australia',
    'IN': 'India',
    'AE': 'United Arab Emirates',
    'SA': 'Saudi Arabia',
    'ZA': 'South Africa',
  };

  /// Get country code from device location
  static Future<String> getCountryCodeFromLocation() async {
    try {
      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return 'US'; // Default fallback
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return 'US'; // Default fallback
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
        timeLimit: Duration(seconds: 10),
      );

      // Get country from coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        String? countryCode = placemarks.first.isoCountryCode;
        return countryCode?.toUpperCase() ?? 'US';
      }
    } catch (e) {
      // Location error handled silently
    }
    
    return 'US'; // Default fallback
  }

  /// Get available providers for a specific country
  static List<String> getProvidersForCountry(String countryCode) {
    return _regionProviders[countryCode.toUpperCase()] ?? 
           _regionProviders['US'] ?? 
           ['Netflix', 'Amazon Prime Video', 'Disney+'];
  }

  /// Get display name for a country code
  static String getCountryDisplayName(String countryCode) {
    return _regionDisplayNames[countryCode.toUpperCase()] ?? countryCode.toUpperCase();
  }

  /// Check if a provider is available in a specific region
  static bool isProviderAvailableInRegion(String providerName, String countryCode) {
    final providers = getProvidersForCountry(countryCode);
    return providers.any((provider) => 
      provider.toLowerCase().contains(providerName.toLowerCase())
    );
  }

  /// Get all supported regions
  static List<String> getSupportedRegions() {
    return _regionProviders.keys.toList()..sort();
  }

  /// Get priority providers (most common worldwide)
  static List<String> getPriorityProviders() {
    return ['Netflix', 'Amazon Prime Video', 'Disney+', 'Apple TV+', 'Paramount+'];
  }
}
