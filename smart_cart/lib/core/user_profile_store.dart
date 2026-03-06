import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:smart_cart/core/user_profile.dart';

class UserProfileStore {
  static const String _fileName = 'user_profile.json';

  Future<UserProfile> load() async {
    try {
      final file = await _file();
      if (!await file.exists()) {
        return const UserProfile.empty();
      }
      final raw = await file.readAsString();
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return UserProfile.fromJson(map);
    } catch (_) {
      return const UserProfile.empty();
    }
  }

  Future<void> save(UserProfile profile) async {
    final file = await _file();
    await file.writeAsString(jsonEncode(profile.toJson()));
  }

  Future<File> _file() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_fileName');
  }
}
