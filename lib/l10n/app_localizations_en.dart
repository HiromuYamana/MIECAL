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
  String get qrScan => 'Scan QR code';

  @override
  String get doctorApplication => 'Doctor Application';

  @override
  String get applicationApproval => 'Application Approval';

  @override
  String get termsOfService => 'View Terms of Use';

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
  String get unknownError => 'An unknown error occurred.';

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
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get loginRequest => 'Please sign in.';

  @override
  String get loadingError => 'Loading Error';

  @override
  String get yes => 'Yes';

  @override
  String get yes2 => 'Yes';

  @override
  String get no => 'No';

  @override
  String get no2 => 'No';

  @override
  String get saveFailed => 'Saving failed';

  @override
  String get allergy => 'Allergy';

  @override
  String get surgicalHistory => 'Surgical history';

  @override
  String get save => 'Save';

  @override
  String get year => 'Year';

  @override
  String get month => 'Month';

  @override
  String get day => 'Day';

  @override
  String ageLabel(Object age) {
    return 'Age: $age';
  }

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
  String get symptomSelection => 'Symptom Selection';

  @override
  String get symptomAllergy => 'Allergy';

  @override
  String get symptomStomachache => 'Stomachache';

  @override
  String get symptomWound => 'Wound';

  @override
  String get symptomFracture => 'Fracture';

  @override
  String get symptomMetabolic => 'Metabolic Syndrome';

  @override
  String get symptomCough => 'Cough';

  @override
  String get symptomBackpain => 'Back Pain';

  @override
  String get symptomFatigue => 'Fatigue';

  @override
  String get symptomFever => 'Fever';

  @override
  String get symptomSoreThroat => 'Sore Throat';

  @override
  String get symptomNausea => 'Nausea';

  @override
  String get symptomDizziness => 'Dizziness';

  @override
  String get symptomNumbness => 'Numbness';

  @override
  String get symptomRash => 'Rash';

  @override
  String get symptomJointPain => 'Joint Pain';

  @override
  String get symptomOther => 'Other';

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

  @override
  String get causeAccident => 'Accident';

  @override
  String get causeFallFromHeight => 'Fall from height';

  @override
  String get causeFall => 'Slipping';

  @override
  String get causeStrain => 'Strain';

  @override
  String get causeContusion => 'Contusion';

  @override
  String get causeUnknown => 'Unknown';

  @override
  String get causeOther => 'Other';

  @override
  String get labelAlcohol => 'Do you drink alcohol?';

  @override
  String get labelSmoking => 'Do you smoke?';

  @override
  String get labelMedication => 'Are you taking any medication?';

  @override
  String get labelPregnancy => 'Is there a possibility of pregnancy?';

  @override
  String get alcohol => 'Alcohol';

  @override
  String get smoke => 'Smoking';

  @override
  String get medication => 'Medication';

  @override
  String get pregnancy => 'Pregnancy';

  @override
  String get showQrcode => 'Please show doctor or nurse this screen.';

  @override
  String get loginFailed => 'Login failed.';

  @override
  String get questionnaireTitle => 'Questionnaire';

  @override
  String get questionnaireLoginRequired => 'Login is required to view this questionnaire.';

  @override
  String get questionnairePermissionDenied => 'You do not have permission to view this questionnaire. Please log in with an approved doctor account.';

  @override
  String get questionnaireIdMissing => 'Questionnaire ID is missing.';

  @override
  String get questionnaireNotFound => 'The specified questionnaire data was not found.';

  @override
  String get questionnaireNoData => 'No questionnaire data available.';

  @override
  String get questionnaireDataTitle => 'Questionnaire Data';

  @override
  String get loginButtonText => 'Log In';

  @override
  String get loginTitle => 'Login';

  @override
  String get firestoreError => 'Firestore Error';
}
