import 'dart:math';

String randomStringGender(int chart, bool isString){

  var _chars = '';

  if(isString){
    _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  } else {
    _chars = '1234567890';
  }
  
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(
    Iterable.generate(length, (_) => _chars.codeUnitAt(
      _rnd.nextInt(_chars.length))
    )
  );

  return getRandomString(chart);
  
}