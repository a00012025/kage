import 'dart:convert';

import 'package:app/features/home/domain/preference.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'user_preference_controller.g.dart';

@Riverpod(keepAlive: true)
class UserPreference extends _$UserPreference {
  @override
  Future<Preference> build() async {
    state = const AsyncLoading();
    const storage = FlutterSecureStorage();
    final data = await storage.read(key: 'preference');
    if (data == null) {
      return Preference.empty();
    }
    return Preference.fromJson(jsonDecode(data));
  }

  Future<void> switchObscureBalance() async {
    final preference = state.value == null
        ? Preference(isObscureBalance: true)
        : state.value!.copyWith(
            isObscureBalance: !(state.value?.isObscureBalance ?? false));
    const storage = FlutterSecureStorage();
    await storage.write(
        key: 'preference', value: jsonEncode(preference.toJson()));
    state = AsyncValue.data(preference);
  }
}
