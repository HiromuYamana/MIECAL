// lib/admin_approval_page.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminApprovalPage extends StatelessWidget {
  const AdminApprovalPage({Key? key}) : super(key: key);

  /// 申請承認処理
  Future<void> _approveApplication(DocumentSnapshot doc) async {
    final data = doc.data() as Map<String, dynamic>;
    final uid = doc.id;
    final name = data['name'] ?? '';

    // users/{uid} に role: doctor を付与
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'role': 'doctor',
      'name': name,
    }, SetOptions(merge: true));

    // doctor_applications/{uid}.status を approved に変更
    await FirebaseFirestore.instance
        .collection('doctor_applications')
        .doc(uid)
        .update({'status': 'approved'});
  }

  @override
  Widget build(BuildContext context) {
    // pending だけ取得
    final Stream<QuerySnapshot> pendingStream =
        FirebaseFirestore.instance
            .collection('doctor_applications')
            .where('status', isEqualTo: 'pending')
            .orderBy('timestamp')
            .snapshots();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 218, 246, 250),
      appBar: AppBar(
        title: Text('医師申請 承認', style: GoogleFonts.poppins()),
        backgroundColor: Colors.teal,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: pendingStream,
        builder: (context, snapshot) {
          // ---- 1. エラー表示 ----
          if (snapshot.hasError) {
            return Center(
              child: Text(
                '読み取りエラー:\n${snapshot.error}',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            );
          }

          // ---- 2. ローディング表示 ----
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];

          // ---- 3. データ無し ----
          if (docs.isEmpty) {
            return Center(
              child: Text(
                '保留中の申請はありません',
                style: GoogleFonts.poppins(fontSize: 18),
              ),
            );
          }

          // ---- 4. データ表示 ----
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, index) {
              final doc = docs[index];
              final d = doc.data() as Map<String, dynamic>;

              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: Text(
                    d['name'] ?? '（名前無し）',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    d['hospital'] ?? '（病院名無し）',
                    style: GoogleFonts.poppins(),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.check_circle, color: Colors.teal),
                    onPressed: () async {
                      try {
                        await _approveApplication(doc);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('承認しました: ${d['name']}')),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('承認に失敗しました: $e')),
                        );
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
