import 'package:firebase_auth/firebase_auth.dart';

class UserData {
  static final UserData _instance = UserData._internal();
  String? displayName;
  String? userIdFireBase;

  factory UserData() {
    return _instance;
  }

  UserData._internal() {
    _fetchUserData();
  }

  void _fetchUserData() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      displayName = user.displayName;
      userIdFireBase = user.uid;
    }
  }

  static String? getDisplayName() {
    return _instance.displayName;
  }

  static String? getUserId() {
    return _instance.userIdFireBase;
  }
}