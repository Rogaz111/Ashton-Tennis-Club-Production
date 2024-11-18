import 'package:ashton_tennis_unity/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('SharedPreferences Methods Tests', () {
    late MockSharedPreferences mockPrefs;

    setUp(() {
      mockPrefs = MockSharedPreferences();
    });

    test('hasSeenOnboarding should return true if onboarding_seen is true',
        () async {
      // Arrange
      when(mockPrefs.getBool('onboarding_seen')).thenReturn(true);

      // Act
      final myApp = MyApp();
      SharedPreferences.setMockInitialValues(
          {'onboarding_seen': true}); // Mock SharedPreferences
      final result = await myApp.hasSeenOnboarding();

      // Assert
      expect(result, true);
      verify(mockPrefs.getBool('onboarding_seen')).called(1);
    });

    test('hasSeenOnboarding should return false if onboarding_seen is not set',
        () async {
      // Arrange
      when(mockPrefs.getBool('onboarding_seen')).thenReturn(null);

      // Act
      final myApp = MyApp();
      SharedPreferences.setMockInitialValues({}); // Empty SharedPreferences
      final result = await myApp.hasSeenOnboarding();

      // Assert
      expect(result, false);
      verify(mockPrefs.getBool('onboarding_seen')).called(1);
    });

    test('setOnboardingSeen should set onboarding_seen to true', () async {
      // Arrange
      when(mockPrefs.setBool('onboarding_seen', true))
          .thenAnswer((_) async => true);

      // Act
      final myApp = MyApp();
      await myApp.setOnboardingSeen();

      // Assert
      verify(mockPrefs.setBool('onboarding_seen', true)).called(1);
    });
  });
}
