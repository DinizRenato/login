import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  
  final IconData icon;
  final String hint;
  final bool obscure;
  final Stream<String> stream;
  final Function(String) onChanged;
  final TextInputType keyboardType;

  InputField({
    @required this.stream,
    @required this.icon,
    @required this.hint,
    @required this.obscure,
    @required this.onChanged,
    this.keyboardType  = TextInputType.text
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
        stream: this.stream,
        builder: (context, snapshot) {
          return TextField(
            keyboardType: this.keyboardType,
            decoration: InputDecoration(
              icon: Icon(this.icon, color: Colors.black),
              hintText: this.hint,
              hintStyle: TextStyle(color: Colors.black),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              contentPadding: EdgeInsets.only(
                left: 5,
                right: 30,
                bottom: 30,
                top: 30,
              ),
              errorText: snapshot.hasError ? snapshot.error : null,
            ),
            onChanged: this.onChanged,
            style: TextStyle(
              color: Colors.black,
            ),
            obscureText: this.obscure,
          );
        });
  }
}
