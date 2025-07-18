import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();
  final _db = FirebaseFirestore.instance;

  /// users/{uid} が無ければ role: patient で作成し、
  /// 既にあれば何もしない
  Future<void> ensureUserDoc(String uid, {String email = ''}) async {
    final ref = _db.collection('users').doc(uid);
    final snap = await ref.get();
    if (!snap.exists) {
      await ref.set({
        'role': 'patient',
        'email': email,
      });
    }
  }
}
