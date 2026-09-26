

import 'dart:async';
import 'package:geolocator/geolocator.dart';

/// Service for handling device location access, caching, and permission management.
class LocationService {
  static Position? _lastPosition;
  static DateTime? _lastLocationTime;
  static const Duration _locationCacheDuration = Duration(minutes: 5);

  static bool _isCacheValid() {
    if (_lastPosition == null || _lastLocationTime == null) return false;
    final elapsed = DateTime.now().difference(_lastLocationTime!);
    return elapsed < _locationCacheDuration;
  }

  static Future<Map<String, dynamic>> getCurrentLocation({
    bool forceRefresh = false,
  }) async {
    try {
      if (!forceRefresh && _isCacheValid() && _lastPosition != null) {
        return _positionToMap(_lastPosition!);
      }

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw LocationException(
          'Location services are disabled',
          'Please enable location services in your device settings',
          LocationErrorCode.serviceDisabled,
        );
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw LocationException(
            'Location permission denied',
            'App needs location permission to work',
            LocationErrorCode.permissionDenied,
          );
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw LocationException(
          'Location permission permanently denied',
          'Please enable location permission in app settings',
          LocationErrorCode.permissionDeniedForever,
        );
      }

      try {
        final position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.best,
            timeLimit: Duration(seconds: 30),
          ),
        ).timeout(
          const Duration(seconds: 35),
          onTimeout: () {
            throw LocationException(
              'Location request timed out',
              'Unable to get your location. Try again.',
              LocationErrorCode.timeout,
            );
          },
        );

        _lastPosition = position;
        _lastLocationTime = DateTime.now();

        return _positionToMap(position);
      } on LocationException {
        rethrow;
      } on TimeoutException {
        try {
          final position = await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.medium,
              timeLimit: Duration(seconds: 15),
            ),
          ).timeout(
            const Duration(seconds: 20),
            onTimeout: () {
              throw LocationException(
                'Location request timed out',
                'Unable to get your location. Try again.',
                LocationErrorCode.timeout,
              );
            },
          );

          _lastPosition = position;
          _lastLocationTime = DateTime.now();

          return _positionToMap(position);
        } on LocationException {
          rethrow;
        } catch (e) {
          throw LocationException(
            'Failed to get location',
            e.toString(),
            LocationErrorCode.timeout,
          );
        }
      }
    } on LocationException {
      rethrow;
    } catch (e) {
      throw LocationException(
        'Unexpected error',
        e.toString(),
        LocationErrorCode.unknown,
      );
    }
  }

  static Map<String, dynamic> _positionToMap(Position position) {
    return {
      'latitude': position.latitude,
      'longitude': position.longitude,
      'accuracy': position.accuracy,
      'altitude': position.altitude,
      'speed': position.speed,
      'speedAccuracy': position.speedAccuracy,
      'heading': position.heading,
      'timestamp': position.timestamp.toIso8601String(),
    };
  }

  static void clearCache() {
    _lastPosition = null;
    _lastLocationTime = null;
  }

  static Future<Map<String, dynamic>> getLastKnownLocation() async {
    try {
      final position = await Geolocator.getLastKnownPosition();
      if (position == null) {
        throw LocationException(
          'No last known location',
          'Device has no cached location',
          LocationErrorCode.noLocationFound,
        );
      }
      return _positionToMap(position);
    } on LocationException {
      rethrow;
    } catch (e) {
      throw LocationException(
        'Failed to get last known location',
        e.toString(),
        LocationErrorCode.unknown,
      );
    }
  }
}

enum LocationErrorCode {
  serviceDisabled,
  permissionDenied,
  permissionDeniedForever,
  timeout,
  noLocationFound,
  unknown,
}

class LocationException implements Exception {
  final String title;
  final String message;
  final LocationErrorCode code;

  LocationException(this.title, this.message, this.code);

  @override
  String toString() => '$title: $message';

  String getUserFriendlyMessage() {
    switch (code) {
      case LocationErrorCode.serviceDisabled:
        return 'Please enable location services in Settings > Location';
      case LocationErrorCode.permissionDenied:
        return 'Location permission is required. Please grant it in app settings.';
      case LocationErrorCode.permissionDeniedForever:
        return 'Location permission is permanently denied. Enable it in app settings.';
      case LocationErrorCode.timeout:
        return 'Location request timed out. Please try again.';
      case LocationErrorCode.noLocationFound:
        return 'No location found. Please check your location settings.';
      case LocationErrorCode.unknown:
        return 'An error occurred while getting your location.';
    }
  }
}
