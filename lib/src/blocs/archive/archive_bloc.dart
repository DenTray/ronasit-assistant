import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ronas_assistant/src/blocs/archive/events/change_date_to_event.dart';
import 'package:ronas_assistant/src/blocs/archive/events/range_events/choose_last_month_range_event.dart';
import 'package:ronas_assistant/src/blocs/archive/events/range_events/choose_last_week_range_event.dart';
import 'package:ronas_assistant/src/blocs/archive/events/range_events/choose_yesterday_range_event.dart';
import 'package:ronas_assistant/src/models/archive_statistic.dart';
import 'package:ronas_assistant/src/resources/repositories/currencies_repository.dart';
import 'package:ronas_assistant/src/resources/repositories/settings_repository.dart';
import 'package:ronas_assistant/src/support/objects/sort_option.dart';
import '../../models/currency.dart';
import '../../models/exchange.dart';
import '../../models/settings.dart';
import 'archive_state.dart';
import 'package:ronas_assistant/src/models/report.dart';
import 'events/apply_sort_event.dart';
import 'events/base_archive_event.dart';
import 'package:ronas_assistant/src/models/user.dart';
import 'package:ronas_assistant/src/resources/repositories/users_repository.dart';
import 'package:ronas_assistant/src/resources/repositories/statistics_repository.dart';
import 'events/change_date_from_event.dart';
import 'events/choose_custom_range_event.dart';
import 'events/fetch_archive_event.dart';
import 'events/hide_sorting_window_event.dart';
import 'events/range_events/choose_last_year_range_event.dart';
import 'events/range_events/choose_this_year_range_event.dart';
import 'events/sorting_button_clicked_event.dart';
import 'events/sorting_window_state_changed_event.dart';

class ArchiveBloc extends Bloc<BaseArchiveEvent, ArchiveState> {
  final _usersRepository = UsersRepository.getInstance();
  final _statisticsRepository = StatisticsRepository.getInstance();
  final _settingsRepository = SettingsRepository.getInstance();
  final _currenciesRepository = CurrenciesRepository.getInstance();

  final List<SortOption> _sortingMap = [
    SortOption('project', true),
    SortOption('project', false),
    SortOption('hours', true),
    SortOption('hours', false),
  ];

  ArchiveBloc() : super(ArchiveState()) {
    on<FetchArchiveEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      User user = await _usersRepository.getCurrentUser();
      Settings settings = await _settingsRepository.getSettings();
      List<Currency> currencies = await _currenciesRepository.getCurrencies();
      ArchiveStatistic statistic = await _statisticsRepository.getTimeByDateRange(user.userName, state.fromDate, state.toDate);
      Currency rateCurrency = currencies[settings.rateCurrencyIndex];
      Currency displayedCurrency = currencies[settings.displayedCurrencySymbolIndex];
      Exchange exchange = await _currenciesRepository.getExchange(rateCurrency.symbol, displayedCurrency.symbol);

      emit(state.copyWith(
        isLoading: false,
        statistic: applySorting(state.sortingIndex, statistic),
        rate: settings.rate,
        exchangeRate: exchange.rate
      ));
    });

    on<ChangeDateToEvent>((event, emit) async {
      emit(state.copyWith(
        toDate: event.date
      ));

      add(FetchArchiveEvent());
    });

    on<ChangeDateFromEvent>((event, emit) async {
      emit(state.copyWith(
        fromDate: event.date
      ));

      add(FetchArchiveEvent());
    });

    on<ChooseCustomRangeEvent>((event, emit) async {
      emit(state.copyWith(
        isCustomModeEnabled: true
      ));
    });

    on<SortingButtonClickedEvent>((event, emit) async {
      emit(state.copyWith(
        isSortingWindowStateChanging: !state.isSortingWindowStateChanging,
        isSortingWindowOpened: (!state.isSortingWindowOpened) ? true : state.isSortingWindowOpened
      ));
    });

    on<SortingWindowStateChangedEvent>((event, emit) async {
      emit(state.copyWith(
        isSortingWindowOpened: state.isSortingWindowStateChanging
      ));
    });

    on<HideSortingWindowEvent>((event, emit) async {
      if (state.isSortingWindowOpened) {
        add(SortingButtonClickedEvent());
      }
    });

    on<ApplySortEvent>((event, emit) async {
      add(SortingButtonClickedEvent());

      emit(state.copyWith(
        sortingIndex: event.currentSortingIndex,
        statistic: applySorting(event.currentSortingIndex, state.statistic!)
      ));
    });

    on<ChooseYesterdayRangeEvent>((event, emit) async {
      emit(state.copyWith(
        isCustomModeEnabled: false,
        fromDate: DateTime.now().subtract(Duration(days: 1)),
        toDate: DateTime.now().subtract(Duration(days: 1))
      ));

      add(FetchArchiveEvent());
    });

    on<ChooseLastWeekRangeEvent>((event, emit) async {
      DateTime now = DateTime.now();

      emit(state.copyWith(
        isCustomModeEnabled: false,
        fromDate: now.subtract(Duration(days: DateTime.daysPerWeek + now.weekday - 1)),
        toDate: now.subtract(Duration(days: now.weekday))
      ));

      add(FetchArchiveEvent());
    });

    on<ChooseLastMonthRangeEvent>((event, emit) async {
      DateTime now = DateTime.now();

      emit(state.copyWith(
        isCustomModeEnabled: false,
        fromDate: DateTime(now.year, now.month - 1, 1),
        toDate: DateTime(now.year, now.month, 0)
      ));

      add(FetchArchiveEvent());
    });

    on<ChooseLastYearRangeEvent>((event, emit) async {
      DateTime now = DateTime.now();

      emit(state.copyWith(
        isCustomModeEnabled: false,
        fromDate: DateTime(now.year - 1, 1, 1),
        toDate: DateTime(now.year, 1, 0)
      ));

      add(FetchArchiveEvent());
    });

    on<ChooseThisYearRangeEvent>((event, emit) async {
      DateTime now = DateTime.now();

      emit(state.copyWith(
        isCustomModeEnabled: false,
        fromDate: DateTime(now.year, 1, 1),
        toDate: DateTime(now.year, now.month, now.day)
      ));

      add(FetchArchiveEvent());
    });
  }

  ArchiveStatistic applySorting(int sortingIndex, ArchiveStatistic statistic) {
    String field = _sortingMap[sortingIndex].fieldName;
    bool isAsc = _sortingMap[sortingIndex].isAsc;

    statistic.projects.sort((Report first, Report second) => (isAsc)
      ? first.getProp(field).compareTo(second.getProp(field))
      : second.getProp(field).compareTo(first.getProp(field))
    );

    return statistic;
  }
}