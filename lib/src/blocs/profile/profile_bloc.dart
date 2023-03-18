import 'profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ronas_assistant/src/models/user.dart';
import 'package:ronas_assistant/src/blocs/profile/events/logout_event.dart';
import 'package:ronas_assistant/src/blocs/profile/events/full_avatar_event.dart';
import 'package:ronas_assistant/src/resources/repositories/users_repository.dart';
import 'package:ronas_assistant/src/blocs/profile/events/small_avatar_event.dart';
import 'package:ronas_assistant/src/blocs/profile/events/base_profile_event.dart';
import 'package:ronas_assistant/src/blocs/profile/events/loaded_avatar_event.dart';
import 'package:ronas_assistant/src/blocs/profile/events/fetch_profile_event.dart';
import 'package:ronas_assistant/src/resources/repositories/statistics_repository.dart';

class ProfileBloc extends Bloc<BaseProfileEvent, ProfileState> {
  final _usersRepository = UsersRepository.getInstance();
  final _statisticsRepository = StatisticsRepository.getInstance();

  ProfileBloc() : super(ProfileState(isLoading: true)) {
    on<FetchProfileEvent>((event, emit) async {
      emit(state.copyWith(
        isLoading: true
      ));

      User user = await _usersRepository.getCurrentUser();

      emit(state.copyWith(
        user: user,
        isLoading: false
      ));
    });

    on<LogoutEvent>((event, emit) async {
      emit(state.copyWith(
        isLoading: true
      ));

      await _usersRepository.resetCurrentUser();
      _statisticsRepository.resetCache();

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