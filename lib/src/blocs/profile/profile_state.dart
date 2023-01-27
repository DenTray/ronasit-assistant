import 'package:ronas_assistant/src/models/user.dart';
import 'package:ronas_assistant/src/support/helpers.dart';

class ProfileState {
  bool isLoading = true;
  bool isAvatarLoaded = false;
  bool isFullAvatarMode = false;
  User? user;

  String? avatarLink;

  ProfileState({ User? user, bool isLoading = false, bool isFullAvatarMode = false, bool isAvatarLoaded = false }) {
    this.isLoading = isLoading;
    this.user = user;
    this.isFullAvatarMode = isFullAvatarMode;
    this.isAvatarLoaded = isAvatarLoaded;

    if (user != null) {
      avatarLink = 'https://www.gravatar.com/avatar/${Helpers.generateMd5(user.email)}?s=2000';
    }
  }

  ProfileState copyWith({
    bool? isLoading,
    bool? isFullAvatarMode,
    bool? isAvatarLoaded,
    User? user,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      isAvatarLoaded: isAvatarLoaded ?? this.isAvatarLoaded,
      isFullAvatarMode: isFullAvatarMode ?? this.isFullAvatarMode,
    );
  }
}