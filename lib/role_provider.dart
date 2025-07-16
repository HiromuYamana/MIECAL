import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// アプリ全体で “現在ログインしているユーザーの role”
/// (`patient` / `doctor` / `admin`) を保持・監視する Provider
class RoleProvider extends ChangeNotifier {
  /// 既定は patient
  String _role = 'patient';
  bool _isLoading = true;

  String get role => _role;
  bool   get isLoading => _isLoading;

  /// ログイン直後や手動で呼び出して Firestore から Role を取得
  Future<void> fetchRole(String uid) async {
    _isLoading = true;
    notifyListeners();

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      _role = (doc.data()?['role'] ?? 'patient') as String;
    } catch (_) {
      _role = 'patient';                       // 取得失敗時は patient 扱い
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Auth 状態が変わった時に自動反映したい場合はこのストリーム利用も可
  void listenAuth() {
    FirebaseAuth.instance.userChanges().listen((user) {
      if (user == null) {
        _role = 'patient';
        notifyListeners();
      } else {
        fetchRole(user.uid);
      }
    });
  }
}
