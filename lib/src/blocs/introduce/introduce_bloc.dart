import 'introduce_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ronas_assistant/src/models/user.dart';
import 'package:ronas_assistant/src/blocs/introduce/events/login_event.dart';
import 'package:ronas_assistant/src/resources/repositories/users_repository.dart';
import 'package:ronas_assistant/src/blocs/introduce/events/base_introduce_event.dart';
import 'package:ronas_assistant/src/blocs/introduce/events/update_username_event.dart';
import 'package:ronas_assistant/src/resources/api_providers/ronas_it_api_provider.dart';
import 'package:ronas_assistant/src/blocs/introduce/events/update_last_name_event.dart';
import 'package:ronas_assistant/src/blocs/introduce/events/update_first_name_event.dart';
import 'package:ronas_assistant/src/blocs/introduce/events/recalculate_login_button_event.dart';
import 'package:ronas_assistant/src/blocs/introduce/events/edit_username_mode_update_event.dart';

class IntroduceBloc extends Bloc<BaseIntroduceEvent, IntroduceState> {
  final RonasITApiProvider api = RonasITApiProvider.getInstance();
  final UsersRepository _usersRepository = UsersRepository.getInstance();

  IntroduceBloc() : super(IntroduceState()) {
    on<UpdateFirstNameEvent>((event, emit) {
      emit(state.copyWith(
        firstName: event.value
      ));

      add(UpdateUsernameEvent(generateUsername(event.value, state.lastName)));
    });

    on<UpdateLastNameEvent>((event, emit) {
      emit(state.copyWith(
        lastName: event.value
      ));

      add(UpdateUsernameEvent(generateUsername(state.firstName, event.value)));
    });

    on<EditUsernameModeUpdate>((event, emit) {
      emit(state.copyWith(
        isEditUserNameModeEnabled: event.value
      ));
    });

    on<UpdateUsernameEvent>((event, emit) {
      emit(state.copyWith(
        authError: '',
        userName: event.value
      ));

      add(RecalculateLoginButtonEvent());
    });

    on<RecalculateLoginButtonEvent>((event, emit) {
      emit(state.copyWith(
        isLoginButtonEnabled: state.userName.length > 3 && state.authError.isEmpty
      ));
    });

    on<LoginEvent>((event, emit) async {
      emit(state.copyWith(
        isLoginButtonEnabled: false
      ));

      try {
        await api.fetchTime(state.userName);

        await _usersRepository.setCurrentUser(User(
          state.firstName,
          state.lastName,
          state.userName,
        ));

        Navigator.pushNamedAndRemoveUntil(event.context, '/main', (route) => false);
      } catch (error) {
        emit(state.copyWith(
          authError: 'not_exists'
        ));
      }
    });
  }

  generateUsername(String firstname, String lastName) {
    String firstLatter = (firstname.isNotEmpty) ? firstname.characters.first.toLowerCase() : '';

    return '$firstLatter${lastName.toLowerCase()}';
  }
}