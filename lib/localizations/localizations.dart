import 'package:face_app/localizations/localized_values.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppLocalizations {
  final String locale;

  final Map<String, String> values;
  AppLocalizations(this.locale) : values = localizedValues[locale];

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  String get femaleGender => values['femaleGender'];
  String get maleGender => values['maleGender'];
  String get otherGender => values['otherGender'];
  String get sportsInterest => values['sportsInterest'];
  String get musicInterest => values['musicInterest'];
  String get readingInterest => values['readingInterest'];
  String get writingInterest => values['writingInterest'];
  String get artsInterest => values['artsInterest'];
  String get dancingInterest => values['dancingInterest'];
  String get gardeningInterest => values['gardeningInterest'];
  String get bakingInterest => values['bakingInterest'];
  String get moviesInterest => values['moviesInterest'];
  String get travellingInterest => values['travellingInterest'];
  String get noEmail => values['noEmail'];
  String get wrongEmail => values['wrongEmail'];
  String get noPassword => values['noPassword'];
  String get notMatchingPasswords => values['notMatchingPasswords'];
  String get wrongPassword => values['wrongPassword'];
  String get weakPassword => values['weakPassword'];
  String get emailAlreadyInUse => values['emailAlreadyInUse'];
  String get invalidEmail => values['invalidEmail'];
  String get wrongPasswordError => values['wrongPasswordError'];
  String get userNotFound => values['userNotFound'];
  String get userDisabled => values['userDisabled'];
  String get tooManyRequests => values['tooManyRequests'];
  String get sendTheFirstMessage => values['sendTheFirstMessage'];
  String get sendAMessage => values['sendAMessage'];
  String get noChatPartner => values['noChatPartner'];
  String get chat => values['chat'];
  String get search => values['search'];
  String get gallery => values['gallery'];
  String get description => values['description'];
  String get interests => values['interests'];
  String get attractedTo => values['attractedTo'];
  String get discover => values['discover'];
  String get noMoreCards => values['noMoreCards'];
  String get profile => values['profile'];
  String get makeNewPhoto => values['makeNewPhoto'];
  String get pickFromGallery => values['pickFromGallery'];
  String get changeAppColor => values['changeAppColor'];
  String get chooseColor => values['chooseColor'];
  String get cancel => values['cancel'];
  String get save => values['save'];
  String get edit => values['edit'];
  String get logOut => values['logOut'];
  String get aboutMe => values['aboutMe'];
  String get name => values['name'];
  String get whereAreYou => values['whereAreYou'];
  String get selectedMyself => values['selectedMyself'];
  String get forgotPassword => values['forgotPassword'];
  String get emailAddress => values['emailAddress'];
  String get resetPassword => values['resetPassword'];
  String get failedToRequestNewPassword => values['failedToRequestNewPassword'];
  String get passwordResetEmailSent => values['passwordResetEmailSent'];
  String get or => values['or'];
  String get signInFailed => values['signInFailed'];
  String get signInWithGoogle => values['signInWithGoogle'];
  String get password => values['password'];
  String get passwordAgain => values['passwordAgain'];
  String get registerFailed => values['registerFailed'];
  String get register => values['register'];
  String get signIn => values['signIn'];
  String get existing => values['existing'];
  String get newAccount => values['newAccount'];
  String get attractedToQuestion => values['attractedToQuestion'];
  String get birthDateQuestion => values['birthDateQuestion'];
  String get colorQuestion => values['colorQuestion'];
  String get descriptionQuestion => values['descriptionQuestion'];
  String get descriptionHint => values['descriptionHint'];
  String get genderQuestion => values['genderQuestion'];
  String get interestsQuestion => values['interestsQuestion'];
  String get nameQuestion => values['nameQuestion'];
  String get nameHint => values['nameHint'];
  String get imageQuestion => values['imageQuestion'];
  String get imageHint => values['imageHint'];
  String get newImage => values['newImage'];
  String get existingImage => values['existingImage'];
  String get summaryText => values['summaryText'];
  String get summaryHint => values['summaryHint'];
  String get summeryFinish => values['summeryFinish'];
  String get invalidForm => values['invalidForm'];
  String get noFace => values['noFace'];
  String get mName => values['mName'];
  String get mDate => values['mDate'];
  String get mAttractedTo => values['mAttractedTo'];
  String get mInterests => values['mInterests'];
  String get mDescription => values['mDescription'];
  String get dateFormat => values['dateFormat'];
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations('hu'));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => true;
}
