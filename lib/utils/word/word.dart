import 'gender.dart';

class Word {
  late String _native;
  late List<String> _translation;
  late Gender _gender;

  Word(
      {required String native,
      required List<String> translation,
      required Gender gender}) {
    _native = native;
    _translation = translation;
    _gender = gender;
  }

  List<String> get translation => _translation;

  String get native => _native;

  Gender get gender => _gender;
}
