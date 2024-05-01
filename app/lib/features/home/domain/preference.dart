import 'package:freezed_annotation/freezed_annotation.dart';

part 'preference.freezed.dart';
part 'preference.g.dart';

@freezed
class Preference with _$Preference {
  Preference._();

  factory Preference({
    bool? isObscureBalance,
  }) = _Preference;

  factory Preference.fromJson(Map<String, dynamic> json) =>
      _$PreferenceFromJson(json);

  factory Preference.empty() => Preference(isObscureBalance: false);
}
