import 'dart:async';

class LoginValidators {
  
  final validateMobileNumber = StreamTransformer<String, String>.fromHandlers(
    handleData: (user, sink){
      if(user.length > 3){
        sink.add(user);
      } else {
        sink.addError('Celular Inválido!');
      }
    }
  );
  final validateCountryCode = StreamTransformer<String, String>.fromHandlers(
    handleData: (user, sink){
      if(user.length > 0){
        sink.add(user);
      } else {
        sink.addError('Código País inválido!');
      }
    }
  );

}