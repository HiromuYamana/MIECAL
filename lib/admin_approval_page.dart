import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminApprovalPage extends StatefulWidget {
  const AdminApprovalPage({Key? key}) : super(key: key);

  @override
  State<AdminApprovalPage> createState() => _AdminApprovalPageState();
}

class _AdminApprovalPageState extends State<AdminApprovalPage> {
  final buttonStyle = ElevatedButton.styleFrom(
    backgroundColor: const Color.fromARGB(255, 18, 81, 241),
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    elevation: 6,
    shadowColor: Colors.black.withOpacity(0.2),
  );

  Future<void> _approveApplication(DocumentSnapshot doc) async {
    final data = doc.data() as Map<String, dynamic>;
    final uid = doc.id;
    final name = data['name'] ?? '';

    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'role': 'doctor',
      'name': name,
    }, SetOptions(merge: true));

    await FirebaseFirestore.instance
        .collection('doctor_applications')
        .doc(uid)
        .update({'status': 'approved'});
  }

  Future<void> _rejectApplication(DocumentSnapshot doc) async {
    final uid = doc.id;
    await FirebaseFirestore.instance
        .collection('doctor_applications')
        .doc(uid)
        .update({'status': 'rejected'});
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> pendingStream = FirebaseFirestore.instance
        .collection('doctor_applications')
        .where('status', isEqualTo: 'pending')
        .orderBy('timestamp')
        .snapshots();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "MIECAL",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 75, 170, 248),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: pendingStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                '読み取りエラー:\n${snapshot.error}',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return Center(
              child: Text('保留中の申請はありません',
                  style: GoogleFonts.montserrat(fontSize: 18)),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, index) {
              final doc = docs[index];
              final d = doc.data() as Map<String, dynamic>;

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ExpansionTile(
                  leading: const Icon(Icons.person_outline),
                  title: Text(
                    d['name'] ?? '（名前無し）',
                    style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
                  ),
                  childrenPadding: const EdgeInsets.symmetric(horizontal: 8),
                  children: [
                    _infoRow('所属医療機関', d['hospital']),
                    _infoRow('医師登録番号', d['license_number']),
                    _infoRow('備考', d['note']),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: buttonStyle,
                          onPressed: () async {
                            await _approveApplication(doc);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('承認しました: ${d['name']}')),
                            );
                          },
                          child: const Text('承認'),
                        ),
                        ElevatedButton(
                          style: buttonStyle.copyWith(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.orangeAccent),
                          ),
                          onPressed: () async {
                            await _rejectApplication(doc);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('拒否しました: ${d['name']}')),
                            );
                          },
                          child: const Text('拒否'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _infoRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value?.toString().isNotEmpty == true ? value.toString() : '（未記入）',
              style: GoogleFonts.montserrat(),
            ),
          ),
        ],
      ),
    );
  }
}
