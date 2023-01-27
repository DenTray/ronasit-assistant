import 'profile_state.dart';
import '../../resources/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ronas_assistant/src/models/user.dart';
import 'package:ronas_assistant/src/resources/statistic_repository.dart';
import 'package:ronas_assistant/src/blocs/profile/events/logout_event.dart';
import 'package:ronas_assistant/src/blocs/profile/events/full_avatar_event.dart';
import 'package:ronas_assistant/src/blocs/profile/events/small_avatar_event.dart';
import 'package:ronas_assistant/src/blocs/profile/events/base_profile_event.dart';
import 'package:ronas_assistant/src/blocs/profile/events/loaded_avatar_event.dart';
import 'package:ronas_assistant/src/blocs/profile/events/fetch_profile_event.dart';

class ProfileBloc extends Bloc<BaseProfileEvent, ProfileState> {
  final _userRepository = UserRepository.getInstance();
  final _statisticRepository = StatisticRepository.getInstance();

  ProfileBloc() : super(ProfileState(isLoading: true)) {
    on<FetchProfileEvent>((event, emit) async {
      emit(state.copyWith(
        isLoading: true
      ));

      User user = await _userRepository.getUser();

      emit(state.copyWith(
        user: user,
        isLoading: false
      ));
    });

    on<LogoutEvent>((event, emit) async {
      emit(state.copyWith(
        isLoading: true
      ));

      await _userRepository.removeUser();
      _statisticRepository.resetCache();

      emit(state.copyWith(
        isLoading: false
      ));
    });

    on<SmallAvatarEvent>((event, emit) async {
      emit(state.copyWith(
        isFullAvatarMode: false
      ));
    });

    on<FullAvatarEvent>((event, emit) async {
      emit(state.copyWith(
        isFullAvatarMode: true
      ));
    });

    on<LoadedAvatarEvent>((event, emit) async {
      emit(state.copyWith(
        isAvatarLoaded: true
      ));
    });
  }
}