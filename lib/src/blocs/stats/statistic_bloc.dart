import 'statistic_state.dart';
import '../../models/statistic.dart';
import '../../resources/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../resources/settings_repository.dart';
import '../../resources/statistic_repository.dart';
import 'package:ronas_assistant/src/models/user.dart';
import 'package:ronas_assistant/src/models/settings.dart';
import 'package:ronas_assistant/src/blocs/stats/events/base_statistic_event.dart';
import 'package:ronas_assistant/src/blocs/stats/events/fetch_statistic_event.dart';
import 'package:ronas_assistant/src/blocs/stats/events/set_remain_mode_event.dart';
import 'package:ronas_assistant/src/blocs/stats/events/refresh_statistic_event.dart';

class StatisticBloc extends Bloc<BaseStatisticEvent, StatisticState> {
  final _userRepository = UserRepository.getInstance();
  final _settingsRepository = SettingsRepository.getInstance();
  final _statisticRepository = StatisticRepository.getInstance();

  bool isLoading = false;

  StatisticBloc() : super(StatisticState()) {
    on<FetchStatisticEvent>((event, emit) async {
      runRefreshIconRotation();

      Settings settings = await _settingsRepository.getSettings();
      User user = await _userRepository.getUser();
      Statistic statistic = await _statisticRepository.getTime(user.userName);

      isLoading = false;

      emit(state.copyWith(
        statistic: statistic,
        preferableWorkingDaysCount: settings.preferredWorkingDaysCount,
        isRemainModeEnabled: settings.isRemainModeEnabled
      ));
    });

    on<RefreshStatisticEvent>((event, emit) async {
      _statisticRepository.resetCache();

      add(FetchStatisticEvent());
    });

    on<SetRemainModeEvent>((event, emit) async {
      emit(state.copyWith(
        isLoading: true
      ));

      await _settingsRepository.updateRemainMode(event.remainMode);

      emit(state.copyWith(
        isRemainModeEnabled: event.remainMode,
        isLoading: false
      ));
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