import 'dart:convert';

import 'package:app/features/home/domain/userdata.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_controller.g.dart';

@Riverpod(keepAlive: true)
class UserDataController extends _$UserDataController {
  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  void updateBalance(String balance) {
    state = state.copyWith(totalBalance: balance);
  }

  void updatePrivateKey(String privateKey) {
    state = state.copyWith(privateKey: privateKey);
  }

  Future<void> writeToStorage() async {
    await const FlutterSecureStorage()
        .write(key: 'user_data', value: json.encode(state.toJson()));
  }

  Future<void> loadFromStorage() async {
    final dataString =
        await const FlutterSecureStorage().read(key: 'user_data');
    if (dataString != null) {
      final data = UserData.fromJson(json.decode(dataString));
      state = data;
    }
  }

  @override
  UserData build() {
    return UserData(name: "");
  }
}
