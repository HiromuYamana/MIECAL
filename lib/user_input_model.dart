import 'package:flutter/foundation.dart';

class UserInputModel with ChangeNotifier {
  String name = '';
  String address = '';
  String birthday = '';
  String age = '';
  String gender = '';
  String phoneNumber = '';
  String allergy = '';
  String surgeryHistory = '';

  // 追加項目
  String symptom = '';
  String onsetDate = '';
  String affectedArea = '';
  String cause = '';
  String sufferLevel = '';
  String drinking = ''; // 例: 'あり' or 'なし'
  String smoking = ''; // 例: 'あり' or 'なし'
  String pregnant = ''; // 例: 'あり' or 'なし'
  String medication = ''; // 例: 'あり' or 'なし'
  String doctorComments = '';

  // 個人情報の更新
  void updatePersonal({
    required String name,
    required String address,
    required String birthday,
    required String age,
    required String gender,
    required String phoneNumber,
    required String allergy,
    required String surgeryHistory,
  }) {
    this.name = name;
    this.address = address;
    this.birthday = birthday;
    this.age = age;
    this.gender = gender;
    this.phoneNumber = phoneNumber;
    this.allergy = allergy;
    this.surgeryHistory = surgeryHistory;
    notifyListeners();
  }

  // 症状・発症日の更新
  void updateSymptom({
    required String symptom,
    required String onsetDate,
  }) {
    this.symptom = symptom;
    this.onsetDate = onsetDate;
    notifyListeners();
  }

  // 問診関連情報の更新（患部、原因、重症度、生活習慣など）
  void updateQuestionnaire({
    required String affectedArea,
    required String cause,
    required String sufferLevel,
    required String drinking,
    required String smoking,
    required String pregnant,
    required String medication,
  }) {
    this.affectedArea = affectedArea;
    this.cause = cause;
    this.sufferLevel = sufferLevel;
    this.drinking = drinking;
    this.smoking = smoking;
    this.pregnant = pregnant;
    this.medication = medication;
    notifyListeners();
  }

  // 医師のコメント更新
  void updateDoctorComments({
    required String doctorComments,
  }) {
    this.doctorComments = doctorComments;
    notifyListeners();
  }

  // すべてリセット
  void reset() {
    name = '';
    address = '';
    birthday = '';
    age = '';
    gender = '';
    phoneNumber = '';
    allergy = '';
    surgeryHistory = '';

    symptom = '';
    onsetDate = '';
    affectedArea = '';
    cause = '';
    sufferLevel = '';
    drinking = '';
    smoking = '';
    pregnant = '';
    medication = '';
    doctorComments = '';

    notifyListeners();
  }
}
