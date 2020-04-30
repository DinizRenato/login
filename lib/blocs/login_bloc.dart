import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:geolocator/geolocator.dart';
import 'package:login/models/user.dart';
import 'dart:async';
import 'package:login/validators/login_validators.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

enum LoginState { IDLE, LOADING, LOADING_TOKEN, LOADING_CODE, SUCCESS, FAIL }
const BASE_URL = 'https://nikdev.herokuapp.com';

const headers = {"Content-Type": "application/json"};

class LoginBloc extends BlocBase with LoginValidators {

  LoginBloc() {
    _stateController.add(LoginState.LOADING);
    this._getCurrentLocation();
  }

  final _mobileNumberController = BehaviorSubject<String>();
  final _countryCodeController = BehaviorSubject<String>();
  final _stateController = BehaviorSubject<LoginState>();
  final _currentLocationController = BehaviorSubject<Position>();

  final _userController = BehaviorSubject<User>();

  Stream<String> get outMobileNumber =>
      _mobileNumberController.stream.transform(validateMobileNumber);
  Stream<String> get outCountryCode =>
      _countryCodeController.stream.transform(validateCountryCode);
  Stream<Position> get outCurrentLocation => _currentLocationController.stream;

  Stream<LoginState> get outLoginState => _stateController.stream;

  User get outUser => _userController.stream.value;

  Function(String) get changeMobileNumber => _mobileNumberController.sink.add;
  Function(String) get changeCountryCode => _countryCodeController.sink.add;

  Stream<bool> get outSubmitValid => Observable.combineLatest2(
      outMobileNumber, outCountryCode, (a, b) => true);

  void _getCurrentLocation() {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      _currentLocationController.sink.add(position);
          _stateController.add(LoginState.IDLE);
    }).catchError((e) {
      print(e);
    });
  }

  void submit() {
    _stateController.sink.add(LoginState.LOADING_TOKEN);

    http
        .post('$BASE_URL/logins',
            headers: headers, body: json.encode(_postParams()))
        .then((resp) {
      _stateController.sink.add(LoginState.LOADING_CODE);
      final token = json.decode(resp.body)['record']['session']['token'];

      http
          .put('$BASE_URL/logins',
              headers: headers, body: json.encode(_putParams(token, '1234')))
          .then((resp) {
        _stateController.sink.add(LoginState.SUCCESS);
        _userController.sink.add(new User(
            countryCode: _countryCodeController.value,
            phoneNumber: _mobileNumberController.value,
            latitude: _currentLocationController.value.latitude,
            longitude: _currentLocationController.value.longitude,
            token: token,
            passcode: '1234',
            refreshToken: json.decode(resp.body)['record']['session']
                ['refresh_token']));
      });
    }).catchError((e) {
      print(e);
    });
  }

  Map<String, Object> _postParams() {
    return {
      "login": {
        "phone_number": _mobileNumberController.value,
        "country_code": _countryCodeController.value
      },
      "session": {
        "lat": _currentLocationController.value.latitude,
        "lng": _currentLocationController.value.longitude
      }
    };
  }

  Map<String, Object> _putParams(String token, String passcode) {
    return {
      "session": {"token": token, "security_token": passcode}
    };
  }

  @override
  void dispose() {
    _mobileNumberController.close();
    _countryCodeController.close();
    _stateController.close();
    _currentLocationController.close();
    _userController.close();
  }
}
