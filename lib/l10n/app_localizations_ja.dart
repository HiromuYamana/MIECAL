// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get menuTitle => 'メニュー';

  @override
  String get symptomForm => '問診票';

  @override
  String get profileEdit => 'プロフィール';

  @override
  String get qrScan => 'QRを読み込む';

  @override
  String get doctorApplication => '医師申請';

  @override
  String get applicationApproval => '申請承認';

  @override
  String get termsOfService => '利用規約を読む';

  @override
  String get email => 'Eメール';

  @override
  String get password => 'パスワード';

  @override
  String get confirmPassword => 'パスワード(確認用)';

  @override
  String get addPassword => 'パスワードを追加しますか？';

  @override
  String get addEmailAndPassword => 'Eメールとパスワードを追加しました。';

  @override
  String get googleLoginFailed => 'Googleログインに失敗しました';

  @override
  String get registerFailed => '登録に失敗しました';

  @override
  String get unknownError => '予期せぬエラーが発生しました。';

  @override
  String get add => '追加';

  @override
  String get later => '後で';

  @override
  String get linkFailed => 'リンク失敗';

  @override
  String accountExistsWithMethods(Object methods) {
    return 'このメールアドレスは $methods で登録済みです。別の方法でログインしてください。';
  }

  @override
  String get userDataNotFound => 'ユーザーデータが見つかりませんでした。個人情報を登録してください。';

  @override
  String get authUserNotFound => 'ユーザーが見つかりませんでした。';

  @override
  String get authWrongPassword => 'パスワードが間違っています。';

  @override
  String get authShortPassword => 'パスワードは6文字以上で入力してください';

  @override
  String get authInvalidEmail => 'メールアドレスの形式が正しくありません。';

  @override
  String get authUserDisabled => 'このアカウントは無効になっています。';

  @override
  String get authUnknownError => 'メールアドレスかパスワードが間違っています。';

  @override
  String get male => '男性';

  @override
  String get female => '女性';

  @override
  String get loginRequest => 'ログインしてください';

  @override
  String get loadingError => '読み込みエラー';

  @override
  String get yes => 'あり';

  @override
  String get yes2 => 'はい';

  @override
  String get no => 'なし';

  @override
  String get no2 => 'いいえ';

  @override
  String get saveFailed => '保存に失敗しました:';

  @override
  String get allergy => 'アレルギー';

  @override
  String get surgicalHistory => '手術歴';

  @override
  String get save => '保存';

  @override
  String get year => '年';

  @override
  String get month => '月';

  @override
  String get day => '日';

  @override
  String ageLabel(Object age) {
    return '年齢：$age歳';
  }

  @override
  String get signIn => 'ログイン';

  @override
  String get createNewAccount => 'アカウント新規作成';

  @override
  String get dontHaveAccount => 'アカウントをお持ちでない方は';

  @override
  String get forgetPassword => 'パスワードを忘れた場合';

  @override
  String get logout => 'ログアウト';

  @override
  String get questionnaireConfirmTitle => '問診票の内容確認';

  @override
  String get basicInformation => '基本情報';

  @override
  String get symptomsCauseDetails => '症状・原因選択';

  @override
  String get name => '氏名';

  @override
  String get birthdate => '生年月日';

  @override
  String get address => '住所';

  @override
  String get gender => '性別';

  @override
  String get phone => '電話番号';

  @override
  String get onsetDate => '発症日';

  @override
  String get symptom => '症状';

  @override
  String get affectedArea => '患部';

  @override
  String get severity => '程度';

  @override
  String get cause => '原因';

  @override
  String get otherInfo => 'その他の情報';

  @override
  String get notEntered => '未入力';

  @override
  String get notSelected => '未選択';

  @override
  String get createQrCode => 'QRコード作成';

  @override
  String get qrSaveSuccess => '問診票データを保存しました！';

  @override
  String get qrSaveFailed => '問診票データの保存に失敗しました';

  @override
  String get notLoggedIn => 'ログインしていません。データを保存できません。';

  @override
  String get detailsNotEntered => '詳細：未入力';

  @override
  String get affectedAreaSelection => '患部選択';

  @override
  String get partFace => '顔';

  @override
  String get partNeck => '首';

  @override
  String get partChest => '胸';

  @override
  String get partAbdomen => '腹';

  @override
  String get partGroin => '股';

  @override
  String get partRightThigh => '右腿';

  @override
  String get partRightCalf => '右ふくらはぎ';

  @override
  String get partRightFoot => '右足';

  @override
  String get partLeftThigh => '左腿';

  @override
  String get partLeftCalf => '左ふくらはぎ';

  @override
  String get partLeftFoot => '左足';

  @override
  String get partRightShoulder => '右肩';

  @override
  String get partRightUpperArm => '右上腕';

  @override
  String get partRightForearm => '右前腕';

  @override
  String get partRightHand => '右手';

  @override
  String get partLeftShoulder => '左肩';

  @override
  String get partLeftUpperArm => '左上腕';

  @override
  String get partLeftForearm => '左前腕';

  @override
  String get partLeftHand => '左手';

  @override
  String get partHead => '頭';

  @override
  String get partNape => '項';

  @override
  String get partBack => '背中';

  @override
  String get partButtocks => '臀部';

  @override
  String get dateOfOnset => '発症日';

  @override
  String get choosingTheLevelOfPain => '程度の選択';

  @override
  String get causeAccident => '事故';

  @override
  String get causeFallFromHeight => '転落';

  @override
  String get causeFall => '転倒';

  @override
  String get causeStrain => '負荷';

  @override
  String get causeContusion => '打撲';

  @override
  String get causeUnknown => '不明';

  @override
  String get causeOther => 'その他';

  @override
  String get labelAlcohol => '飲酒はしますか？';

  @override
  String get labelSmoking => '喫煙はしますか？';

  @override
  String get labelMedication => '現在使用しているお薬はありますか？';

  @override
  String get labelPregnancy => '現在妊娠の可能性はございますか？';

  @override
  String get alcohol => '飲酒';

  @override
  String get smoke => '喫煙';

  @override
  String get medication => '薬';

  @override
  String get pregnancy => '妊娠';

  @override
  String get showQrcode => 'この画面を提示してください。';
}
