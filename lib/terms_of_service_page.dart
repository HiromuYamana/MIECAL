import 'package:flutter/material.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('利用規約'),
        backgroundColor: const Color(0xFF1565C0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            '''
MIECAL 利用規約

第1条（適用）
本規約は、MIECAL（以下「当アプリ」）が提供するすべてのサービスに適用され、利用者と当アプリとの間の権利義務関係を定めるものです。

第2条（利用登録）
利用者は、本規約に同意の上、所定の方法で利用登録を行うことで、当アプリを利用できます。

第3条（アカウント管理）
利用者は、自己の責任においてアカウント情報を管理するものとします。第三者による不正使用に関して当アプリは一切の責任を負いません。

第4条（禁止事項）
以下の行為は禁止します：
- 虚偽の情報の登録
- 他者の権利を侵害する行為
- アプリの運営を妨害する行為

第5条（サービスの提供の停止）
当アプリは、メンテナンスやシステム障害等の理由により、利用者に事前に通知することなくサービスの提供を一時的に停止することがあります。

第6条（免責事項）
当アプリは、情報の正確性・完全性を保証せず、利用により生じた損害について一切の責任を負いません。

第7条（利用規約の変更）
当アプリは、必要に応じて本規約を変更できます。変更後の規約はアプリ内での掲示または通知をもって効力を生じます。

制定日：2025年7月10日
''',
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
