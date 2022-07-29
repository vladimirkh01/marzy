enum AccountEditingType {
  email,
  phone,
}

extension AccountEditingTypeTitle on AccountEditingType {
  String get title {
    switch (this) {
      case AccountEditingType.email:
        return 'Изменить почту';
      case AccountEditingType.phone:
        return 'Изменить номер';
      default:
        return '';
    }
  }

  String get edit1Subtitle {
    switch (this) {
      case AccountEditingType.email:
        return 'Для изменения почты подтвердите свое действие и нажмите кнопку ниже';
      case AccountEditingType.phone:
        return 'Для изменения номера подтвердите свое действие и нажмите кнопку ниже';
      default:
        return '';
    }
  }
}

enum UserType {
  courier,
  customer,
}

enum HomePageType {
  products,
  medicines,
  other,
}

enum AuthErrorsTypes {
  login,
  email,
  phone,
  password,
  passwordRepeat,
  code,
  sureName,
  name,
  date,
}
