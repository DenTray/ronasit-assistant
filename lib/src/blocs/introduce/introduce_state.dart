class IntroduceState {
  String userName = '';
  String lastName = '';
  String firstName = '';
  String authError = '';
  bool isLoginButtonEnabled = false;
  bool isEditUserNameModeEnabled = false;

  IntroduceState({
    String? firstName,
    String? lastName,
    String? userName,
    bool? isEditUserNameModeEnabled,
    bool? isLoginButtonEnabled,
    String? authError,
  }) {
    if (firstName != null) {
      this.firstName = firstName;
    }

    if (lastName != null) {
      this.lastName = lastName;
    }

    if (userName != null) {
      this.userName = userName;
    }

    if (isEditUserNameModeEnabled != null) {
      this.isEditUserNameModeEnabled = isEditUserNameModeEnabled;
    }

    if (isLoginButtonEnabled != null) {
      this.isLoginButtonEnabled = isLoginButtonEnabled;
    }

    if (authError != null) {
      this.authError = authError;
    }
  }

  IntroduceState copyWith({
    String? firstName,
    String? lastName,
    String? userName,
    String? authError,
    bool? isLoginButtonEnabled,
    bool? isEditUserNameModeEnabled,
  }) {
    return IntroduceState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      userName: userName ?? this.userName,
      authError: authError ?? this.authError,
      isLoginButtonEnabled: isLoginButtonEnabled ?? this.isLoginButtonEnabled,
      isEditUserNameModeEnabled: isEditUserNameModeEnabled ?? this.isEditUserNameModeEnabled,
    );
  }
}