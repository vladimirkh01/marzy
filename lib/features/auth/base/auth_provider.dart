import 'package:marzy/logic/base/base_provider.dart';
import 'package:marzy/shared/enums/AppEnums.dart';

class AuthProvider extends BaseProvider {
  Map<AuthErrorsTypes, String> _errors = Map();

  void addError({required AuthErrorsTypes type, required String error}) {
    _errors[type] = error;
    notifyListeners();
  }

  set errors(Map<AuthErrorsTypes, String> value) {
    _errors = value;
    notifyListeners();
  }

  String getError(AuthErrorsTypes type) {
    return _errors[type] ?? "";
  }

  void clearErrors() {
    _errors = Map();
    notifyListeners();
  }

  void removeError(AuthErrorsTypes type) {
    _errors.remove(type);
    notifyListeners();
  }

  String get loginError {
    return getError(AuthErrorsTypes.login);
  }

  String get passwordError {
    return getError(AuthErrorsTypes.password);
  }

  String get passwordRepeatError {
    return getError(AuthErrorsTypes.passwordRepeat);
  }

  String get codeError {
    return getError(AuthErrorsTypes.code);
  }

  String get emailError {
    return getError(AuthErrorsTypes.email);
  }

  String get sureNameError {
    return getError(AuthErrorsTypes.sureName);
  }

  String get nameError {
    return getError(AuthErrorsTypes.name);
  }

  String get dateError {
    return getError(AuthErrorsTypes.date);
  }
}
