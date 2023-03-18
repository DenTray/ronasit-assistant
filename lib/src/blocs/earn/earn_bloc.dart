import 'earn_state.dart';
import '../../models/statistic.dart';
import '../../resources/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../resources/settings_repository.dart';
import '../../resources/statistic_repository.dart';
import '../../resources/currencies_repository.dart';
import 'package:ronas_assistant/src/models/user.dart';
import 'package:ronas_assistant/src/models/currency.dart';
import 'package:ronas_assistant/src/models/settings.dart';
import 'package:ronas_assistant/src/models/exchange.dart';
import 'package:ronas_assistant/src/blocs/earn/events/base_earn_event.dart';
import 'package:ronas_assistant/src/blocs/earn/events/fetch_earn_event.dart';
import 'package:ronas_assistant/src/blocs/earn/events/refresh_earn_event.dart';
import 'package:ronas_assistant/src/blocs/earn/events/change_currency_event.dart';

class EarnBloc extends Bloc<BaseEarnEvent, EarnState> {
  final _userRepository = UserRepository.getInstance();
  final _settingsRepository = SettingsRepository.getInstance();
  final _statisticRepository = StatisticRepository.getInstance();
  final _currencyRepository = CurrenciesRepository.getInstance();

  bool isLoading = false;

  EarnBloc() : super(EarnState()) {
    on<FetchEarnEvent>((event, emit) async {
      runRefreshIconRotation();

      Settings settings = await _settingsRepository.getSettings();
      User user = await _userRepository.getUser();
      Statistic statistic = await _statisticRepository.getTime(user.userName);
      List<Currency> currencies = await _currencyRepository.getCurrencies();
      Currency currency = currencies[settings.exchangeCurrencySymbolIndex];
      //TODO get rate currency
      Exchange exchange = await _currencyRepository.getExchange('USD', currency.symbol);

      emit(state.copyWith(
        statistic: statistic,
        rate: settings.rate,
        currencies: currencies,
        currency: currency,
        quote: exchange.rate
      ));

      isLoading = false;
    });

    on<RefreshEarnEvent>((event, emit) async {
      _statisticRepository.resetCache();
      _currencyRepository.resetCache();

      add(FetchEarnEvent());
    });

    on<ChangeCurrencyEvent>((event, emit) async {
      Currency? currency = state.currencies?[event.currencyIndex];

      //TODO get rate currency
      Exchange exchange = await _currencyRepository.fetchExchange('USD', currency!.symbol);
      await _settingsRepository.updateExchangeCurrency(event.currencyIndex);

      emit(state.copyWith(
        currency: currency,
        quote: exchange.rate
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