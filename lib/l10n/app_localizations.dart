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
  /// **'An expexted error has occurred.'**
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
