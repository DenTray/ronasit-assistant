import 'package:ronas_assistant/src/models/user.dart';
import 'package:ronas_assistant/src/support/helpers.dart';

class ProfileState {
  bool isLoading = true;
  User? user;

  String? smallAvatarLink;

  ProfileState({ User? user, bool isLoading = false }) {
    this.isLoading = isLoading;
    this.user = user;

    if (user != null) {
      smallAvatarLink = 'https://www.gravatar.com/avatar/${Helpers.generateMd5(user.email)}?s=200';
    }
  }

  ProfileState copyWith({
    bool? isLoading = false,
    User? user,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
    );
  }
}