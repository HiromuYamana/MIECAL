// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get menuTitle => 'Menu';

  @override
  String get symptomForm => 'Medical Form';

  @override
  String get profileEdit => 'Profile';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Password(confirm)';

  @override
  String get addPassword => 'Add password?';

  @override
  String get addEmailAndPassword => 'Your email and password have been successfully added.';

  @override
  String get googleLoginFailed => 'Google sign-in failed. ';

  @override
  String get registerFailed => 'Registration failed';

  @override
  String get unknownError => 'An expexted error has occurred.';

  @override
  String get add => 'Add';

  @override
  String get later => 'Later';

  @override
  String get linkFailed => 'Link failed';

  @override
  String accountExistsWithMethods(Object methods) {
    return 'This email is already registered with: $methods. Please log in using one of them.';
  }

  @override
  String get userDataNotFound => 'User data not found. Please register your personal infomartion.';

  @override
  String get authUserNotFound => 'User not found.';

  @override
  String get authWrongPassword => 'Incorrect password.';

  @override
  String get authShortPassword => 'Prease enter a password of six characters or more.';

  @override
  String get authInvalidEmail => 'Invalid email format.';

  @override
  String get authUserDisabled => 'This account is disabled.';

  @override
  String get authUnknownError => 'The email address or password is incorrect.';

  @override
  String get signIn => 'Sign in';

  @override
  String get createNewAccount => 'Create new account';

  @override
  String get dontHaveAccount => 'Don\'t you have account?';

  @override
  String get forgetPassword => 'Forget your password?';

  @override
  String get logout => 'Logout';

  @override
  String get questionnaireConfirmTitle => 'Confirm Questionnaire Details';

  @override
  String get basicInformation => 'Basic information';

  @override
  String get symptomsCauseDetails => 'Symptom / Cause Details';

  @override
  String get name => 'Name';

  @override
  String get birthdate => 'Date of Birth';

  @override
  String get address => 'Address';

  @override
  String get gender => 'Gender';

  @override
  String get phone => 'Phone Number';

  @override
  String get onsetDate => 'Onset Date';

  @override
  String get symptom => 'Symptom';

  @override
  String get affectedArea => 'Affected Area';

  @override
  String get severity => 'Severity';

  @override
  String get cause => 'Cause';

  @override
  String get otherInfo => 'Other Information';

  @override
  String get notEntered => 'Not Entered';

  @override
  String get notSelected => 'Not selected';

  @override
  String get createQrCode => 'Create QR Code';

  @override
  String get qrSaveSuccess => 'Questionnaire data saved successfully!';

  @override
  String get qrSaveFailed => 'Failed to save questionnaire data';

  @override
  String get notLoggedIn => 'Not logged in. Cannot save data.';

  @override
  String get detailsNotEntered => 'Details: Not entered';

  @override
  String get affectedAreaSelection => 'Affected Area Selection';

  @override
  String get partFace => 'Face';

  @override
  String get partNeck => 'Neck';

  @override
  String get partChest => 'Chest';

  @override
  String get partAbdomen => 'Abdomen';

  @override
  String get partGroin => 'Groin';

  @override
  String get partRightThigh => 'Right thigh';

  @override
  String get partRightCalf => 'Right calf';

  @override
  String get partRightFoot => 'Right foot';

  @override
  String get partLeftThigh => 'Left thigh';

  @override
  String get partLeftCalf => 'Left calf';

  @override
  String get partLeftFoot => 'Left foot';

  @override
  String get partRightShoulder => 'Right shoulder';

  @override
  String get partRightUpperArm => 'Right upper arm';

  @override
  String get partRightForearm => 'Right forearm';

  @override
  String get partRightHand => 'Right hand';

  @override
  String get partLeftShoulder => 'Left shoulder';

  @override
  String get partLeftUpperArm => 'Left upper arm';

  @override
  String get partLeftForearm => 'Left forearm';

  @override
  String get partLeftHand => 'Left hand';

  @override
  String get partHead => 'Head';

  @override
  String get partNape => 'Nape';

  @override
  String get partBack => 'Back';

  @override
  String get partButtocks => 'Buttocks';

  @override
  String get dateOfOnset => 'Date of onset';

  @override
  String get choosingTheLevelOfPain => 'Choosing the level of pain';
}
