import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/home/model/image_data.dart';
import '/home/data/image_data.dart';

// Current selected feature provider
final selectedFeatureProvider = StateProvider<PTSDFeature?>((ref) => null);

// Current page index provider
final pageIndexProvider = StateProvider<int>((ref) => 0);

// Emergency mode provider
final emergencyModeProvider = StateProvider<bool>((ref) => false);

// High contrast mode provider
final highContrastModeProvider = StateProvider<bool>((ref) => false);

// Text-to-speech enabled provider
final ttsEnabledProvider = StateProvider<bool>((ref) => false);

// Features filter provider
final featuresFilterProvider = StateProvider<String?>((ref) => null);

// Filtered features provider
final filteredFeaturesProvider = Provider<List<PTSDFeature>>((ref) {
  final filter = ref.watch(featuresFilterProvider);
  
  if (filter == null || filter.isEmpty) {
    return ptsdFeatures;
  }
  
  return ptsdFeatures.where((feature) => 
    feature.category.toLowerCase() == filter.toLowerCase()
  ).toList();
});

// Categories provider
final categoriesProvider = Provider<List<String>>((ref) {
  final categories = ptsdFeatures.map((feature) => feature.category).toSet().toList();
  categories.sort();
  return categories;
});

// Emergency features provider
final emergencyFeaturesProvider = Provider<List<PTSDFeature>>((ref) {
  return ptsdFeatures.where((feature) => feature.isEmergency).toList();
});

// User preferences provider
final userPreferencesProvider = StateNotifierProvider<UserPreferences, Map<String, dynamic>>((ref) {
  return UserPreferences();
});

class UserPreferences extends StateNotifier<Map<String, dynamic>> {
  UserPreferences() : super({
    'darkMode': false,
    'highContrast': false,
    'textToSpeech': false,
    'emergencyContacts': <String>[],
    'preferredCategories': <String>[],
    'lastUsedFeatures': <String>[],
  });

  void updatePreference(String key, dynamic value) {
    state = {...state, key: value};
  }

  void addEmergencyContact(String contact) {
    final contacts = List<String>.from(state['emergencyContacts']);
    contacts.add(contact);
    state = {...state, 'emergencyContacts': contacts};
  }

  void removeEmergencyContact(String contact) {
    final contacts = List<String>.from(state['emergencyContacts']);
    contacts.remove(contact);
    state = {...state, 'emergencyContacts': contacts};
  }

  void addLastUsedFeature(String featureId) {
    final lastUsed = List<String>.from(state['lastUsedFeatures']);
    lastUsed.remove(featureId); // Remove if already exists
    lastUsed.insert(0, featureId); // Add to beginning
    if (lastUsed.length > 5) {
      lastUsed.removeLast(); // Keep only last 5
    }
    state = {...state, 'lastUsedFeatures': lastUsed};
  }
}
