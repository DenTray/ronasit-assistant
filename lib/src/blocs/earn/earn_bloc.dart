import 'earn_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ronas_assistant/src/models/user.dart';
import 'package:ronas_assistant/src/models/currency.dart';
import 'package:ronas_assistant/src/models/settings.dart';
import 'package:ronas_assistant/src/models/exchange.dart';
import 'package:ronas_assistant/src/models/statistic.dart';
import 'package:ronas_assistant/src/blocs/earn/events/base_earn_event.dart';
import 'package:ronas_assistant/src/blocs/earn/events/fetch_earn_event.dart';
import 'package:ronas_assistant/src/blocs/earn/events/refresh_earn_event.dart';
import 'package:ronas_assistant/src/resources/repositories/users_repository.dart';
import 'package:ronas_assistant/src/resources/repositories/settings_repository.dart';
import 'package:ronas_assistant/src/resources/repositories/statistics_repository.dart';
import 'package:ronas_assistant/src/resources/repositories/currencies_repository.dart';
import 'package:ronas_assistant/src/blocs/earn/events/change_displayed_currency_event.dart';

class EarnBloc extends Bloc<BaseEarnEvent, EarnState> {
  final _usersRepository = UsersRepository.getInstance();
  final _settingsRepository = SettingsRepository.getInstance();
  final _statisticsRepository = StatisticsRepository.getInstance();
  final _currenciesRepository = CurrenciesRepository.getInstance();

  bool isLoading = false;

  EarnBloc() : super(EarnState()) {
    on<FetchEarnEvent>((event, emit) async {
      runRefreshIconRotation();

      Settings settings = await _settingsRepository.getSettings();
      User user = await _usersRepository.getCurrentUser();
      Statistic statistic = await _statisticsRepository.getTime(user.userName);
      List<Currency> currencies = await _currenciesRepository.getCurrencies();
      Currency displayedCurrency = currencies[settings.displayedCurrencySymbolIndex];
      //TODO get rate currency
      Exchange exchange = await _currenciesRepository.getExchange('USD', displayedCurrency.symbol);

      emit(state.copyWith(
        statistic: statistic,
        rate: settings.rate,
        currencies: currencies,
        displayedCurrency: displayedCurrency,
        exchangeRate: exchange.rate
      ));

      isLoading = false;
    });

    on<RefreshEarnEvent>((event, emit) async {
      _statisticsRepository.resetCache();
      _currenciesRepository.resetCache();

      add(FetchEarnEvent());
    });

    on<ChangeDisplayedCurrencyEvent>((event, emit) async {
      Currency? displayedCurrency = state.currencies?[event.currencyIndex];

      //TODO get rate currency
      Exchange exchange = await _currenciesRepository.fetchExchange('USD', displayedCurrency!.symbol);
      await _settingsRepository.updateExchangeCurrency(event.currencyIndex);

      emit(state.copyWith(
        displayedCurrency: displayedCurrency,
        exchangeRate: exchange.rate
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