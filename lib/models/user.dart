import 'package:flutter/foundation.dart';

class User {
  final String phoneNumber;
  final String countryCode;
  final double latitude;
  final double longitude;
  final String token;
  final String passcode;
  final String refreshToken;

  User({
    @required this.phoneNumber,
    @required this.countryCode,
    @required this.latitude,
    @required this.longitude,
    @required this.token,
    @required this.passcode,
    @required this.refreshToken,
  });
  
}