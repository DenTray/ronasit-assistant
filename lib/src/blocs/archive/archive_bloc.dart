import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ronas_assistant/src/blocs/archive/events/change_date_to_event.dart';
import 'package:ronas_assistant/src/models/archive_statistic.dart';
import 'archive_state.dart';
import 'events/base_archive_event.dart';
import 'package:ronas_assistant/src/models/user.dart';
import 'package:ronas_assistant/src/resources/repositories/users_repository.dart';
import 'package:ronas_assistant/src/resources/repositories/statistics_repository.dart';
import 'events/change_date_from_event.dart';
import 'events/fetch_archive_event.dart';

class ArchiveBloc extends Bloc<BaseArchiveEvent, ArchiveState> {
  final _usersRepository = UsersRepository.getInstance();
  final _statisticsRepository = StatisticsRepository.getInstance();

  ArchiveBloc() : super(ArchiveState()) {
    on<FetchArchiveEvent>((event, emit) async {
      emit(this.state.copyWith(isLoading: true));

      User user = await _usersRepository.getCurrentUser();
      ArchiveStatistic statistic = await _statisticsRepository.getTimeByDateRange(user.userName, state.fromDate, state.toDate);

      emit(this.state.copyWith(
        isLoading: false,
        statistic: statistic
      ));
    });

    on<ChangeDateToEvent>((event, emit) async {
      emit(this.state.copyWith(
        toDate: event.date
      ));

      this.add(FetchArchiveEvent());
    });

    on<ChangeDateFromEvent>((event, emit) async {
      emit(this.state.copyWith(
        fromDate: event.date
      ));

      this.add(FetchArchiveEvent());
    });
  }
}