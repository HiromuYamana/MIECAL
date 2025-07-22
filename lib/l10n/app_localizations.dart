import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja')
  ];

  /// No description provided for @menuTitle.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menuTitle;

  /// No description provided for @symptomForm.
  ///
  /// In en, this message translates to:
  /// **'Medical Form'**
  String get symptomForm;

  /// No description provided for @profileEdit.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileEdit;

  /// No description provided for @qrScan.
  ///
  /// In en, this message translates to:
  /// **'Scan QR code'**
  String get qrScan;

  /// No description provided for @doctorApplication.
  ///
  /// In en, this message translates to:
  /// **'Doctor Application'**
  String get doctorApplication;

  /// No description provided for @applicationApproval.
  ///
  /// In en, this message translates to:
  /// **'Application Approval'**
  String get applicationApproval;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'View Terms of Use'**
  String get termsOfService;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Password(confirm)'**
  String get confirmPassword;

  /// No description provided for @addPassword.
  ///
  /// In en, this message translates to:
  /// **'Add password?'**
  String get addPassword;

  /// No description provided for @addEmailAndPassword.
  ///
  /// In en, this message translates to:
  /// **'Your email and password have been successfully added.'**
  String get addEmailAndPassword;

  /// No description provided for @googleLoginFailed.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in failed. '**
  String get googleLoginFailed;

  /// No description provided for @registerFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed'**
  String get registerFailed;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred.'**
  String get unknownError;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @later.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get later;

  /// No description provided for @linkFailed.
  ///
  /// In en, this message translates to:
  /// **'Link failed'**
  String get linkFailed;

  /// No description provided for @accountExistsWithMethods.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered with: {methods}. Please log in using one of them.'**
  String accountExistsWithMethods(Object methods);

  /// No description provided for @userDataNotFound.
  ///
  /// In en, this message translates to:
  /// **'User data not found. Please register your personal infomartion.'**
  String get userDataNotFound;

  /// No description provided for @authUserNotFound.
  ///
  /// In en, this message translates to:
  /// **'User not found.'**
  String get authUserNotFound;

  /// No description provided for @authWrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password.'**
  String get authWrongPassword;

  /// No description provided for @authShortPassword.
  ///
  /// In en, this message translates to:
  /// **'Prease enter a password of six characters or more.'**
  String get authShortPassword;

  /// No description provided for @authInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format.'**
  String get authInvalidEmail;

  /// No description provided for @authUserDisabled.
  ///
  /// In en, this message translates to:
  /// **'This account is disabled.'**
  String get authUserDisabled;

  /// No description provided for @authUnknownError.
  ///
  /// In en, this message translates to:
  /// **'The email address or password is incorrect.'**
  String get authUnknownError;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @loginRequest.
  ///
  /// In en, this message translates to:
  /// **'Please sign in.'**
  String get loginRequest;

  /// No description provided for @loadingError.
  ///
  /// In en, this message translates to:
  /// **'Loading Error'**
  String get loadingError;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @yes2.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes2;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @no2.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no2;

  /// No description provided for @saveFailed.
  ///
  /// In en, this message translates to:
  /// **'Saving failed'**
  String get saveFailed;

  /// No description provided for @allergy.
  ///
  /// In en, this message translates to:
  /// **'Allergy'**
  String get allergy;

  /// No description provided for @surgicalHistory.
  ///
  /// In en, this message translates to:
  /// **'Surgical history'**
  String get surgicalHistory;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get day;

  /// No description provided for @ageLabel.
  ///
  /// In en, this message translates to:
  /// **'Age: {age}'**
  String ageLabel(Object age);

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @createNewAccount.
  ///
  /// In en, this message translates to:
  /// **'Create new account'**
  String get createNewAccount;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t you have account?'**
  String get dontHaveAccount;

  /// No description provided for @forgetPassword.
  ///
  /// In en, this message translates to:
  /// **'Forget your password?'**
  String get forgetPassword;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @questionnaireConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Questionnaire Details'**
  String get questionnaireConfirmTitle;

  /// No description provided for @basicInformation.
  ///
  /// In en, this message translates to:
  /// **'Basic information'**
  String get basicInformation;

  /// No description provided for @symptomsCauseDetails.
  ///
  /// In en, this message translates to:
  /// **'Symptom / Cause Details'**
  String get symptomsCauseDetails;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @birthdate.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get birthdate;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phone;

  /// No description provided for @onsetDate.
  ///
  /// In en, this message translates to:
  /// **'Onset Date'**
  String get onsetDate;

  /// No description provided for @symptom.
  ///
  /// In en, this message translates to:
  /// **'Symptom'**
  String get symptom;

  /// No description provided for @affectedArea.
  ///
  /// In en, this message translates to:
  /// **'Affected Area'**
  String get affectedArea;

  /// No description provided for @severity.
  ///
  /// In en, this message translates to:
  /// **'Severity'**
  String get severity;

  /// No description provided for @cause.
  ///
  /// In en, this message translates to:
  /// **'Cause'**
  String get cause;

  /// No description provided for @otherInfo.
  ///
  /// In en, this message translates to:
  /// **'Other Information'**
  String get otherInfo;

  /// No description provided for @notEntered.
  ///
  /// In en, this message translates to:
  /// **'Not Entered'**
  String get notEntered;

  /// No description provided for @notSelected.
  ///
  /// In en, this message translates to:
  /// **'Not selected'**
  String get notSelected;

  /// No description provided for @createQrCode.
  ///
  /// In en, this message translates to:
  /// **'Create QR Code'**
  String get createQrCode;

  /// No description provided for @qrSaveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Questionnaire data saved successfully!'**
  String get qrSaveSuccess;

  /// No description provided for @qrSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save questionnaire data'**
  String get qrSaveFailed;

  /// No description provided for @notLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'Not logged in. Cannot save data.'**
  String get notLoggedIn;

  /// No description provided for @detailsNotEntered.
  ///
  /// In en, this message translates to:
  /// **'Details: Not entered'**
  String get detailsNotEntered;

  /// No description provided for @affectedAreaSelection.
  ///
  /// In en, this message translates to:
  /// **'Affected Area Selection'**
  String get affectedAreaSelection;

  /// No description provided for @partFace.
  ///
  /// In en, this message translates to:
  /// **'Face'**
  String get partFace;

  /// No description provided for @partNeck.
  ///
  /// In en, this message translates to:
  /// **'Neck'**
  String get partNeck;

  /// No description provided for @partChest.
  ///
  /// In en, this message translates to:
  /// **'Chest'**
  String get partChest;

  /// No description provided for @partAbdomen.
  ///
  /// In en, this message translates to:
  /// **'Abdomen'**
  String get partAbdomen;

  /// No description provided for @partGroin.
  ///
  /// In en, this message translates to:
  /// **'Groin'**
  String get partGroin;

  /// No description provided for @partRightThigh.
  ///
  /// In en, this message translates to:
  /// **'Right thigh'**
  String get partRightThigh;

  /// No description provided for @partRightCalf.
  ///
  /// In en, this message translates to:
  /// **'Right calf'**
  String get partRightCalf;

  /// No description provided for @partRightFoot.
  ///
  /// In en, this message translates to:
  /// **'Right foot'**
  String get partRightFoot;

  /// No description provided for @partLeftThigh.
  ///
  /// In en, this message translates to:
  /// **'Left thigh'**
  String get partLeftThigh;

  /// No description provided for @partLeftCalf.
  ///
  /// In en, this message translates to:
  /// **'Left calf'**
  String get partLeftCalf;

  /// No description provided for @partLeftFoot.
  ///
  /// In en, this message translates to:
  /// **'Left foot'**
  String get partLeftFoot;

  /// No description provided for @partRightShoulder.
  ///
  /// In en, this message translates to:
  /// **'Right shoulder'**
  String get partRightShoulder;

  /// No description provided for @partRightUpperArm.
  ///
  /// In en, this message translates to:
  /// **'Right upper arm'**
  String get partRightUpperArm;

  /// No description provided for @partRightForearm.
  ///
  /// In en, this message translates to:
  /// **'Right forearm'**
  String get partRightForearm;

  /// No description provided for @partRightHand.
  ///
  /// In en, this message translates to:
  /// **'Right hand'**
  String get partRightHand;

  /// No description provided for @partLeftShoulder.
  ///
  /// In en, this message translates to:
  /// **'Left shoulder'**
  String get partLeftShoulder;

  /// No description provided for @partLeftUpperArm.
  ///
  /// In en, this message translates to:
  /// **'Left upper arm'**
  String get partLeftUpperArm;

  /// No description provided for @partLeftForearm.
  ///
  /// In en, this message translates to:
  /// **'Left forearm'**
  String get partLeftForearm;

  /// No description provided for @partLeftHand.
  ///
  /// In en, this message translates to:
  /// **'Left hand'**
  String get partLeftHand;

  /// No description provided for @partHead.
  ///
  /// In en, this message translates to:
  /// **'Head'**
  String get partHead;

  /// No description provided for @partNape.
  ///
  /// In en, this message translates to:
  /// **'Nape'**
  String get partNape;

  /// No description provided for @partBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get partBack;

  /// No description provided for @partButtocks.
  ///
  /// In en, this message translates to:
  /// **'Buttocks'**
  String get partButtocks;

  /// No description provided for @dateOfOnset.
  ///
  /// In en, this message translates to:
  /// **'Date of onset'**
  String get dateOfOnset;

  /// No description provided for @choosingTheLevelOfPain.
  ///
  /// In en, this message translates to:
  /// **'Choosing the level of pain'**
  String get choosingTheLevelOfPain;

  /// No description provided for @causeAccident.
  ///
  /// In en, this message translates to:
  /// **'Accident'**
  String get causeAccident;

  /// No description provided for @causeFallFromHeight.
  ///
  /// In en, this message translates to:
  /// **'Fall from height'**
  String get causeFallFromHeight;

  /// No description provided for @causeFall.
  ///
  /// In en, this message translates to:
  /// **'Slipping'**
  String get causeFall;

  /// No description provided for @causeStrain.
  ///
  /// In en, this message translates to:
  /// **'Strain'**
  String get causeStrain;

  /// No description provided for @causeContusion.
  ///
  /// In en, this message translates to:
  /// **'Contusion'**
  String get causeContusion;

  /// No description provided for @causeUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get causeUnknown;

  /// No description provided for @causeOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get causeOther;

  /// No description provided for @labelAlcohol.
  ///
  /// In en, this message translates to:
  /// **'Do you drink alcohol?'**
  String get labelAlcohol;

  /// No description provided for @labelSmoking.
  ///
  /// In en, this message translates to:
  /// **'Do you smoke?'**
  String get labelSmoking;

  /// No description provided for @labelMedication.
  ///
  /// In en, this message translates to:
  /// **'Are you taking any medication?'**
  String get labelMedication;

  /// No description provided for @labelPregnancy.
  ///
  /// In en, this message translates to:
  /// **'Is there a possibility of pregnancy?'**
  String get labelPregnancy;

  /// No description provided for @alcohol.
  ///
  /// In en, this message translates to:
  /// **'Alcohol'**
  String get alcohol;

  /// No description provided for @smoke.
  ///
  /// In en, this message translates to:
  /// **'Smoking'**
  String get smoke;

  /// No description provided for @medication.
  ///
  /// In en, this message translates to:
  /// **'Medication'**
  String get medication;

  /// No description provided for @pregnancy.
  ///
  /// In en, this message translates to:
  /// **'Pregnancy'**
  String get pregnancy;

  /// No description provided for @showQrcode.
  ///
  /// In en, this message translates to:
  /// **'Please show doctor or nurse this screen.'**
  String get showQrcode;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed.'**
  String get loginFailed;

  /// No description provided for @questionnaireTitle.
  ///
  /// In en, this message translates to:
  /// **'Questionnaire'**
  String get questionnaireTitle;

  /// No description provided for @questionnaireLoginRequired.
  ///
  /// In en, this message translates to:
  /// **'Login is required to view this questionnaire.'**
  String get questionnaireLoginRequired;

  /// No description provided for @questionnairePermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to view this questionnaire. Please log in with an approved doctor account.'**
  String get questionnairePermissionDenied;

  /// No description provided for @questionnaireIdMissing.
  ///
  /// In en, this message translates to:
  /// **'Questionnaire ID is missing.'**
  String get questionnaireIdMissing;

  /// No description provided for @questionnaireNotFound.
  ///
  /// In en, this message translates to:
  /// **'The specified questionnaire data was not found.'**
  String get questionnaireNotFound;

  /// No description provided for @questionnaireNoData.
  ///
  /// In en, this message translates to:
  /// **'No questionnaire data available.'**
  String get questionnaireNoData;

  /// No description provided for @questionnaireDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Questionnaire Data'**
  String get questionnaireDataTitle;

  /// No description provided for @loginButtonText.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get loginButtonText;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginTitle;

  /// No description provided for @firestoreError.
  ///
  /// In en, this message translates to:
  /// **'Firestore Error'**
  String get firestoreError;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ja': return AppLocalizationsJa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
