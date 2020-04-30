import 'package:flutter/material.dart';
import 'package:login/models/user.dart';

class UserScreen extends StatelessWidget {
  final User user;

  const UserScreen(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(),
          Container(
            margin: EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.verified_user,
                  color: Colors.black,
                  size: 160,
                ),
                Text(
                  'Phone number:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text('${user.phoneNumber}'),
                Text('Country Code:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                Text('${user.countryCode}'),
                Text('Token:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                Text('${user.token}'),
                Text('Passcode:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                Text('${user.passcode}'),
                Text('Latitude:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                Text('${user.latitude}'),
                Text('Longitude:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                Text('${user.longitude}'),
                Text('Refresh Token:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                Text('${user.refreshToken}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
