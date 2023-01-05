import 'earn_state.dart';
import '../../models/statistic.dart';
import '../../resources/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../resources/settings_repository.dart';
import '../../resources/statistic_repository.dart';
import 'package:ronas_assistant/src/models/user.dart';
import 'package:ronas_assistant/src/models/settings.dart';
import 'package:ronas_assistant/src/blocs/earn/events/base_earn_event.dart';
import 'package:ronas_assistant/src/blocs/earn/events/fetch_earn_event.dart';
import 'package:ronas_assistant/src/blocs/earn/events/refresh_earn_event.dart';

class EarnBloc extends Bloc<BaseEarnEvent, EarnState> {
  final _userRepository = UserRepository.getInstance();
  final _settingsRepository = SettingsRepository.getInstance();
  final _statisticRepository = StatisticRepository.getInstance();

  bool isLoading = false;

  EarnBloc() : super(EarnState()) {
    on<FetchEarnEvent>((event, emit) async {
      runRefreshIconRotation();

      Settings settings = await _settingsRepository.getSettings();
      User user = await _userRepository.getUser();
      Statistic statistic = await _statisticRepository.getTime(user.userName);

      isLoading = false;

      emit(state.copyWith(
        statistic: statistic,
        rate: settings.rate
      ));
    });

    on<RefreshEarnEvent>((event, emit) async {
      _statisticRepository.resetCache();

      add(FetchEarnEvent());
    });
  }

  runRefreshIconRotation() async {
    isLoading = true;

    do {
      emit(state.copyWith(
        isLoading: isLoading,
        refreshIconAngle: state.refreshIconAngle += 0.1
      ));

      await Future.delayed(const Duration(milliseconds: 10));
    } while (isLoading);
  }
}